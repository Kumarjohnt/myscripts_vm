#!/usr/bin/perl -w
use Data::Dumper;
use strict;
use warnings;
use VMware::VILib;
use VMware::VIRuntime;
#
my %opts = ( folder => { type => "=s", help => "folder name", required => 1});
Opts::add_options(%opts);
Opts::parse();
Opts::validate();
Util::connect();
###
my $vm;
my $folderName = Opts::get_option('folder');
my $folders = Vim::find_entity_views( view_type => 'Folder', properties => ['name', 'childEntity'], filter => {"name" => qr/^$folderName$/i});
#
if (! @$folders) { print "Folder not found!\n"; exit; }

#We may have got more than one folder in the view. Let's look at them one by one.
foreach my $folder (@$folders) { 
	#print "<".$folder->name . ">\n";

	my $path = Util::get_inventory_path($folder, Vim::get_vim());
	print "(" . $folder->{'mo_ref'}->value . ")\t$path\n";
}
Util::disconnect();
