#!/usr/bin/env python3
#
import argparse, getpass, ssl, os, json, time, re
from pyVmomi import vmodl, vim, SoapStubAdapter
from pyVim import connect
from datetime import datetime

# Zaigui Wang, Dec 2020, based on the disk-change-mode.py sample script
# with session management, faster search, multiple vms handling, multiple attribute modifications etc.
#
def get_args():
    parser = argparse.ArgumentParser(description='Chaning vmdk mode/sharing option. Arguments for talking to vCenter')
    parser.add_argument('-v', '--vm', required=True,action='store',  help='Name of the VirtualMachine')
    parser.add_argument('-s', '--server', required=True, action='store', help='vcenter to connect to')
    parser.add_argument('-u', '--user', required=True, action='store', help='user')
    parser.add_argument('-p', '--password', required=False, action='store', help='password')
    parser.add_argument('-d', '--disknumber', required=True,action='store',  help='Disk number to change mode.')
    parser.add_argument('-m', '--mode', required=True, action='store', \
            choices=['independent_persistent', 'persistent', 'independent_nonpersistent', 'nonpersistent', 'undoable', 'append','sharingNone','sharingMultiWriter'])
    parser.add_argument('-l', '--list', required=False, action='store_true', help='list disks only. -m option ignored')
    args = parser.parse_args()
    return args

# add some colors to the output makes it easier to parse
class colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[33m'
    RED = '\033[031m'
    BOLD = '\033[1m'
    FLASH = '\033[5m'
    RESET = '\033[0m'

def create_session(vc,user):
    context = ssl._create_unverified_context()
    filename = ".session_info"
    session_file = os.path.expanduser("~") + "/" + filename

    # load session: load in existing session_data
    if os.path.exists(session_file):
        with open(session_file, "r") as f:
            session_data = f.read().strip()
            session_data = json.loads(session_data) if session_data else None
    else: session_data = None

    # this func is only needed within create_session(). So defined as a internal function.
    def new_session(data):
        if not args.password:
            args.password = getpass.getpass( prompt='Password for %s (%s): ' % (user, vc))

        try: conn = connect.SmartConnect(host=vc, user=user, pwd=args.password, port=443, sslContext=context)
        except vim.fault.InvalidLogin: raise SystemExit(colors.RED + "Invalid username or password." + colors.RESET)

        # save session: update session data to include the latest for this server.
        if data is None: data = {}
        data.update({vc: {'cookie': conn._stub.cookie, 'time': time.strftime("%Y-%m-%d %H:%M:%S"), 'version': conn._stub.version,}})
        data = json.dumps(data)
        with open(session_file, "w") as f: f.write(data)
        return conn

    host_session = session_data[vc] if session_data and vc in session_data else None
    if not host_session: return new_session(session_data)
    else:
        cookie, version, timestamp  = host_session['cookie'], host_session['version'], host_session['time']
        soapStub = SoapStubAdapter(host=vc, sslContext=context, version=version)
        conn = vim.ServiceInstance("ServiceInstance",soapStub)
        conn._stub.cookie = cookie
        current = time.strftime("%Y-%m-%d %H:%M:%S")
        delta = datetime.strptime(current,"%Y-%m-%d %H:%M:%S") - datetime.strptime(timestamp,"%Y-%m-%d %H:%M:%S")
        if conn.content.sessionManager.currentSession is None:
            print(f"Saved session terminated after {delta}. Authentication needed.")
            return new_session(session_data)
        else: return conn

def change_disk(si, vm, disknumber, mode):
    disk_label = 'Hard disk ' + str(disknumber)
    virtual_disk_device = None

    # Find the disk device
    devs = vm.config.hardware.device
    for dev in devs:
        if isinstance(dev, vim.vm.device.VirtualDisk) and dev.deviceInfo.label == disk_label:
            virtual_disk_device = dev
    if not virtual_disk_device:
        raise RuntimeError('Virtual {} could not be found.'.format(disk_label))

    virtual_disk_spec = vim.vm.device.VirtualDeviceSpec()
    virtual_disk_spec.operation = vim.vm.device.VirtualDeviceSpec.Operation.edit
    virtual_disk_spec.device = virtual_disk_device
    if mode == 'sharingNone' or mode == 'sharingMultiWriter': virtual_disk_spec.device.backing.sharing = mode
    else: virtual_disk_spec.device.backing.diskMode = mode

    dev_changes = []
    dev_changes.append(virtual_disk_spec)
    spec = vim.vm.ConfigSpec()
    spec.deviceChange = dev_changes
    task = vm.ReconfigVM_Task(spec=spec)
    return task

def list_disk_mode(vm):
    devices = vm.config.hardware.device
    for dev in devices:
        if type(dev) == vim.vm.device.VirtualDisk:
            label = dev.deviceInfo.label
            mode = dev.backing.diskMode
            print(f"  {label}\t{mode}")

def wait_for_tasks(service_instance, tasks):
    property_collector = service_instance.content.propertyCollector
    task_list = [str(task) for task in tasks]
    # Create filter
    obj_specs = [vmodl.query.PropertyCollector.ObjectSpec(obj=task)
                 for task in tasks]
    property_spec = vmodl.query.PropertyCollector.PropertySpec(type=vim.Task, pathSet=[], all=True)

    filter_spec = vmodl.query.PropertyCollector.FilterSpec()
    filter_spec.objectSet = obj_specs
    filter_spec.propSet = [property_spec]
    pcfilter = property_collector.CreateFilter(filter_spec, True)
    try:
        version, state = None, None
        # Loop looking for updates till the state moves to a completed state.
        while len(task_list):
            update = property_collector.WaitForUpdates(version)
            for filter_set in update.filterSet:
                for obj_set in filter_set.objectSet:
                    task = obj_set.obj
                    for change in obj_set.changeSet:
                        if change.name == 'info':
                            state = change.val.state
                        elif change.name == 'info.state':
                            state = change.val
                        else:
                            continue

                        if not str(task) in task_list:
                            continue

                        if state == vim.TaskInfo.State.success:
                            # Remove task from taskList
                            task_list.remove(str(task))
                        elif state == vim.TaskInfo.State.error:
                            raise task.info.error
            # Move to next version
            version = update.version
    finally:
        if pcfilter:
            pcfilter.Destroy()

def get_objects_byname(si, vim_type, name):
    root = si.content.rootFolder
    container = si.content.viewManager.CreateContainerView(root, vim_type, True)
    view = container.view
    container.Destroy()
    objs = []
    if not view: return objs

    objSpecs = []
    for obj in view:
        objSpec = vmodl.query.PropertyCollector.ObjectSpec(obj=obj)
        objSpecs.append(objSpec)

    filterSpec = vmodl.query.PropertyCollector.FilterSpec()
    filterSpec.objectSet = objSpecs

    # since we got vim_type in a list context
    for type in vim_type:
        propSet = vmodl.query.PropertyCollector.PropertySpec(all=False)
        propSet.type = type
        propSet.pathSet = ['name']
        filterSpec.propSet.append(propSet)

    objects = []
    options = vmodl.query.PropertyCollector.RetrieveOptions()
    pCollector = si.content.propertyCollector
    result = pCollector.RetrievePropertiesEx([filterSpec], options)
    objects += result.objects
    while result.token is not None:
        result = pCollector.ContinueRetrievePropertiesEx(result.token)
        objects += result.objects

    for o in objects:
        if name and re.match(name, o.propSet[0].val, re.I): objs.append(o.obj)
        if not name: objs.append(o.obj)
    return objs

###############
args = get_args()
si = create_session(args.server, args.user)
content = si.RetrieveContent()
vms = get_objects_byname(si, [vim.VirtualMachine], args.vm)

for vm in vms:
    if args.list:
        print(f"{vm.name} - list of disks:")
        list_disk_mode(vm)
        continue
    print(f"{vm.name}:")
    task = change_disk(si, vm, args.disknumber, args.mode)
    wait_for_tasks(si, [task])
    print ('VM Disk {} successfully changed to mode {}.'.format(args.disknumber, args.mode))
