#!/usr/bin/perl -w
# inspired by powercli: http://mattaltimar.com/?p=166
use strict;
use warnings;
use VMware::VIRuntime;
use Term::ANSIColor;
use Data::Dumper;
use DateTime;
#
my %opts = (
	vm => { type => "=s", help => "VM name", required => 0},
	cluster => { type => "=s", help => "cluster name to look in", required => 0},
	host => { type => "=s", help => "host name to look in", required => 0},
	rp => { type => "=s", help => "resource pool to look in", required => 0},
	event => { type => "=s", help => "type of events, use comma to delimit multiple. For example: com.vmware.vc.ha.VmRestartedByHAEvent", required => 0},
	message => { type => "=s", help => "message pattern to grep for", required => 0},
	severity => { type => "=s", help => "severity of event: info, warning, error,user", required => 0},
	days => { type => "=i", help => "limit the last number of Days to look", required => 0},
	showevent=> { type => "", help => "show me some event type examples", required => 0},

);

# hash key with literal dot need to be quoted
my %eventype = (
	'esx.problem.net.redundancy.lost' => "lost uplink on a vSS",
	'esx.clear.net.redundancy.restored' => "restored uplink on a vSS",
	'esx.problem.net.dvport.redundancy.lost' =>  "lost vDS uplink",
	'esx.clear.net.dvport.redundancy.restored' => "vDS uplink stored",
	'com.vmware.vc.ha.VmRestartedByHAEvent' => "HA restarted a VM",
	VmMigratedEvent => "VM vmotioned",
	DrsVmMigratedEvent => "DRS migrated a VM",
	AlarmStatusChangedEvent => "Alarm has triggered",
	'esx.problem.net.dvport.redundancy.degraded' => "uplink degraded",
	'EnteredMaintenanceModeEvent' => 'Entering maintenance mode',
	'ExitMaintenanceModeEvent' => 'Exiting maintenance mode',
	'HostConnectionLostEvent' => 'a host is disconnected from VC',
	'HostSyncFailedEvent' => 'Error communicating to a remote host',
);

# validate options, and connect to the server
delete $ENV{'https_proxy'}; # this always seem to cause problem.
Opts::add_options(%opts);
Opts::parse();
if (Opts::option_is_set('showevent')) {
	printf "%-50s%-30s\n", $_, ' --' . $eventype{$_} for (sort keys %eventype);
	#print "$_\t\t$eventype{$_}\n" for (sort keys %eventype);
	exit;
}
Opts::validate();
###
my $vmname = Opts::get_option('vm');
my $cluster = Opts::get_option('cluster');
my $hostname = Opts::get_option('host');
my $rp = Opts::get_option('rp');
my $server = Opts::get_option('server');
my $days = Opts::get_option('days');
my $event_string = Opts::get_option('event');
my @event = ($event_string)?split(',',$event_string):();
my $message = Opts::get_option('message');
my $severity = Opts::get_option('severity');
my $username = Opts::get_option('username');
my $password = Opts::get_option('password');
#
# Establish a session...
my $vim = &create_session($server);
die "Failed to establish session...\n" unless (defined $vim->{'service_content'});

# probably don't want an exact name in here, hence qr/$vmname/i, instead of qr/^$vmname$/i
# only one of them please. Specifying multiple won't help anybody.
my $mob;
if ($vmname || $cluster || $hostname) { 
	if ($vmname) {
		$mob = $vim->find_entity_view(view_type => 'VirtualMachine', filter=> {name => qr/^$vmname$/i}, 
			properties => ['name','config','resourceConfig','runtime','resourcePool']);
	}
	elsif ($cluster)  { $mob = $vim->find_entity_view(view_type => 'ComputeResource', filter => { 'name' => $cluster}); }
	elsif ($hostname) { $mob = $vim->find_entity_view(view_type => 'HostSystem', properties => ['name'], filter=>{'name'=>qr/^$hostname/});}
	else { $mob = $vim->find_entity_view(view_type => 'ResourcePool', properties => ['name'], filter=>{'name'=>qr/^$rp/});}
	die "Provided entity (vm/host/cluster/rp) not found" unless $mob;
}

# get eventmanager
print "Getting event manager...\n";
my $eventMgr = $vim->get_view(mo_ref => $vim->get_service_content()->eventManager);
#my $alarmMgr = $vim->get_view(mo_ref => $vim->get_service_content()->alarmManager);
my @entitySpec = ($mob)?(entity=>$mob):(); # if there is mob, no need to specify entityspec
my $recursion = EventFilterSpecRecursionOption->new("self");
my @entity = (@entitySpec)?(entity => EventFilterSpecByEntity->new(@entitySpec, recursion => $recursion)):();
my @timeSpec = ($days)?(time=>EventFilterSpecByTime->new(beginTime=>DateTime->now->subtract(days=>$days), endTime=>DateTime->now)):();

###
#my @eventSpec = ($event)? (eventTypeId => ["$event"]):();
my @eventSpec = (@event)? (eventTypeId => \@event):();
my @category = ($severity)? (category => [$severity]):();
my $filterSpec = EventFilterSpec->new(@entity, @timeSpec, @eventSpec, @category);

#
print "Creating event collector...\n";
my $eventCollector = $eventMgr->CreateCollectorForEvents(filter => $filterSpec);
my $eventView = $vim->get_view(mo_ref => $eventCollector);
if (not defined $eventView->latestPage) {
	print "No events found. \n";
	exit;
}

my $page = $eventView->ReadNextEvents(maxCount => '200');
while (scalar @$page) {
	foreach (@$page) {
		if ($message) { next unless ($_->fullFormattedMessage =~ /$message/i) }
		my $etype = ref ($_);
		# Event type of 'EventEX' has its true type in 'eventTypeId'
		if (($etype eq  'EventEx') || ($etype eq 'ExtendedEvent')) {
			$etype = $etype . ":". $_->{'eventTypeId'}; 
		}
		my $user = (defined $_->userName && $_->userName ne '')?$_->userName:""; $user =~ s/.*\\//;
		(my $time = $_->createdTime) =~ s/\.\d+Z//; #2017-05-20T06:23:49.890999Z

		# if specified eventtype, then we probably want to make sure that we get the chained event, if any:
		my ($ulen, $tlen, $olen, $object, $e_message); 
		if (@event && $_->chainId ne $_->key) {
			#print $_->vm->name. "\n";
			my $chainFilter = EventFilterSpec->new(eventChainId=>$_->chainId);
			my $chainCollector = $eventMgr->CreateCollectorForEvents(filter => $chainFilter);
			my $chainView = $vim->get_view(mo_ref => $chainCollector);
			my $chainEvent = $chainView->latestPage;
			foreach my $e (sort {$a->key cmp $b->key} @$chainEvent) {
				$object = (defined $e->{'objectName'})?$e->{'objectName'}:'';
				$e_message = $e->fullFormattedMessage;
				my $etype = ref ($e); 
				$tlen = length($etype) + 1;
				(my $etime = $e->createdTime) =~ s/\.\d+Z//;
				my $euser = (defined $e->userName && $e->userName ne '')?$e->userName:"";
				$ulen = length($euser) + 1;
				if ($object && $e_message !~ /$object/i) {
					$e_message = $object .": ". $e_message;
				}
				printf "%-10s%-${tlen}s%-20s%-${ulen}s%-30s\n", $e->key, $etype, $etime, $euser,' ['.$e_message.']';
			}
		} else {
			$ulen = length($user) + 1;
			$tlen = length($etype) + 1;
			$object = (defined $_->{'objectName'})?$_->{'objectName'}:'';
			$e_message = $_->fullFormattedMessage;
			if ($object && $e_message !~ /$object/i) {
				$e_message = $object .": ". $e_message;
			}
			printf "%-10s%-${tlen}s%-20s%-${ulen}s%-30s\n", $_->key, $etype, $time, $user, '['.$e_message.']';
		}
	}
	$page = $eventView->ReadNextEvents(maxCount => '200');
}

### Function definitions ####
sub create_session() {
        $|=1; # autoflush
	my $start = time;
        my $timeout = 10;
        my ($server) = @_;
        my $sessionfile = "/tmp/.session-$server";
        my $service_url = "https://$server.vmware.com/sdk";

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

                # GREEN for new, YELLOW for re-use, and RED for bad connection
                if (not $@) {print "\n".color('green') . "[$server]" . color('reset');}
                else { print "\n".color('red') . "[$server]: $@" . color('reset');}
        } else { print "\n".color('yellow') . "[$server]" . color('reset'); }

        # Return even if a login was unsuccessful. $vim->{'service_content'} is undef in such case.
	my $elapsed = sprintf("%.f", time - $start);
        print "(${elapsed}s) " ;
        return $vim;
}
