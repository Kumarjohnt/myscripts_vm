#!/usr/bin/perl -w
use strict;
use warnings;
use VMware::VIRuntime;
use Data::Dumper;
use Term::ANSIColor;
use Switch;

my %opts = ( 
	vm => { type => "=s", help => "VM name", required => 0},
	ds => { type => "=s", help => "datastore name", required => 0},
	host => { type => "=s", help => "host Name", required => 0},
	dsonly => { type => "", help => "Only displaying datastore", required => 0},
	lunonly => { type => "", help => "Only displaying luns", required => 0},
	notitle => { type => "", help => "Skipping the titles", required =>0},
	showvm => { type=>"", help => "list vms on datastore", required=>0},
);

# validate options, and connect to the server
delete $ENV{'https_proxy'};
Opts::add_options(%opts);
Opts::parse();
my $vmName = Opts::get_option('vm');
my $dsName = Opts::get_option('ds');
my $hostName = Opts::get_option('host'); unless (! $hostName || $hostName =~ /\.vmware\.com/) {$hostName .= '.vmware.com';}
my $server = Opts::get_option('server'); unless ($server =~ /\.vmware\.com/ || $server =~ /\d+\.\d+\.\d+\.\d+/) {$server .= '.vmware.com';}
my $dsonly = Opts::option_is_set("dsonly");
my $lunonly = Opts::option_is_set("lunonly");
my $notitle = Opts::option_is_set("notitle");
my $showvm = Opts::option_is_set("showvm");
unless ($vmName or $hostName) {
	print "Need either vm (-vm xxx) or host (-host xxx) name to proceed!\n"; 
	exit;
}
Opts::validate();
my $username = Opts::get_option('username');
my $password = Opts::get_option('password');
my $vim = &create_session($server);
die "Failed to establish session...\n" unless (defined $vim->{'service_content'});

###
my $host;
if ($vmName) {
	my $vm = $vim->find_entity_view(view_type => 'VirtualMachine', filter=> {"name" => qr/$vmName/i}, properties => ['name','runtime']);
	die "No vm with this name. Use '-server' to specify a different vc?\n\n" unless $vm;
	$host = $vim->get_view(mo_ref => $vm->runtime->host, properties => ['name','datastore', 'config.storageDevice.plugStoreTopology.path', 'config.storageDevice.scsiLun']);
}
else {
	$host = $vim->find_entity_view(view_type => 'HostSystem', filter => { name => qr/$hostName/}, properties => ['name','datastore', 'config.storageDevice.plugStoreTopology.path', 'config.storageDevice.scsiLun']);
	die "No host with this name. Use '-server' to specify a different vc?\n\n" unless $host;
}

print "####$host->{'name'}#####\n" unless $notitle;

#
my (%luns, %state);
if (not $dsonly) {
	my $paths = $host->{'config.storageDevice.plugStoreTopology.path'};
	my $scsiluns = $host->{'config.storageDevice.scsiLun'}; 
	foreach (@$scsiluns) {
		my $size;
		if ($_->deviceType eq 'disk') {
			my $sizeKB = $_->capacity->{'block'} * $_->capacity->{'blockSize'};
			$size = ($sizeKB < 1073741824)?
				sprintf("%.4f", $_->capacity->{'block'} * $_->capacity->{'blockSize'}/1024**3):
				sprintf("%.f", $_->capacity->{'block'} * $_->capacity->{'blockSize'}/1024**3);
			$size =~ s/^0//;
		}
		elsif ($_->deviceType eq 'array controller') { $size = 'ctrlr'; }
		else {$size = 'unkwn';}
		$state{$_->uuid} = {status => ${$_->operationalState}[0], sizeGB => $size};
	}
	
	foreach (@$paths) {
		# some dead device causes issue here
		(my $naa = $_->device) =~ s/.*Device-[0-9a-z]{10}(.*)[0-9a-z]{12}/naa.$1/ if defined $_->device;
		next unless defined $naa;
		(my $adapter = $_->adapter) =~ s/.*(vmhba.)/$1/;
		(my $uid = $_->device) =~ s/.*\-(.*)/$1/;
		my $runtimeName = "$adapter:C".$_->channelNumber.":T".$_->targetNumber.":L".$_->lunNumber;

		# hash of hash to make looking for lun by naa easier:
		if (! exists $luns{$naa}) { $luns{$naa} = { runtimeNames=>[$runtimeName], hostID=>$_->lunNumber, uid=>$uid}; }
		else { push @{$luns{$naa}->{'runtimeNames'}}, $runtimeName; }
	}

	my $uidwidth = 0;
	foreach (keys %luns) {
		my $width = length $luns{$_}->{uid};
		$uidwidth = $width if $width > $uidwidth; 
	}
	$uidwidth += 2; # to accommodate the extra dots that we insert

	# there is no need to print the NAA AND uid as naa is a sub-string of uid.
	if (not $notitle) {
		my $numLUN = scalar keys (%luns); 
		printf "%-${uidwidth}s%4s%6s%7s%-15s\n", "uu.NAA.ID (count: $numLUN)",'HID', 'State','SizeGB', ' Runtime-Names';
		printf "%-${uidwidth}s%4s%6s%7s%-15s\n",'-------------', '---', '-----', '------', ' ------------';
	}

	foreach (sort { $luns{$a}->{uid} cmp $luns{$b}->{uid} && $luns{$a}->{hostID} <=> $luns{$b}->{hostID} }  keys %luns) {
		my $hostID = $luns{$_}->{hostID};
		my $uid = $luns{$_}->{uid};
		my $naalen = length($_) - 4;
		my $status = uc($state{$uid}->{'status'});
		my $size = $state{$uid}->{'sizeGB'};
		
		# flatten array into a variable lenghth string. Using the 'x' operator to build template.
		my $width = length(@{$luns{$_}->{runtimeNames}}[0]) + 1; #all paths will have the same length for the same lun. So check the first path suffices
		my $runtimeNames = sprintf "%-${width}s"x @{$luns{$_}->{runtimeNames}}, @{$luns{$_}->{runtimeNames}};
		my $uuid = substr($uid, 0, 10) . '.'. substr($uid, 10, $naalen).'.'.substr($uid, $naalen+10, 12); 
		printf "%-${uidwidth}s%4s%6s%7s%-15s\n", $uuid, $hostID,$status,$size,' ['.$runtimeNames.']'; 
	}
}

############## list all datastores on the hosts ######
if (not $lunonly) {
	my $datastore = $host->datastore;
	my $numDS = scalar @$datastore;
	
	# To accommodate variable length in datastore labels
	my $dswidth = 0;
	foreach (@$datastore) { 
		my $width = length (${$vim->get_view(mo_ref => $_, properties => ['summary'])}{'summary'}->name);
		$dswidth = $width if $width > $dswidth;
	}
	$dswidth += 20;

	if (not $notitle) {
		printf "\n%-${dswidth}s%-6s%-6s%-6s%-11s%-33s%-38s%7s%7s%6s%5s%6s\n","Datastore (count: $numDS)",'HID','Type','VMcnt','Accessible',"NAA ID","DS UUID","SizeGB","FreeGB","%Free","Ver.","Blksz";
		printf "%-${dswidth}s%-6s%-6s%-6s%-11s%-33s%-38s%7s%7s%6s%5s%6s\n","---------------",'---','----','-----','----------','------',"-------","------","------", "-----","----", "-----";
	}
	foreach (@$datastore) {
		my ($numVm, $ds,$dsname,$dstype, $naa, $cap, $free,$version,$blksz,$dsuuid,$access);

		$ds = $vim->get_view(mo_ref => $_, properties => ['info', 'summary','vm']);
		my $moid = $ds->{'mo_ref'}->value;
		$dsname = $ds->summary->name;
		
		#filter out the datastore we want:
		if ($dsName && $dsname !~ /$dsName/) { next;}
		
		$access = ($ds->summary->accessible)?'yes':'no';
		my $vmlist = (defined $ds->vm)?$ds->vm:();
		$numVm = ($vmlist)?@$vmlist:0;
		$cap = sprintf("%.f",$ds->summary->capacity/1024**3);
		$free = sprintf("%.f", $ds->summary->freeSpace/1024**3); 
		$dstype = $ds->summary->type;
		($dsuuid = $ds->info->url) =~ s#.*?volumes/##g;
		$dsuuid =~ s;/;;g;

		if (ref($ds->info) eq 'VmfsDatastoreInfo') {
			($naa = ${$ds->info->vmfs->extent}[0]->diskName) =~ s/naa\.//g;
			$version= $ds->info->vmfs->version;
			$blksz = $ds->info->vmfs->blockSizeMb;
		} else {
			$naa = 'NA';
			$version = 'NA'; 
			$blksz = 'NA';
		}

		my $hid = ($dsonly)?'':$luns{"naa.".$naa}->{'hostID'};
		$hid = 'N/A' unless $hid;
		printf "%-${dswidth}s%-6s%-6s%-6s%-11s%-33s%-38s%7.f%7.f%6.f%5s%6s\n",$dsname." ($moid)",$hid,$dstype,$numVm,$access,$naa,$dsuuid,$cap, $free, sprintf("%.f", $free/$cap*100), $version, $blksz;
		
		if ($vmlist && $showvm) { 
			my $vms = $vim->get_views (mo_ref_array => $vmlist, properties => ['name']);
			my $cnt = 1;
			foreach (@$vms) {printf "%8s  %-30s\n", "     ".$cnt++, $_->name;}
		}
	}
	print "\n";
}
### Function definitions ####
sub create_session() {
        $|=1; # autoflush
        my $start = time;
        my $timeout = 10;
        my ($server) = @_;
        my $sessionfile = "/tmp/.session-$server";
        my $service_url = "https://$server/sdk";

        my $vim = Vim->new(service_url => $service_url);
        $vim->unset_logout_on_disconnect();

        eval { $vim->load_session(session_file => $sessionfile);};
        my $error = $@;
        if ($error) {
                eval {
                        local $SIG{ALRM} = sub { die "alarm";};
                        alarm $timeout;
                        $vim->login(user_name => $username, password => $password);
                        $vim->save_session(session_file => $sessionfile);
                        alarm 0;
                };
                if ($@) { print "\n".color('red') . "[$server]\n" . color('reset');}
        }
        return $vim;
}
