#!/usr/bin/perl -w
use strict;
use warnings;
use VMware::VILib;
use VMware::VIRuntime;
use Term::ANSIColor;
use VMware::VICredStore;
use Term::ReadKey; # install libterm-readkey-perl on Ubuntu
# migrate and clone ANY vm between ANY VCs. 
# Written by Zaigui Wang, June 2016.
# Inspired by: http://www.virtuallyghetto.com/2016/05/automating-cross-vcenter-vmotion-xvc-vmotion-between-the-same-different-sso-domain.html
# vm with indepedent disks, PR: https://bugzilla.vmware.com/show_bug.cgi?id=1680601
# cross-version provisioning, PR: https://bugzilla.eng.vmware.com/show_bug.cgi?id=1821397
# 10/5/2017: enabling skipdisk for cloning
# to do: use cluster as target...
# to do: allow an intermediary vss switch when network target becomes an issue.
# 
my %opts = ( op => {type=> "=s", help => "Operation type: move vs. clone.", required => 1},
	vm => { type => "=s", help => "Source Virtual Machine", required => 1},
	host => { type => "=s", help => "Target ESXi", required => 1},
	cluster => { type => "=s", help => "Target cluster. Ignored if host provided. Not implemented yet", required => 0},
	newvm => { type => "=s", help => "Target Virtual Machine Name. This only applies to clone operation", required => 0},
	server2 => { type => "=s", help => "Target VC. Assume same vc when omitted.", required => 0},
	ds => { type => "=s", help => "Target datastores. Default current. Use comma to separate multiples. Same placement pattern", required=>0},
	oneds => { type => "", help => "Collapse multiple ds onto one datastore. No argument needed", required => 0},
	rp => { type => "=s", help => "Target resource pool", required => 0, default => 'Resources'},
	folder => { type => "=s", help => "Target folder", required => 0, default => 'vm'},
	network => { type => "=s", help => "Target networks. One per NIC. Comma to specify multiples.  Default same networks",required=>0},
	snapshot => { type => "=s", help => "name of snapshot to clone from. First match when multiple of same name found. Current state if not provided", required => 0},
	skipdisk => { type => "=s", help => "Disks to exclude in the clone. For example 0:0. Use comma to delimit multiples", required => 0},
	nowait => { type => "", help => "Not wait for task to complete (a task cannot be canceled from this UI).", required => 0},
);
delete $ENV{'https_proxy'};
Opts::add_options(%opts);
Opts::parse();
Opts::validate();
##
my $op = Opts::get_option('op'); die "Invalid Operation type specified!" unless ($op eq 'move' || $op eq 'clone');
my $vmname = Opts::get_option('vm');
my $newVM = Opts::get_option('newvm'); $newVM = ($op eq 'move')?$vmname:($newVM)?$newVM:$vmname.".clone"; 
my $host = Opts::get_option('host'); 
my $cluster = Opts::get_option('cluster'); 
$host .= '.vmware.com' unless ($host =~ /\.vmware\.com/ || !$host);
die ("Need target host/cluster!") unless ($host || $cluster);
my $srcVC = Opts::get_option('server');
my $dstVC = Opts::get_option('server2');
my $ds_string = Opts::get_option('ds'); my @dss = split(',', $ds_string) if ($ds_string);
my $pg_string = Opts::get_option('network'); my @pgs = split(',', $pg_string) if ($pg_string);
my $rp = Opts::get_option('rp');
my $folder = Opts::get_option('folder');
my $oneds = Opts::option_is_set('oneds');
my $username = Opts::get_option('username');
my $password = Opts::get_option('password');
my $skipdisk_string = Opts::get_option('skipdisk');
my %skipdisk = map {$_ => 1} split(',', $skipdisk_string) if ($skipdisk_string);
print color("red")."Skipdisk applicable to cloning only. Ignored here...\n".color('reset') if (%skipdisk && $op eq 'move');
my $nowait = Opts::option_is_set('nowait');
my $snapshotName = Opts::get_option('snapshot');

###
my ($event, $srcVIM, $dstVIM, $vm_view, $host_view, $ds_view, $rp_view, $fd_view);
my @endpoint = (); #only need if cross-vc.
$srcVC .= '.vmware.com' unless ($srcVC =~ /\.vmware\.com/ || $srcVC =~ /\d+\.\d+\.\d+\.\d+/);
$srcVIM = Vim->new(service_url => "https://$srcVC/sdk");
print "\nEstablishing source VC connection -  ";
$srcVIM->login(user_name => $username, password => $password);
print "UUID: " . ${$srcVIM->get_service_content()}{'about'}->{'instanceUuid'} . "\n";

# if no Target VC specificed, or specificed the same VC sans the domain name. Set Target to source
if (!$dstVC || $srcVC =~  /$dstVC/) {
	$event = color('green') . "#### $op $vmname to $host within $srcVC ####" . color('reset');
	$dstVC = $srcVC;
	$dstVIM = $srcVIM;
}
else { # different VC in play
	my ($user2,$pass2);
	VMware::VICredStore::init() or &cleanUp("ERROR: Failed to initialize the credential store.\n");
	my @username = VMware::VICredStore::get_usernames (server => $dstVC);

	# if no user name is obtained, that means we did not find the cred in credstore. Ask for it.
	if (@username) {
		print "Retrieving $dstVC credential from credstore...";
		$user2 = $username[0]; # will read only the first entry as there is no way to knwo which entry you wanted.
		$pass2 = VMware::VICredStore::get_password(server => $dstVC, username => $user2);
		print "Got it!\n";
	} else {
		print "Need credential for $dstVC\n";
		print "$dstVC Username: "; ($user2 = ReadLine(0)) =~ s/[\r\n]+//g;
		print "$dstVC Password: "; ReadMode 2; ($pass2 = ReadLine(0)) =~ s/[\r\n]+//g; ReadMode 0; print "\n";
	}
	$dstVC .= '.vmware.com' unless ($dstVC =~ /\.vmware\.com/ || $dstVC =~ /\d+\.\d+\.\d+\.\d+/);
	$dstVIM = Vim->new(service_url => "https://$dstVC/sdk");
	print "Establishing Target VC connection - "; 
	$dstVIM->login(user_name => $user2, password => $pass2);
	print "UUID: " . ${$dstVIM->get_service_content()}{'about'}->{'instanceUuid'} . "\n";
	$event = color('green') . "#### ". ucfirst($op) ." $vmname in $srcVC to $host as $newVM in $dstVC ####" . color('reset');
	
	# build up the service locator, with ssl thumbprint, etc
	use Net::SSLeay qw(get_https3);
	my ($page, $response, $headers, $cert) = get_https3($dstVC, 443, '/');
	my $fingerprint = Net::SSLeay::X509_get_fingerprint($cert, "sha1");
	my $cred = ServiceLocatorNamePassword->new(username=>$user2, password=>$pass2);
	my $url="https://$dstVC";
	my $uuid = ${$dstVIM->get_service_content()}{'about'}->{'instanceUuid'};
	my $service = ServiceLocator->new(credential=>$cred, sslThumbprint=>$fingerprint, instanceUuid=>$uuid , url=>$url);
	@endpoint = (service => $service);
}

# SOURCE: VM and its whereabout
my @vmproperty = (properties=>['name','config.files.vmPathName','config.hardware.device','runtime.host','runtime.powerState', 'snapshot']);
$vm_view = $srcVIM->find_entity_view(view_type=>'VirtualMachine', filter=>{'name'=>qr/^$vmname$/i}, @vmproperty);
&cleanUp("Unable to find VM $vmname in $srcVC") unless $vm_view;

# CLONE only: figure out snapshot. If requested, confirm snapshot exist; Otherwise, set snapshot parameter to null for virtualmachineclonespec;
# If multiple snapshot of the same name found, we only care about the first match. Please rename your snapshot so that they are unique in names
my @ss = ();
if ($snapshotName && $op eq 'clone') {
	if (defined $vm_view->snapshot) {
		my $rootsnap = $vm_view->snapshot->rootSnapshotList;
		if (${$rootsnap}[0]->name eq $snapshotName) {
			@ss = (snapshot => ${$rootsnap}[0]->snapshot);
		}
		elsif (defined ${$rootsnap}[0]->childSnapshotList) {
			my $childlist = ${$rootsnap}[0]->childSnapshotList;
			while ($childlist) {
				if (${$childlist}[0]->name eq $snapshotName) { @ss = (snapshot => ${$childlist}[0]->snapshot); last; }
				elsif (defined ${$childlist}[0]->childSnapshotList) { $childlist = ${$childlist}[0]->childSnapshotList; }
				else { undef $childlist; print "\n"; }
			}
		}
	}
	&cleanUp("snapshot $snapshotName not found") unless @ss;
}

my $power = $vm_view->{'runtime.powerState'}->val;
my $h = $srcVIM->get_view(mo_ref=>$vm_view->{'runtime.host'}, properties => ['name']);
&cleanUp("Already on host. Exiting...") if ($h->name eq $host && $op eq 'move');

# SOURCE: Collect some NIC and vmdk information. Will have to pre-run this if need to get the slot info such as 0:0, 1:0, etc. The controller number has to be calculated, while the unit # is readily avail.
my (@nics, @vmdks, @vmdkToKeep, @vmdkSkipSpec, $ctrl, %ctrls);
my $devs = $vm_view->{'config.hardware.device'};
foreach (sort {$a->key cmp $b->key} @{$devs}) {
	if ($_->isa('VirtualEthernetCard')) {push (@nics, $_);}
	if ($_->isa('VirtualSCSIController')) { ($ctrl = $_->deviceInfo->label) =~ s/\D//g; $ctrls{$_->key} = $ctrl; }
	if ($_->isa('VirtualDisk')) { push(@vmdks, $_);}
}

#for cloning, we skip independent disks and any disks that is requested to be skipped. For move, all disks will go.
if ($op eq 'clone') {
	foreach (sort {$a->key cmp $b->key} @vmdks) {
		my ($diskBus, $diskUnit) = ($ctrls{$_->controllerKey}, $_->unitNumber);
		my $slot = $diskBus . ":" . $diskUnit;

		if (($_->backing->diskMode eq 'independent_persistent' && $power eq 'poweredOn') || $skipdisk{$slot}) {
			print "Skipping disk $slot: ".$_->backing->fileName . "\n";
			my $devOp = VirtualDeviceConfigSpecOperation->new('remove');
			push(@vmdkSkipSpec, VirtualDeviceConfigSpec->new(device=>$_, operation=>$devOp));
		} else { push(@vmdkToKeep,$_); }
	}
} else { @vmdkToKeep = @vmdks;}

# Target host (or cluster) 
$host_view = $dstVIM->find_entity_view(view_type => 'HostSystem', filter=>{'name' => $host}, properties => ['name','parent','datastore','runtime.inMaintenanceMode','network']);
&cleanUp("ESX host $host in $dstVC not found or not ready!") if (!$host_view || ($host_view->{'runtime.inMaintenanceMode'} eq 'True'));
print "Target host: $host (" . $host_view->{'mo_ref'}->{'value'}.")\n";

# get the target DC in case of multiple DCs in the target VC. Will use the DC as the begin_entity for folder search.
my $dc = $dstVIM->get_view(mo_ref => $host_view->parent, properties => ['name','parent']);
while (ref($dc) ne 'Datacenter') { $dc = $dstVIM->get_view(mo_ref => $dc->parent);}
print "Target DC: ". $dc->name ." (". $dc->{'mo_ref'}->{'value'} . ")\n";

# Target datastores
my @disk=();
my @diskLocator;
my $dstDsCount=0;
my %seen=();
my %dssMap=();# this maps srcDsName to dstDS, weird, but works.
my $dstDs; #temporary variable for diskLocator
my $cfgDs; # relospec need 'datastore' information. This is the config location. Using the first ds.
print "Target datastores:\n";
if ($oneds) {
	# all we need is to figure out which datastore. this could the existing vmx path, or as provided by -ds argument
	(my $srcDsName = $vm_view->{'config.files.vmPathName'}) =~ s/\[(.*?)\].*/$1/;
	my $dstDsName = ($dss[0])?$dss[0]:$srcDsName;
	foreach (@{$host_view->datastore}) {
		if (${$dstVIM->get_view(mo_ref=>$_, properties=>['name'])}{name} eq $dstDsName){
			$ds_view = $_;
			last; # Got it. no need to search further.
		}
	}
	if (!$ds_view) { &cleanUp("ERROR: Unable to find datastore $dss[$dstDsCount] on host $host");}
	print "\tCollapsing all disks to one DS: ". color('green'). $dstDsName . color('reset'). "\n";
	$cfgDs = $ds_view;
}
else {
	foreach my $vmdk (sort {$a->deviceInfo->label cmp $b->deviceInfo->label} @vmdkToKeep) { # sort them by label in order of "hard disk #1..."
		my $srcDsName = $vmdk->backing->fileName =~ s/\[(.*?)\].*/$1/r;
		if (!$seen{$srcDsName}++) { #new datastore
			if (! $dss[$dstDsCount]) {$dss[$dstDsCount] = $srcDsName;} #if user did not provide ds. Set it to same as src

			# now look to see if it exist on Target side
			my $ds_view;
			foreach (@{$host_view->datastore}) { if (${$dstVIM->get_view(mo_ref=>$_, properties=>['name'])}{name} eq $dss[$dstDsCount]){ $ds_view = $_;}}
			if (!$ds_view) { &cleanUp("ERROR: Unable to find datastore $dss[$dstDsCount] on host $host");}

			# OK we found the dstination ds ($ds_view)
			$dstDs = $ds_view;
			$dssMap{$srcDsName} = $ds_view;
			if ($dstDsCount == 0) { $cfgDs = $ds_view; }
			$dstDsCount++;
		} else { $dstDs = $dssMap{$srcDsName}; }# otherwise, we've seen this ds before and know which dstDs it goes to
		print "\t*". $vmdk->deviceInfo->label . ": ". ${$dstVIM->get_view(mo_ref=>$dstDs, properties=>['name'])}{name}. " (". $dstDs->value . ")\n";
		push @diskLocator, VirtualMachineRelocateSpecDiskLocator->new(diskId=>$vmdk->key, datastore=>$dstDs);
	}
	@disk = (disk => [@diskLocator]);
}

# Target resource pool (should be in the cluster)
$rp_view = $dstVIM->find_entity_view(view_type => 'ResourcePool', filter=>{'name'=>$rp}, begin_entity => $host_view->parent);
&cleanUp("ERROR: Unable to find the resource pool $rp on $host") unless $rp_view;
print "Target resource pool: $rp (". $rp_view->summary->config->entity->value. ")\n";

# Target folder (should be in the DC). Note that this parameter does not have to be set. We could set @folder = () unless folder is specified.
# When folder is specified and verified, we can set @folder = (folder => fd_view)
$fd_view = $dstVIM->find_entity_view(view_type => 'Folder', filter=>{'name'=>$folder}, begin_entity => $dc);
&cleanUp("ERROR: Unable to find the folder $folder") unless $fd_view;
print "Target folder: $folder (". $fd_view->{'mo_ref'}->{'value'}. ")\n";

# Target network details. For vss, pg name is all is required as pgs are unique; for vds, switch uuid and pg key are needed.
my (@devspec, $pgFound);
my $num = 0;
foreach my $nic (@nics) { 
	my $srcIsVds = (ref($nic->backing) ne 'VirtualEthernetCardNetworkBackingInfo')?1:0;

	#determine which pg to connect to (existing or specified). From existing pgname if necessary
	if (! defined $pgs[$num]) {
		my $srcPG;
		if ($srcIsVds) { $srcPG = ${$srcVIM->find_entity_view(view_type=>"DistributedVirtualPortgroup",properties=>['name','key'],
					filter=>{key=>$nic->backing->port->portgroupKey})}{'name'};} 
		else { $srcPG = $nic->backing->deviceName; }
		$pgs[$num] = $srcPG =~ s;%2f;/;gr;
	}

	# now that we have a pgname, let's see if we can locate it on the Target host. If so, we are good. Otherwise, get out
	$pgFound = 0;
	foreach my $net (@{$host_view->network}) {
		my $nv = $dstVIM->get_view(mo_ref=>$net);
		(my $dstPG = $nv->name)  =~ s;%2f;/;g;;
		my $dstIsVds = ($nv->summary->network->type eq 'DistributedVirtualPortgroup')?1:0;

		# found something!
		if ($dstPG eq $pgs[$num]) {
			############## case #1: to vDS. There is no restriction
			if ($dstIsVds) { 
				my $switchUuid = ${$dstVIM->get_view(mo_ref => $nv->config->distributedVirtualSwitch, properties => ['uuid'])}{'uuid'};
				my $pgkey = $nv->key;
				my $port = DistributedVirtualSwitchPortConnection->new(switchUuid=>$switchUuid, portgroupKey=>$pgkey);
				my $backing = VirtualEthernetCardDistributedVirtualPortBackingInfo->new(port=>$port);
				$nic->backing($backing);

				#this nifty substitution operator: /r will copy the input, massage it and return the result, without changing the original.
				print "Target distributed swtich for " . $nic->deviceInfo->label =~ s/Network adapter /NIC #/r.": $dstPG ($pgkey)\n";
				$pgFound = 1;
			}
			############# case #2: to vSS. Live migration won't work from vDS to vSS. Otherwise fine. Within VC, instead of migrate, we can work around it by re-assign the PG - not yet implemented.
			else { 
				print "Target vSS for " . $nic->deviceInfo->label =~ s/Network adapter /NIC #/r.": $dstPG\n";
				my $backing = VirtualEthernetCardNetworkBackingInfo->new(deviceName=>$dstPG);
				$nic->backing($backing);
				$pgFound = 1;

				# If vDS -> vSS, and VM powered on, LIVE move does not work. Clone is OK on the other hand.
				if ($srcIsVds && $power eq 'poweredOn' && $op eq 'move') {
					&cleanUp("LIVE migration from vDS to vSS not currently supported. Try to re-assign this vm to a vSS and then retry");
				}
			}
			last;
		}
	}

	# if portgroup found. 
	if ($pgFound) { push(@devspec, VirtualDeviceConfigSpec->new(operation => VirtualDeviceConfigSpecOperation->new('edit'), device => $nic));
	} else { &cleanUp("ERROR: Network $pgs[$num] for ". $nic->deviceInfo->label . " not found on target host");}
	$num++;
}

# RelocateSpec: datastore, deviceChange, disk, diskMoveType, folder, host, pool, profile, service (if not provided, the current VC used)
# Should provide a cluster or resource pool here for DRS to pick a host...
my $migrationPriority = VirtualMachineMovePriority->new('defaultPriority');
my $reloSpec = VirtualMachineRelocateSpec->new( datastore => $cfgDs, host => $host_view, folder => $fd_view, pool => $rp_view, deviceChange => [@devspec], @disk, @endpoint,);

# Unfortunately disk remove still has to happen within 'config' spec, not 'location'. Not checking the size of @vmdkToDlete hoping null is OK.
my $vmconfig = VirtualMachineConfigSpec->new( deviceChange => [@vmdkSkipSpec],);
my $cloSpec = VirtualMachineCloneSpec->new( config => $vmconfig, location => $reloSpec, template => 0, powerOn => 0, @ss);

# this could be either clone or move
my $taskRef;
print $event . "\n";
if ($op eq 'move') { eval {$taskRef = $vm_view->RelocateVM_Task(spec => $reloSpec, priority => $migrationPriority);}}
else {
	my $existVM = $dstVIM->find_entity_view(view_type=>'VirtualMachine', filter=>{'name'=>$newVM}, properties=>['name']);
	&cleanUp("ERROR: VM with name $newVM exists!") if $existVM;
	eval {$taskRef = $vm_view->CloneVM_Task(spec => $cloSpec, name => $newVM, folder=>$fd_view);}
}

###### Monitoring and cleanup
print $@ . "\n" if $@;
if ($taskRef) { &taskMonitor($taskRef, $srcVIM);}
&cleanUp("DONE! Clean up VIM sessions...");

###### SUBS
sub cleanUp() {
	$dstVIM->logout();
	$srcVIM->logout();
	print "@_\n";
	exit 0;
}
sub taskMonitor() {
	print color('blue'). "#### $taskRef->{'value'} Status ####\n" . color('reset');
	if ($nowait) {
		print "Not tracking the task as requested.\n";
		return 1;
	}
	my $taskRef = shift;
	my $srcVIM = shift;
	my $task = $srcVIM->get_view(mo_ref => $taskRef, properties => ['info']);
	my $lastmessage = '';
	print localtime(). "\n";
	print "Enter".color('red')." STOP ".color('reset'). "to cancel any time...\n";

	# non-blocking wait input
	use IO::Select;
	my $input = IO::Select->new();
	$input->add(\*STDIN);

	$|=1; # autoflush
	while (($task->info->state->val eq 'running') or ($task->info->state->val eq 'queued')) {
		$task->update_view_data();
		if (defined $task->info->progress) {
			if (defined $task->info->description) {
				my $message = $task->info->description->message;
				if ($message && ($message ne $lastmessage)) {
					$lastmessage = $message; 
					print "\n";
				}
				print "\r\e[J". $task->info->progress ."% $message " if $message;
			}
		}
		sleep 3;
		if ($input->can_read(.5)) { #timeout is half a second
			chomp(my $ask = <STDIN>);
			if ($ask eq 'STOP') {
				print "Cancellation requested!\n";
				if ($task->info->cancelable) { eval {$task->CancelTask();}}
                                else {print "Task not cancelable at this moment.\n";}
			}
		}
	}
	my $state = $task->info->state->val;
	my $color = ($state =~ m/success/i)?'bold green':'bold red';
	print "\n" . color($color).uc($state).color('reset');
	print ": " . $task->info->error->localizedMessage if (defined $task->info->error);
	print "\n".localtime() . "\n";
}
