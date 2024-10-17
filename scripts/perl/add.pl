#!/usr/bin/perl -w
# add a single vmdk file to vms.
use strict;
use warnings;
#use VMware::VILib;
use VMware::VIRuntime;
use Data::Dumper;
use Term::ANSIColor;
use List::MoreUtils qw(first_index);
#use Cwd 'abs_path';
use feature qw(say);
use File::Basename qw(dirname);
#
my %opts = ( 
	vm => { type => "=s", help => "VM name. Use regex to specify multiple vms: ora-test-r[21]. The 1st vm in regex will be the owning vm in case of shared disk", required => 1},
	size => {type => "=f", help => "disk size in GB", required => 1},
	eagerzero => {type => "=i", help => "1 for eagerZero or 0 for lazy thick. EZT can be both shared or non-shared. Default enabled when 'shared' is on", required => 0, default => '0' }, 
	shared => {type => "=i", help => "Multi-writer flag: 0 for no, 1 for yes", required => 0, default => '0'},
	ds => {type => "=s", help => "datastore. if not provided, allocate from where the vm is", required => 0}, 
	controller => {type => "=i", help => "controller number: for example, 1", required => 0, default => '0'},
	mode => {type => "=i", help => "1 for 'persistent' and 2 for 'independent_persistent'", required=>0, default => 1},
);

delete $ENV{'https_proxy'};
Opts::add_options(%opts);
Opts::parse();
Opts::validate();
my $vmName = Opts::get_option('vm');
my $server = Opts::get_option('server');
if ($server eq 'localhost') {
        $server = ($vmName =~ /(stage|prod)/)? 'vc-prod-1.vmware.com':'vc-dev-1.vmware.com';
        Opts::set_option('server' => $server);
        print "Connecting to ". color("green") . "$server\n". color("reset");
}
Util::connect();
#
my $vmdkSize = Opts::get_option('size')*1024**2; #convert to KB from GB
my $adapter = Opts::get_option('controller');
my $dataStore = Opts::get_option('ds');
my $multi_writer = Opts::get_option('shared');
my $vmdkEager = ($multi_writer)?'1':Opts::get_option('eagerzero');
my $diskMode = Opts::get_option('mode');
$diskMode = ($diskMode == 1)?'persistent':'independent_persistent';

my $vms = Vim::find_entity_views(view_type => 'VirtualMachine',properties => ['name', 'config','runtime.host'], filter => {"name" => qr/^$vmName$/i});
die "VM not found in $server. Use '-server' to search in a different vc?\n\n" unless @$vms;

# first vm in your specification as the disk owner. $vms does not honor this order, rather it is based on which one was found first.
# let's also re-arrange the vms list so that owner is the top of the list and a shared vmdk is created with that vm
my ($ownerName, $ownerIdx);
$ownerName = $1.$2 if ($vmName =~ m/(.*?)\[(\d)/); 
if ($ownerName) {
	$ownerIdx = first_index {$_->name eq $ownerName} @$vms;
	if ($ownerIdx && $ownerIdx != 0) {
		my @temp = splice(@$vms, 0, $ownerIdx);	
		push (@$vms, @temp);
	}
}

my $h = Vim::get_view(mo_ref => @{$vms}[0]->{'runtime.host'}, properties => ['config.product.version']);
my $hv = $h->{'config.product.version'} if defined $h;

############################
my (@taskIDs, $file, $devspec, $dsName, @extra);
my $existing = 0;

# Do not sore teh vm list again here. Doig so will mess up the previous efforts
foreach my $vm (@$vms) {
	print "\n<$vm->{'name'}>\n";

	my (%ctrls, $ctrl);
	my $devices = $vm->config->hardware->device;

	# Inventory the controller and their keys/IDs and save into a hash.
	foreach (@$devices) {
		if ($_->isa('VirtualSCSIController')) { 
			#only use the digits in the label "scsi controller 2"
			($ctrl = $_->deviceInfo->label) =~ s/\D//g;
			$ctrls{$ctrl} = $_->key;
			$ctrls{$_->key} = $ctrl;
		}
	}

	# Inventory disk information: This is so that we know if a slot is taken. Nothing is taken on a newly added controller
	my (%vmdks, $slot);
	foreach (@$devices) {
		if ($_->isa('VirtualDisk')) {
			$slot = $ctrls{$_->controllerKey} . ":" . $_->unitNumber; 
			$vmdks{$slot} = $_->backing->fileName;
			$vmdks{$_->backing->fileName} = $slot; 
		}
	}

	if (! defined $ctrls{$adapter}) { 
		print "Controller $adapter does not exist. Adding controller...\n"; 
		my $status = &add_controller($vm, $adapter, "ParaVirtualSCSIController");
		if ( $status =~ /Soap Fault/i) {print "Errored: $status\n"; exit 1;} else {print "added successfuly.\n";}	

		$vm->update_view_data();
		foreach (@{$vm->config->hardware->device}){
			if ($_->isa('VirtualSCSIController')) { 
				(my $num = $_->deviceInfo->label) =~ s/\D//g;
				if ($num == $adapter) {
					$ctrls{$adapter} = $_->key;
					$ctrls{$_->key} = $adapter;
				}
			}
		}
	}

	# find slot otherwise. exit if slot full. slots being 0-15, excluding 7
	my $unit = 16;
	foreach (0..15) { 
		next if ($_ == '7');
		$slot = $adapter . ":" . $_;
		if (! defined $vmdks{$slot}) { $unit = $_; last; }
	}
	if ($unit == '16') { print "Controller $adapter full. Specify a different controller.\n"; next;}

	my @share_attr = ($hv ne 6.0.0)?():(sharing =>'sharingNone');
	if ($multi_writer) {
		if ($hv !~ /6\./ ) {
			print "Preparing multi-writer optionValue for host version $hv.\n";
			my $key = "scsi".$slot.".sharing";
			$extra[0] = OptionValue->new (key=>$key, value=>'multi-writer');
		} else { 
			print "Preparing sharingMultiWriter attribute for host version $hv.\n";
			@share_attr = (sharing => 'sharingMultiWriter');
		}
	}

	# if the file does not exist, Create it; Otherwise, use the same file on the rest of the vms.
	if (! $existing) {
		# Create the file on this vm in the list. It may not be r1...
		if (! $dataStore) {
			($dsName = $vm->config->files->vmPathName) =~ s/\[(.*)\].*/$1/g; 
		} else { $dsName = $dataStore; }
		die if not $dsName;

		my $ds = Vim::find_entity_view(view_type=>"Datastore", filter=> {'name' => $dsName});
		die "Datastore [ $dsName ] is not found!\n" if (! $ds); 
		if ($ds->summary->freeSpace/1024 < ($vmdkSize + 20000000)) {
			print "Not enough space on $dsName\n"; 
			next;
		}

		# Creating top folder for VM if not there
		print "Using datastore $dsName\n";
		my $path = "[" . $dsName ."] " . $vm->name;
		if ($dataStore) {
			my $sc = Vim::get_service_content();
			my $fm = Vim::get_view(mo_ref => $sc->fileManager);
			my $dsFolder = Vim::get_view(mo_ref => $ds->parent);
			my $dc = Vim::get_view(mo_ref => $dsFolder->parent);
			print "Creating folders on this path: " . $path . "\n";
			eval {$fm->MakeDirectory(name => $path, datacenter=> $dc, createParentDirectories => 1)};
			die "Failed to create directory: $@" if ($@);
		}

		# determin disk name
		my $suffix = 1;
		$file = $path . "/". $vm->name . "_" . $suffix . ".vmdk";
		while (defined $vmdks{$file}) {
			$suffix++;
			$file = $path . "/". $vm->name . "_" . $suffix . ".vmdk";
		}
		print "Prepare to create  $file of ${vmdkSize}KB on scsi$adapter:$unit\n";
	} else { print "Prepare to attach $file to scsi$adapter:$unit.\n";}
	
	# Assemble disks here.
	my $backing = VirtualDiskFlatVer2BackingInfo->new (
		diskMode => $diskMode, 
		thinProvisioned => 0,
		eagerlyScrub => $vmdkEager,
		fileName => $file,
		@share_attr,
	); 
	
	my $disk = VirtualDisk->new (
		backing => $backing,
		connectable => VirtualDeviceConnectInfo->new (allowGuestControl=>0,connected=>1,startConnected=>1),
		controllerKey => $ctrls{$adapter},
		unitNumber => $unit, 
		key => -1,
		capacityInKB => $vmdkSize,);

	if (! $existing) {
		$devspec = VirtualDeviceConfigSpec->new(operation=>VirtualDeviceConfigSpecOperation->new('add'), device=>$disk, 
						fileOperation=>VirtualDeviceConfigSpecFileOperation->new('create'));
	} else { $devspec = VirtualDeviceConfigSpec->new(operation=>VirtualDeviceConfigSpecOperation->new('add'), device=>$disk); }

	my $vmspec = VirtualMachineConfigSpec->new(deviceChange => [$devspec] );
        if (@extra) {
                print "Enabling multi-writer...\n";
                $vm->ReconfigVM(spec => VirtualMachineConfigSpec->new(extraConfig => [@extra]));
        }

	if ($devspec) {
		# we may need to call synchronously so that the first disk is indeed created before it can be shared
		if ($multi_writer and  ! $existing) {
			print "Reconfig VM for disk changes...\n";
			eval { $vm->ReconfigVM(spec => $vmspec);};
			print "Done!\n";
			$existing = 1;
		} else {
			print "Submitting reconfig VM task for disk changes...\n";
			eval { push(@taskIDs, $vm->ReconfigVM_Task(spec => $vmspec)); };
			if ($@) { print "Reconfiguration failed.\n $@";}
			else {print $taskIDs[-1]->value ." submitted!\n"; }
		}
	} else { print "Nothing to add!\n"};
}

# did all the task finish? check here!
&wait_tasks(\@taskIDs) if (@taskIDs);

### Add a controller
sub add_controller() {
        my $vm = shift;
        my $ids = shift;
        my $type = shift;

        my @devspec;
        foreach (split (//,$ids)) {
                print "Preparing controller [$_]\n";
                my $info = $type->new (
                        busNumber => $_,
                        key => -1, #this should not be needed.
                        sharedBus => VirtualSCSISharing->new('noSharing'), # this should not be needed.
                );
                push(@devspec, VirtualDeviceConfigSpec->new(device => $info, operation => VirtualDeviceConfigSpecOperation->new('add')));
        }

        my $vmspec = VirtualMachineConfigSpec->new(deviceChange => [@devspec] );
        if (@devspec) {
                print "Adding $type controller $ids to ". $vm->name . "...\n";
                eval { $vm->ReconfigVM(spec => $vmspec); };
        } else { print "Nothing to add!\n"};

        return $@;
}
## waiting for async task to complete
sub wait_tasks() {
        my @tasks;
        my $taskIDs = shift;

        foreach (@$taskIDs) { push(@tasks, Vim::get_view(mo_ref => $_, properties => ['info']) ); }

        #print strftime "%H:%M:%S\n", localtime;
        while (@tasks) {
                foreach my $task (@tasks) {
                        $task->update_view_data();
                        if ($task->info->state->val eq 'success') {
                                print $task->info->key . " successful.\n";
                                @tasks = grep {$_ != $task } @tasks;
                        }
                        elsif ($task->info->state->val eq 'error') {
                                print $task->info->key . " failed:\n";
                                my $fault = $task->info->error->fault->faultMessage;
                                die ${$fault}[3]->{'message'};
                        }
                }
                sleep 2
        }
        #print strftime "%H:%M:%S\n", localtime;
}

##
Util::disconnect();
exit 0;
