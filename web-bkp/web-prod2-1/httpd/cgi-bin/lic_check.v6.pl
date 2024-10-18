#!/usr/bin/perl -w

#-----------------------------------------------------------------------
# $Id: lic_check.pl,v 1.76 2007-12-11 17:51:49 vadim Exp $
#-----------------------------------------------------------------------
# Description: Validate cut-n-paste glued server-based license file
#-----------------------------------------------------------------------
# Contacts:    Author     - Vadim V. Kouevda  PSE/GSS  vadim@vmware.com
#              Updates    - Chad Scott        PSE/GSS  scott@vmware.com
#              Deployment - Dean Quinanola    IT       dean@vmware.com
#              CS/GSS     - Rupinder Saini    CS/GSS   rsaini@vmware.com
#-----------------------------------------------------------------------
# Resources:   https://wiki.eng.vmware.com/SampleWhitneyLicense
#              http://vmweb.vmware.com/~mrm/whitney-hostd-lic.txt
#              https://wiki.vmware.com/NewSerialLicensing
#              https://wiki.eng.vmware.com/LegacyLicensing
#              http://vmweb.vmware.com/~mrm/embed-hostd-lic.txt
#-----------------------------------------------------------------------

use strict;                             # Makes life REALLY miserable
use Data::Dumper;                       # For debugging
use Date::Parse;                        # Date format processing
use CGI qw(:standard escapeHTML Vars);  # CGI communication

my $dbg = 0;                            # General DEBUG flag

#-----------------------------------------------------------------------
# Variables
#-----------------------------------------------------------------------

my $version = sprintf("%d.%d", q$Revision: 1.76 $ =~ /(\d+)\.(\d+)/);
my $q = new CGI;        # To have useful printing shortcuts
my @lic_stats;          # 1st table of statistics for licenses
my %lic_stats_count;    # 2nd table of statistics for licenses

my @types = ( 'PROD_VC', 'PROD_VC_STARTER', 'VC_VMOTION', 'VC_ESXHOST',
              'PROD_VC_EXPRESS',
              'VC_SERVERHOST', 'VC_DAS', 'VC_DRS',
    	      'PROD_ESX_FULL', 'ESX_FULL_BACKUP', 'PROD_ESX_STARTER',
    	      'PROD_ESX_SUBSTARTER', 'PROD_ESX_VDI', 'ESX_VDI_VM'
       	    );

my %pretty_types = (
    'PROD_VC' => 'VC Management Server',
    'PROD_VC_STARTER' => 'PROD_VC_STARTER',
    'PROD_VC_EXPRESS' => 'VC Foundation Management Server',
    'VC_VMOTION' => 'VMotion',
    'VC_ESXHOST' => 'VC Agent for ESX Server',
    'VC_SERVERHOST' => 'VC Agent for VMware Server',
    'VC_DAS' => 'VMware HA',
    'VC_DRS' => 'VMware DRS',
    'PROD_ESX_FULL' => 'ESX Server Enterprise/Standard',
    'ESX_FULL_BACKUP' => 'VMware Consolidated Backup',
    'PROD_ESX_STARTER' => 'ESX Server Foundation',
    'PROD_ESX_SUBSTARTER' => 'PROD_ESX_SUBSTARTER',
    'PROD_ESX_VDI' => 'VMware VDI',
    'ESX_VDI_VM' => 'VMware VDI VM'
);

my $type_pattern = "(" . join('|', @types) . ")";

#-----------------------------------------------------------------------
# HTTP & HTML header including TITLE of the page and H1 on the page
#-----------------------------------------------------------------------

print $q->header;

print << "END_OF_HTML_HEADER";
<!DOCTYPE html
     PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="all" />
	<meta name="copyright" content="VMware" />
	<meta http-equiv="content-language" content="en" />
	<title>Server-based License File Checker</title>
	<link rel="alternate" type="application/rss+xml" href="http://vmware.simplefeed.net/rss" />
	<link rel="shortcut icon" type="image/x-icon" href="/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="http://www.vmware.com/files/templates/inc/template.css" />
	<link rel="stylesheet" type="text/css" href="http://www.vmware.com/files/templates/inc/fce.css" />
	<link rel="stylesheet" type="text/css" href="http://www.vmware.com/files/templates/inc/print.css" media="print" />
	<script type="text/javascript" src="http://www.vmware.com/files/templates/inc/library.js"></script>
</head>

<body>

<div id="container">

	<strong class="seo">VMware</strong>
	
	<div id="content-container" class="wide">

		<div id="content">

END_OF_HTML_HEADER

#-----------------------------------------------------------------------
# Let's retrieve the license file from STDIN
#-----------------------------------------------------------------------

my %cgivars =  Vars();
my $lic_file = $cgivars{'LICENSE'};

# Set the DEBUG level from the CGI, otherwise - from default DEBUG flag
my $D = $cgivars{'DEBUG'} || $dbg;

# These messages should always be shown!
my $V = 1;

#-----------------------------------------------------------------------
# This section will contain all MESSAGES related to processing
#-----------------------------------------------------------------------

$dbg && print "<b>PROCESSING LICENSES</b><br><hr>";

#=======================================================================
# PERFORM PREPROCESSING & SIMPLE SANITY CHECKS
#=======================================================================

if ( ( $lic_file eq ''          ) ||
     ( $lic_file !~ /INCREMENT/ )  ) {
print "<b>ERROR</b>: Unrecognized license format.",
    "Verify you are pasting the entire contents of the license file ",
    "and that it is is server-based for use with VirtualCenter.<br>";
    goto FOOTER;
}

#-----------------------------------------------------------------------
# Fix some letter cases
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: fix letter cases in keywords<br>" if ($D);

foreach my $word ( 'INCREMENT', 'SERVER', 'this_host', 'ANY',
                   'VENDOR', 'VMWARELM', 'port=', 'permanent',
		   'VENDOR_STRING', 'licenseType=Server',
		   'capacityType=cpuPackage', 'ISSUED',
		   'NOTICE=FulfillmentId', 'SIGN='
		 ) {
    $lic_file =~ s/$word/$word/gie;
}

#-----------------------------------------------------------------------
# Break INCREMENTs, accidently glued to the previous line
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: unglue joined together INCREMENTs<br>" if ($D);
$lic_file =~ s/INCREMENT/\nINCREMENT/g;

#=======================================================================
# MAIN PROCESSING
#=======================================================================

print "<b>NOTICE</b>: unwrap INCREMENTs on backslashes<br>" if ($D);
$lic_file =~ s/\s*\\\s+/ /g;                   # Unwrap lines on \ @ EOL

print "<b>NOTICE</b>: split file into separate lines<br>" if ($D);
my @input_lines = split(/[\n\r]+/, $lic_file); # Split file into lines

print "<b>NOTICE</b>: drop all comment and empty lines<br>" if ($D);
@input_lines = grep { ! /^\s*(#|$)/ }          # Drop empty and ...
                   @input_lines;               # ... comment lines

print "<b>NOTICE</b>: remove leading and training spaces<br>" if ($D);
foreach my $idx ( 0 .. scalar(@input_lines)-1 ) {
    $input_lines[$idx] =~ s/^\s+//g;           # Remove leading spaces
    $input_lines[$idx] =~ s/\s+$//g;           # Remove training spaces
}

#-----------------------------------------------------------------------
# Drop any lines, which do not start with proper words
#-----------------------------------------------------------------------

my @wrong = grep { ! /^(SERVER|VENDOR|USE_SERVER|INCREMENT)/ }
                     @input_lines;
if ( scalar(@wrong) != 0 && $V) {
    print "<br><b>WARNING: ", scalar(@wrong),
	  "</b> lines being removed due to an unrecognized format:<p>";
    foreach my $line ( @wrong ) {
        print "$line<br>";
    }
    print "<p>";
}
@input_lines = grep { /^(SERVER|VENDOR|USE_SERVER|INCREMENT)/ }
                   @input_lines;

#-----------------------------------------------------------------------
# Check header - it must be on top and in a certain form
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: checking header<br>" if ($D);
if ( ( $input_lines[0] !~ /SERVER this_host ANY [0-9]{1,5}/ ) ||
     ( $input_lines[1] !~ /VENDOR VMWARELM port=[0-9]{1,5}/ ) ||
     ( $input_lines[2] !~ /USE_SERVER/                      ) ) {
    print "<br><b>ERROR</b>: Unrecognized license header:<p>",
          $input_lines[0], "<br>",
	  $input_lines[1], "<br>",
	  $input_lines[2], "<p>",
	  "<b>EXITING...</b><p>";
    goto FOOTER;
}
my @header = @input_lines[0..2];

#-----------------------------------------------------------------------
# Strip duplicate headers
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: checking for duplicate headers<br>" if ($D);
# FIXME: This seems to produce spurious output for as-yet
# FIXME: unknown reasons
my @lics = grep { /^INCREMENT/ } @input_lines;
if ( scalar(@lics) != scalar(@input_lines)+3 ) {
    if ( $D && $V ) {
        print "<br><b>WARNING</b>: Duplicate headers were detected and ".
            "discarded:<p>";
        print join("[\r\n]+", grep { ! /^INCREMENT/ }
                          @input_lines[3..scalar(@input_lines)-1] ),
	    "<p>";
    }
}

#=======================================================================
# This is where we have license lines in @lics for cleaning
#=======================================================================

print "<hr><BR><B>EXTRACTED LICENSES:</B><BR><PRE>", Dumper(@lics),
      "</PRE><hr>" if ($D);
print "<b>NOTICE</b>: number of licenses currently = ", scalar(@lics),
      "<br>" if ($D);

#=======================================================================
# CLEANING:
#=======================================================================

#-----------------------------------------------------------------------
# Drop hosted
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: checking for hosted licenses<br>" if ($D);
my @hosted = grep { /licenseType=Host/ } @lics;
if ( scalar(@hosted) != 0 && $V ) {
    print "<p><b>WARNING:</b> ", scalar(@hosted),
          " host-based licenses were detected and removed:</p>";
    foreach my $h_lic ( @hosted ) {
    	my @h_fields = split(/\s+/, $h_lic);
	print join(' ', @h_fields[0..5]), " \\\n";
        print "\t", $h_fields[6], " \\\n";
        print "\t", join(' ', @h_fields[7..10]), " \\\n";
        print "\t", join(' ', @h_fields[11..22]), " \\\n";
        print "\t", join(' ', @h_fields[23..34]), " \\\n";
        print "\t", join(' ', @h_fields[35..scalar(@h_fields)-1]), "\n";
    }
    print "<p>";
}
@lics = grep { ! /licenseType=Host/ } @lics;
print "<b>NOTICE</b>: number of licenses currently = ", scalar(@lics),
      "<br>" if ($D);

#-----------------------------------------------------------------------
# General check for INCREMENT format
# Comments for modifications:
#   *) According to https://wiki.eng.vmware.com/SampleWhitneyLicense,
#      1.2.5. VENDOR_STRING Fields, 'licenseType' is 'information only,
#      not used' - hence relaxing matching
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: checking general INCREMENT format<p>" if ($D);
my $increm_pattern = '
^INCREMENT\s+              # Start of the license
' . $type_pattern . '\s+   # Product type, like in PROD_ESX_FULL
VMWARELM\s+                # VMWARELM
[0-9.]+\s+                 # 2005.05
((permanent|\d+-[a-zA-Z]{3}-\d{4})\s+\d+\s+){0,1} # License type
VENDOR_STRING=
["]{0,1}(licenseType=){0,1}(Server|production).*["]{0,1}\s+
ISSUED=\d{2}-[a-zA-Z]{3}-\d{4}\s+
NOTICE=["]{0,1}FulfillmentId=[0-9]+.*["]{0,1}\s+
SIGN="[0-9a-fA-F]{4}(\s[0-9a-fA-F]{4}){8,}"
.*$';
print "<b>NOTICE</b>: Pattern = $increm_pattern<p>" if ($D);
my @wrong_format = splice(@lics);

#-----------------------------------------------------------------------
# Tue Dec 11 09:39:51 PST 2007 [vadim] making match case incensitive, as
# apparently anything's possible.
#-----------------------------------------------------------------------

foreach my $f_lic ( @wrong_format ) {
    if ( $f_lic !~ /$increm_pattern/igx ) {
        if ($V) {
            print "<p><b>WARNING:</b> ",
                "A license in an unrecognized format has been removed:</p>";
            my @f_fields = split(/\s+/, $f_lic);
	        print join(' ', @f_fields[0..5]);
	        if ( scalar(@f_fields) >  6 ) {
	            print " <br>&nbsp;&nbsp;&nbsp;&nbsp;", $f_fields[6];
	        }
	        if ( scalar(@f_fields) > 10 ) {
	            print " <br>&nbsp;&nbsp;&nbsp;&nbsp;",
                          join(' ', @f_fields[7..10]);
	        }
	        if ( scalar(@f_fields) > 22 ) {
	            print " <br>&nbsp;&nbsp;&nbsp;&nbsp;",
                          join(' ', @f_fields[11..22]);
	        }
	        if ( scalar(@f_fields) > 34 ) {
	            print " <br>&nbsp;&nbsp;&nbsp;&nbsp;",
                          join(' ', @f_fields[23..34]);
	        }
	        if ( scalar(@f_fields) > 35 ) {
	            print " <br>&nbsp;&nbsp;&nbsp;&nbsp;",
	            join(' ', @f_fields[35..scalar(@f_fields)-1]);
            }

	        print "<br>\n";
        }
    } else {
        push(@lics, $f_lic);
    }
}
print "<b>NOTICE</b>: number of licenses currently = ", scalar(@lics),                                    "<br>" if ($D);

#-----------------------------------------------------------------------
# Check for duplicates
#-----------------------------------------------------------------------

print "<p><b>NOTICE</b>: checking for duplicates (", scalar(@lics),
      ")</p>" if ($D);
my %dups;
my $__count = 0;
foreach my $d_lic ( @lics ) {
    $dbg && print "<PRE>", ++$__count, ": $d_lic</PRE>\n";
    if ( ! exists($dups{$d_lic}) ) {
        $dups{$d_lic} = 1;
    } else {
        if ( $V ) {
            print "<p><b>ERROR</b>: ", "A duplicate license was detected ".
                "and removed:</p>";
    	    my @d_fields = split(/\s+/, $d_lic);
	        print join(' ', @d_fields[0..5]), " \\\n";
            print "\t", $d_fields[6], " \\\n";
            print "\t", join(' ', @d_fields[7..10]), " \\\n";
            print "\t", join(' ', @d_fields[11..22]), " \\\n";
            print "\t", join(' ', @d_fields[23..34]), " \\\n";
            print "\t", join(' ', @d_fields[35..scalar(@d_fields)-1]), "<p>";
        }
    }
}
my @tmp_lics = sort keys %dups;
$dbg && print "<PRE>TMP_LICS = ", scalar(@tmp_lics), "</PRE>\n";
@lics = ();
$dbg && print "<PRE>LICS = ", scalar(@lics), "</PRE>\n";
foreach my $type ( @types ) {
    push(@lics, grep { /^INCREMENT\s+$type\s+/ } @tmp_lics);
}
print "<b>NOTICE</b>: number of licenses currently = ", scalar(@lics),                                    "<br>" if ($D);

#-----------------------------------------------------------------------
# Process every license
#-----------------------------------------------------------------------

my @lic_fields;
foreach my $lic ( @lics ) {
    #-------------------------------------------------------------------
    # Split into fields
    #-------------------------------------------------------------------
    my @fields = split(/\s+/, $lic);
    # print "<hr><pre><B>FIELDS:</B><BR>", Dumper(@fields), "</pre><hr>";
    #-------------------------------------------------------------------
    # Build first stat table: type, #, ISSUED, NOTICE, date
    #-------------------------------------------------------------------
    my @list;
    if ( $lic =~ /OVERDRAFT=[0-9]+/i ) {
        @list = (1, 5, 8, 9, 4);
    } else {
        @list = (1, 5, 7, 8, 4);
    }
    my @stats = @fields[@list];
    $stats[2] =~ s/ISSUED=//g;
    #-------------------------------------------------------------------
    $stats[3] =~ s/NOTICE=["]{0,1}FulfillmentId=//g;
    $stats[3] =~ s/;.*//g;
    #-------------------------------------------------------------------
    # Check for expired
    #-------------------------------------------------------------------
    if ( $stats[4] ne 'permanent' ) {
        if ( str2time($stats[4]) < time() ) {
            if ($V) {
                print "<p><b>WARNING</b>: An expired license was detected and ".
                    "removed:</p>";
                my @e_fields = split(/\s+/, $lic);
	            print join(' ', @e_fields[0..5]), " \\\n";
	            print "\t", $e_fields[6], " \\\n";
	            print "\t", join(' ', @e_fields[7..10]), " \\\n";
	            print "\t", join(' ', @e_fields[11..22]), " \\\n";
	            print "\t", join(' ', @e_fields[23..34]), " \\\n";
	            print "\t", join(' ', @e_fields[35..scalar(@e_fields)-1]),
	            "<p>";
            }
	        next;
	    }
    }
    #-------------------------------------------------------------------
    push(@lic_stats, \@stats);      # store some statistics
    push(@lic_fields, \@fields);    # remember fields
    #-------------------------------------------------------------------
    # Build second stat table
    #-------------------------------------------------------------------
    if ( defined($lic_stats_count{$fields[1]}) ) {
    	$lic_stats_count{$fields[1]} = $lic_stats_count{$fields[1]} +
	    $fields[5];
    } else {
        $lic_stats_count{$fields[1]} = $fields[5];
    }
}

#-----------------------------------------------------------------------
# Check for VC_ESXHOST  > PROD_ESX_FULL + PROD_ESX_STARTER
# ? Too many VC agents; could be missing some ESX licenses ?
#-----------------------------------------------------------------------

my $sum = 0;
if (defined($lic_stats_count{'PROD_ESX_FULL'})) {
    $sum += $lic_stats_count{'PROD_ESX_FULL'};
}
if (defined($lic_stats_count{'PROD_ESX_STARTER'})) {
    $sum += $lic_stats_count{'PROD_ESX_STARTER'};
}
if (defined($lic_stats_count{'PROD_ESX_SUBSTARTER'})) {
    $sum += $lic_stats_count{'PROD_ESX_SUBSTARTER'};
}

if ( defined($lic_stats_count{'VC_ESXHOST'} ) ) {
    if ( $sum > $lic_stats_count{'VC_ESXHOST'} ) {
        print "<p><b>WARNING</b>: the total number of ",
              "ESX Server licenses (", $sum,
              ") exceeds the number of ",
              $pretty_types{'VC_ESXHOST'},
              " licenses (",
	          $lic_stats_count{'VC_ESXHOST'},
	          "). You may need to acquire more ",
              $pretty_types{'VC_ESXHOST'},
              " licenses.</p>";
    } elsif ( $sum < $lic_stats_count{'VC_ESXHOST'} ) {
        print "<p><b>WARNING</b>: the total number of ",
              "ESX Server host licenses (", $sum,
              ") is less than the total number of ",
              $pretty_types{'VC_ESXHOST'},
              " licenses (",
	          $lic_stats_count{'VC_ESXHOST'},
	          "). You may need to acquire more ESX Server host licenses.</p>";
    }
} else {
    print "<p><b>ERROR</b>: No ESX Server host license(s) found.</p>";
} 

#-----------------------------------------------------------------------
# Check for PROD_VC=1
#-----------------------------------------------------------------------

if ( defined($lic_stats_count{'PROD_VC'} ) ) {
    if ( $lic_stats_count{'PROD_VC'} != 1 ) {
        print "<p><b>WARNING</b>: The number of ",
            $pretty_types{'PROD_VC'},
            " licenses is not 1",
	      " (", $lic_stats_count{'PROD_VC'}, ")</p>";
    } 
} else {
    print "<p><b>ERROR</b>: No ",
        $pretty_types{'PROD_VC'},
        " license found.</p>";
} 

#-----------------------------------------------------------------------
# Check for number of VMOTION, DAS, DRS
#-----------------------------------------------------------------------

if ( defined($lic_stats_count{'VC_DAS'} ) ) {
    if ( defined($lic_stats_count{'VC_VMOTION'} ) ) {
        if ( $lic_stats_count{'VC_DAS'} >
             $lic_stats_count{'VC_VMOTION'} ) {
        print "<p><b>WARNING</b>: The number of ",
              $pretty_types{'VC_DAS'}, " licenses (",
              $lic_stats_count{'VC_DAS'}, ") should not be higher than ",
              "the number of ", $pretty_types{'VC_VMOTION'}, " licenses (",
              $lic_stats_count{'VC_VMOTION'}, ").</p>";
        }
    } else {
        print "<p><b>WARNING</b>: There are ", $pretty_types{'VC_DAS'},
              " licenses (",
              $lic_stats_count{'VC_DAS'},
              ") but no ", $pretty_types{'VC_VMOTION'}, " licenses</p>";
    }
} 

if ( defined($lic_stats_count{'VC_DRS'} ) ) {
    if ( defined($lic_stats_count{'VC_VMOTION'} ) ) {
        if ( $lic_stats_count{'VC_DRS'} >
             $lic_stats_count{'VC_VMOTION'} ) {
        print "<p><b>WARNING</b>: The number of ", $pretty_types{'VC_DAS'},
              " licenses (",
              $lic_stats_count{'VC_DRS'}, ") should not be higher than ",
              "the number of ", $pretty_types{'VC_VMOTION'},
              " licenses (", $lic_stats_count{'VC_VMOTION'}, ")</p>";
        }
    } else {
        print "<p><b>WARNING</b>: There are ", $pretty_types{'VC_DRS'},
              " licenses (", $lic_stats_count{'VC_DRS'},
              ") but no ", $pretty_types{'VC_VMOTION'},
              " licenses</p>";
    }
} 

#-----------------------------------------------------------------------
# What do we have by now?
#-----------------------------------------------------------------------

$dbg && print "<PRE>LICENSES = <BR>\n", Dumper(@lics), "</PRE><BR>\n";

#-----------------------------------------------------------------------
# Print statistics
#-----------------------------------------------------------------------

print "\n<BR><hr/><b>VALID LICENSES FOUND:</b><P>\n";

print "<table border=1>\n";
print "<tr><th>License</th><th>Count</th><th>Issued</th>" .
      "<th>ID</th><th>Expires</th></tr>\n";
foreach my $lic ( @lics ) {
    my ($_prod, $_count, $_issued, $_id, $_expires);
    ($_prod    = $lic) =~ s{^INCREMENT\s+(\S+)\s+.*$}{$1}g;
    ($_count   = $lic) =~ s{.*\s+(\d+)\s+VENDOR_STRING.*}{$1}g;
    ($_issued  = $lic) =~ s{.*ISSUED=(\S+)\s.*}{$1}g;
    ($_id      = $lic) =~ s{.*FulfillmentId=(\d+).*}{$1}g;
    ($_expires = $lic) =~ s{.*\s+(\S+)\s+\d+\s+VENDOR_STRING.*}{$1}g;
    print "<tr><td>", $pretty_types{$_prod},
          "</td><td>", $_count,
          "</td><td>", $_issued,
          "</td><td>", $_id,
          "</td><td>", $_expires,
          "</td></tr>";
}
print "</table><p>\n";

print "<hr><b>LICENSE TOTALS:</b><P>\n";

print "<table border=1>\n";
print "<tr><th>License</th><th>Count</th></tr>\n";

foreach my $key ( @types ) {
    my $ls_count = $lic_stats_count{$key} ? $lic_stats_count{$key} : 0;

    # Supress empty counts
    if ($ls_count > 0) {
        print "<tr><td>", $pretty_types{$key},
            "</td><td>", $ls_count, "</td></tr>";
    }
}
print "</table><p>\n";

#-----------------------------------------------------------------------
# Print final correct file
#-----------------------------------------------------------------------

print "<hr><B>LICENSES:</B><BR><HR/>\n";

print << "END_OF_HEADER_0";
<font color=red>
<strong>NOTE:</strong>
While this tool catches most license file problems, some unusual situations may not be handled correctly.  If the license file below does not work, please contact customer support.<br/>
<br/>
<ul>
<li>Copy all lines between and including hash (#) lines</li>
<li>Review and use with a VMware License Server</li>
</ul>
</font>
<hr/><BR>
<pre style="font-size:90%">
########################################################################
END_OF_HEADER_0

( my $self = $0 ) =~ s!.*/!!g;
print "# Produced by lic_check, ver. $version, ", qx(date);

print << "END_OF_HEADER_1";
#-----------------------------------------------------------------------
# Licensing Quickstart Guide: 
#     http://www.vmware.com/pdf/vi3_license_redemption.pdf 
# Licensing Chapter of the Installation & Upgrade Guide:
#     http://www.vmware.com/pdf/vi3_installation_guide.pdf
#-----------------------------------------------------------------------
END_OF_HEADER_1

print "# License Counts\n";

foreach my $key ( @types ) {
    my $ls_count = $lic_stats_count{$key} ?
                   $lic_stats_count{$key} : 0;
    # Suppress empty counts
    if ($ls_count > 0) {
        printf "# %35s %4d\n", $pretty_types{$key}, $ls_count;
    }
}

print << "END_OF_HEADER_2";
#-----------------------------------------------------------------------
END_OF_HEADER_2

print join("\n", @header), "\n";

foreach my $lic ( @lic_fields ) {
    print join(' ', @{$lic}[0..5]), " \\\n";
    print "\t", $lic->[6], " \\\n";
    print "\t", join(' ', @{$lic}[7..10]), " \\\n";
    print "\t", join(' ', @{$lic}[11..22]), " \\\n";
    print "\t", join(' ', @{$lic}[23..34]), " \\\n";
    print "\t", join(' ', @{$lic}[35..scalar(@{$lic})-1]), "\n";
}

print << "END_OF_HEADER_3";
# Add any additional licenses BELOW this comment.
########################################################################
</pre>
END_OF_HEADER_3

#=======================================================================
# HTML footer
#-----------------------------------------------------------------------

FOOTER:
print << "END_OF_HTML_FOOTER";
	</div>
	
	<div id="top-of-page">  
		<div id="iglobal-sites"></div>
		<div id="iprimary-navigation"></div>
		<div id="isite-tools"></div>
		<div id="ilanguage"></div>
		<div id="isearch-form"></div>
	</div>

	<div id="ifooter">
	</div>
	
</div>

<div id="custom-extras"></div>

<script src="https://www.vmware.com/app/template/" type="text/javascript"></script>
<script type="text/javascript" src="http://www.vmware.com/files/templates/inc/tracking.js"></script>
<script type="text/javascript" src="http://www.vmware.com/files/templates/inc/hbx.js"></script>
<script type="text/javascript" src="http://www.vmware.com/files/elqNow/elqCfg.js"></script>
<script type="text/javascript" src="http://www.vmware.com/files/elqNow/elqImg.js"></script>
</body>
</html>

END_OF_HTML_FOOTER

sub lic_print {
    my @lics;
    
}

# (@hosted);

#-----------------------------------------------------------------------
# $Id: lic_check.pl,v 1.76 2007-12-11 17:51:49 vadim Exp $
#-----------------------------------------------------------------------
# $Log: lic_check.pl,v $
# Revision 1.76  2007-12-11 17:51:49  vadim
# updated header with contacts
#
# Revision 1.75  2007-12-11 17:44:42  vadim
# 1. updated pretty names
# 2. relaxed matching 'licenseType=Server'
# 3. put additional info links on top
#
# Revision 1.74  2007-12-10 22:54:49  vadim
# little issue with counters - top table reported different counts. fixed.
#
# Revision 1.73  2007-12-10 20:03:38  vadim
# performed final tests with example of license file at
# https://wiki.eng.vmware.com/SampleWhitneyLicense
# everything seems to be OK.
#
# Revision 1.70  2007-12-10 19:47:09  vadim
# removal of dups was incorrect - fixed now
#
# Revision 1.68  2007-12-10 19:12:49  vadim
# update for 3.5 licenses
#
# Revision 1.66  2007-08-03 12:10:15  dean
# Applied new design template
#
# Revision 1.65  2006-11-20 22:58:17  cscott
# HTML compliance
#
# Revision 1.62  2006-11-17 01:03:28  cscott
# Lots of changes toward user-friendliness... formatting changes
# Silence a lot of verbose stuff and key it off of a verbose value
#
# Revision 1.61  2006-11-14 18:39:30  cscott
# Move informational lines to debug and set debug from CGI vars
#
# Revision 1.55  2006-11-13 17:35:50  cscott
# Collision resolution (oops) and additional cleanup for customer-facing
#
# Revision 1.54  2006-11-10 17:51:01  cscott
# Clean-up and more customer-friendly output.
#
# Revision 1.52  2006-09-26 23:58:15  vadim
# updated @types and fixed some statistics which did not use @types
#
# Revision 1.49  2006-08-22 20:51:59  vadim
# fixed licenseType, which now can be "production"
#
# Revision 1.48  2006-07-20 22:27:25  vadim
# added simple protection from no input
#-----------------------------------------------------------------------
