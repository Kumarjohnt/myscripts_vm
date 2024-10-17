#!/usr/bin/perl -w
use Data::Dumper;
use Term::ANSIColor;
use strict;
use warnings;
use VMware::VILib;
use VMware::VIRuntime;
#
my %opts = ( vm => { type => "=s", help => "VM name", required => 1});
delete $ENV{'https_proxy'};
Opts::add_options(%opts);
Opts::parse();
Opts::validate();
my $vmName = Opts::get_option('vm');
my $server = Opts::get_option('server');
if ($server eq 'localhost') {
        $server = ($vmName =~ /(stage|prod|prd|stg)/)? 'vc-prod-1':'vc-dev-1';
        print "Connecting to ". color ('bold green') . "$server\n". color("reset");
        Opts::set_option('server' => $server);
}

if ($server eq 'localhost') {
	$server = ($vmName =~ /(stage|prod)/)? 'vc-prod-1':'vc-dev-1';
	print "Connecting to ". color ('bold green') . "$server\n". color("reset");
	Opts::set_option('server' => $server);
}
Util::connect();
###
my @nodes = qw/1:8 1:9 1:10 1:11 1:12 2:8 2:9 2:10 2:11 2:12/;
my $vms = Vim::find_entity_views(view_type => 'VirtualMachine',properties => ['name', 'config'], filter => {"name" => qr/^$vmName/i});
foreach my $vm (sort{$a->name cmp $b->name} @$vms) {
	print "\n<$vm->{'name'}>\n";
	my $extraConfig = $vm->config->extraConfig;
	foreach (@$extraConfig) { print $_->key . ":\t[" . $_->value . "]\n"; }
}
Util::disconnect();
