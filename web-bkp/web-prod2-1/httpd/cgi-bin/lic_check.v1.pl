#!/usr/bin/perl -w

#-----------------------------------------------------------------------
# $Id: lic_check.pl,v 1.53 2006-09-26 23:59:04 vadim Exp $
#-----------------------------------------------------------------------
# Authors:     vadim
# Description: Validate license file
#-----------------------------------------------------------------------

use strict;                          # Makes life REALLY miserable
use Data::Dumper;                    # For debugging
use Date::Parse;
use CGI qw(:standard escapeHTML Vars);

#-----------------------------------------------------------------------
# Variables
#-----------------------------------------------------------------------

my $version = "1.2";    # Current version of the script
my $q = new CGI;        # To have usefull printing shortcuts
my @lic_stats;          # 1st table of statistics for licenses
my %lic_stats_count;    # 2nd table of statistics for licenses

my @types = ( 'PROD_VC', 'PROD_VC_STARTER', 'VC_VMOTION', 'VC_ESXHOST',
              'VC_SERVERHOST', 'VC_DAS', 'VC_DRS',
	      'PROD_ESX_FULL', 'ESX_FULL_BACKUP', 'PROD_ESX_STARTER',
	      'PROD_ESX_SUBSTARTER', 'PROD_ESX_VDI', 'ESX_VDI_VM'
	    );
my $type_pattern = "(" . join('|', @types) . ")";

#-----------------------------------------------------------------------
# HTTP & HTML header including TITLE of the page and H1 on the page
#-----------------------------------------------------------------------

print $q->header,
      $q->start_html('Server-based License File Checker'),
      $q->h1('Server-based License File Checker'),
      $q->hr;

#-----------------------------------------------------------------------
# This section will contain all MESSAGES related to processing
#-----------------------------------------------------------------------

print "<pre>";
print "<b>PROCESSING LICENSES</b><hr>";

#-----------------------------------------------------------------------
# Let's retrieve the license file from STDIN
#-----------------------------------------------------------------------

my %cgivars =  Vars();
my $lic_file = $cgivars{'LICENSE'};

#=======================================================================
# PERFORM PREPROCESSING & SIMPLE SANITY CHECKS
#=======================================================================

if ( ( $lic_file eq ''          ) ||
     ( $lic_file !~ /INCREMENT/ )  ) {
    print "<b>NOTICE</b>: WRONG INPUT. EXITING...<br>";
    goto FOOTER;
}

#-----------------------------------------------------------------------
# Fix some letter cases
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: fix letter cases in keywords<br>";
foreach my $word ( 'INCREMENT', 'SERVER', 'this_host', 'ANY',
                   'VENDOR', 'VMWARELM', 'port=', 'permanent',
		   'VENDOR_STRING', 'licenseType=Server',
		   'capacityType=cpuPackage', 'ISSUED',
		   'NOTICE=FulfillmentId', 'SIGN='
		 ) {
    $lic_file =~ s/$word/$word/gie;
}

#-----------------------------------------------------------------------
# Break accidently glued to the previous line INCREMENTs
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: unglue joined together INCREMENTs<br>";
$lic_file =~ s/INCREMENT/\nINCREMENT/g;

#=======================================================================
# MAIN PROCESSING
#=======================================================================

print "<b>NOTICE</b>: unwrap INCREMENTs on backslashes<br>";
$lic_file =~ s/\s*\\\s+/ /g;                   # Unwrap lines on \ @ EOL

print "<b>NOTICE</b>: split file into separate lines<br>";
my @input_lines = split(/[\n\r]+/, $lic_file); # Split file into lines

print "<b>NOTICE</b>: drop all comment and empty lines<br>";
@input_lines = grep { ! /^\s*(#|$)/ }          # Drop empty and ...
                   @input_lines;               # ... comment lines

print "<b>NOTICE</b>: remove leading and training spaces<br>";
foreach my $idx ( 0 .. scalar(@input_lines)-1 ) {
    $input_lines[$idx] =~ s/^\s+//g;           # Remove leading spaces
    $input_lines[$idx] =~ s/\s+$//g;           # Remove training spaces
}

#-----------------------------------------------------------------------
# Drop any lines, which do not start with proper words
#-----------------------------------------------------------------------

my @wrong = grep { ! /^(SERVER|VENDOR|USE_SERVER|INCREMENT)/ }
                     @input_lines;
if ( scalar(@wrong) != 0 ) {
    print "<br><b>WARNING: ", scalar(@wrong),
	  "</b> lines being dropped due to incorrect first word:<p>";
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

print "<b>NOTICE</b>: checking header<br>";
if ( ( $input_lines[0] !~ /SERVER this_host ANY [0-9]{1,5}/ ) ||
     ( $input_lines[1] !~ /VENDOR VMWARELM port=[0-9]{1,5}/ ) ||
     ( $input_lines[2] !~ /USE_SERVER/                      ) ) {
    print "<br><b>ERROR</b>: Incorrect header:<p>",
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

print "<b>NOTICE</b>: checking for duplicate headers<br>";
my @lics = grep { /^INCREMENT/ } @input_lines;
if ( scalar(@lics) != scalar(@input_lines)+3 ) {
    print "<br><b>WARNING</b>: Duplicate headers were discarded:<p>";
    print join("\n", grep { ! /^INCREMENT/ }
                          @input_lines[3..scalar(@input_lines)-1] ),
	  "<p>";
}

# print "<hr><pre><B>LINES:</B><BR>", Dumper(@lics), "</pre><hr>";

#-----------------------------------------------------------------------
# Drop hosted
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: checking for hosted licenses<br>";
my @hosted = grep { /licenseType=Host/ } @lics;
if ( scalar(@hosted) != 0 ) {
    print "<br><b>WARNING: ", scalar(@hosted),
          "</b> hosted licenses were encountered and dropped:<p>";
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

#-----------------------------------------------------------------------
# General check for INCREMENT format
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: checking general INCREMENT format<p>";

my @wrong_format = splice(@lics);
foreach my $f_lic ( @wrong_format ) {
    if ( $f_lic !~ /
             ^INCREMENT\s+
             $type_pattern\s+
             VMWARELM\s+.*\s
             VENDOR_STRING=licenseType=(Server|production).*
             ISSUED=.*
             NOTICE=["]{0,1}FulfillmentId=[0-9]+.*["]{0,1}\s+
             SIGN="
             [0-9a-fA-F]{4}(\s[0-9a-fA-F]{4}){8,}
             "$/gx ) {
        print "<b>WARNING:</b> ",
            "license is in wrong format and being dropped:<p>";
        my @f_fields = split(/\s+/, $f_lic);
	print join(' ', @f_fields[0..5]);
	if ( scalar(@f_fields) >  6 ) {
	    print " \\\n\t", $f_fields[6];
	}
	if ( scalar(@f_fields) > 10 ) {
	    print " \\\n\t", join(' ', @f_fields[7..10]);
	}
	if ( scalar(@f_fields) > 22 ) {
	    print " \\\n\t", join(' ', @f_fields[11..22]);
	}
	if ( scalar(@f_fields) > 34 ) {
	    print " \\\n\t", join(' ', @f_fields[23..34]);
	}
	if ( scalar(@f_fields) > 35 ) {
	    print " \\\n\t",
	          join(' ', @f_fields[35..scalar(@f_fields)-1]);
        }
	print "<br>\n";
    } else {
        push(@lics, $f_lic);
    }
}

#-----------------------------------------------------------------------
# Check for duplicates
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: checking for duplicates<br>";
my %dups;
foreach my $d_lic ( @lics ) {
    if ( ! exists($dups{$d_lic}) ) {
        $dups{$d_lic} = 1;
    } else {
        print "<br><b>ERROR</b>: ", "duplicate license being dropped:<p>";
    	my @d_fields = split(/\s+/, $d_lic);
	    print join(' ', @d_fields[0..5]), " \\\n";
        print "\t", $d_fields[6], " \\\n";
        print "\t", join(' ', @d_fields[7..10]), " \\\n";
        print "\t", join(' ', @d_fields[11..22]), " \\\n";
        print "\t", join(' ', @d_fields[23..34]), " \\\n";
        print "\t", join(' ', @d_fields[35..scalar(@d_fields)-1]), "<p>";
    }
}
my @tmp_lics = sort keys %dups;
@lics = ();
foreach my $type ( @types ) {
    push(@lics, grep { /$type/ } @tmp_lics);
}

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
            print "<b>WARNING</b>: expired license being dropped:<p>";
            my @e_fields = split(/\s+/, $lic);
	    print join(' ', @e_fields[0..5]), " \\\n";
	    print "\t", $e_fields[6], " \\\n";
	    print "\t", join(' ', @e_fields[7..10]), " \\\n";
	    print "\t", join(' ', @e_fields[11..22]), " \\\n";
	    print "\t", join(' ', @e_fields[23..34]), " \\\n";
	    print "\t", join(' ', @e_fields[35..scalar(@e_fields)-1]),
	    "<p>";
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
        print "<b>WARNING</b>: number of ",
              "PROD_ESX_FULL+PROD_ESX_STARTER+PROD_ESX_SUBSTARTER (", $sum,
              ") licenses exceeds number of VC_ESXHOST licenses (",
	          $lic_stats_count{'VC_ESXHOST'},
	          ") - ESX licenses might be missing<p>";
    } elsif ( $sum < $lic_stats_count{'VC_ESXHOST'} ) {
        print "<b>WARNING</b>: number of ",
              "PROD_ESX_FULL+PROD_ESX_STARTER (", $sum,
              ") licenses less than number of VC_ESXHOST licenses (",
	          $lic_stats_count{'VC_ESXHOST'},
	          ")<br>you should add more VC_ESXHOST licenses<p>";
    }
} else {
    print "<b>ERROR</b>: No VC_ESXHOST license found<p>";
} 

#-----------------------------------------------------------------------
# Check for PROD_VC=1
#-----------------------------------------------------------------------

if ( defined($lic_stats_count{'PROD_VC'} ) ) {
    if ( $lic_stats_count{'PROD_VC'} != 1 ) {
        print "<b>WARNING</b>: Number of PROD_VC licenses is not 1",
	      " (", $lic_stats_count{'PROD_VC'}, ")<p>";
    } 
} else {
    print "<b>ERROR</b>: No PROD_VC license found<p>";
} 

#-----------------------------------------------------------------------
# Check for number of VMOTION, DAS, DRS
#-----------------------------------------------------------------------

if ( defined($lic_stats_count{'VC_DAS'} ) ) {
    if ( defined($lic_stats_count{'VC_VMOTION'} ) ) {
        if ( $lic_stats_count{'VC_DAS'} >
             $lic_stats_count{'VC_VMOTION'} ) {
        print "<b>WARNING</b>: Number of VC_DAS licenses (",
              $lic_stats_count{'VC_DAS'}, ") should not be higher than ",
              "number of VC_VMOTION licenses (",
              $lic_stats_count{'VC_VMOTION'}, ")<p>";
        }
    } else {
        print "<b>WARNING</b>: There are VC_DAS licenses (",
              $lic_stats_count{'VC_DAS'},
              ") but no VC_VMOTION licenses<p>";
    }
} 

if ( defined($lic_stats_count{'VC_DRS'} ) ) {
    if ( defined($lic_stats_count{'VC_VMOTION'} ) ) {
        if ( $lic_stats_count{'VC_DRS'} >
             $lic_stats_count{'VC_VMOTION'} ) {
        print "<b>WARNING</b>: Number of VC_DRS licenses (",
              $lic_stats_count{'VC_DRS'}, ") should not be higher than ",
              "number of VC_VMOTION licenses (",
              $lic_stats_count{'VC_VMOTION'}, ")<p>";
        }
    } else {
        print "<b>WARNING</b>: There are VC_DRS licenses (",
              $lic_stats_count{'VC_DRS'},
              ") but no VC_VMOTION licenses<p>";
    }
} 

#-----------------------------------------------------------------------
# Print statistics
#-----------------------------------------------------------------------

print "<hr><b>VALID LICENSES FOUND</b><hr>";

print "<table border=1>\n";
print "<tr><td>License</td><td>Count</td><td>Issued</td>" .
      "<td>ID</td><td>Expires</td></tr>\n";
foreach my $lic ( @lic_stats ) {
    print "<tr><td>", $lic->[0],
          "</td><td>", $lic->[1],
          "</td><td>", $lic->[2],
          "</td><td>", $lic->[3],
          "</td><td>", $lic->[4],
          "</td></tr>";
}
print "</table><p>\n";

print "<hr><b>LICENSE TOTALS</b><hr>";

print "<table border=1>\n";
print "<tr><td>License</td><td>Count</td></tr>\n";

foreach my $key ( @types ) {
    my $ls_count = $lic_stats_count{$key} ?
                   $lic_stats_count{$key} : 0;
    print "<tr><td>", $key,
          "</td><td>", $ls_count,
	  "</td></tr>";
}
print "</table><p>\n";

#-----------------------------------------------------------------------
# Print final correct file
#-----------------------------------------------------------------------

print "<hr><B>LICENSE</B><hr>";

print << "END_OF_HEADER_0";
<font color=red>
Bear in mind, that this tool can not catch 100% of possible problems, so,
please:

*) Copy all lines between and including all-hash lines
*) Don't take output as a gospel and abandon common sense (C) James Pham
*) Review and use output with VMware License Server
</font>
########################################################################
END_OF_HEADER_0

( my $self = $0 ) =~ s!.*/!!g;
print "# Produced by $self, ver. $version, ", qx(date);

print << "END_OF_HEADER_1";
#-----------------------------------------------------------------------
# Licensing Quickstart Guide: 
#     http://www.vmware.com/pdf/vi3_license_redemption.pdf 
# Licensing Chapter of the Installation & Upgrade Guide:
#     http://www.vmware.com/pdf/vi3_installation_guide.pdf
#-----------------------------------------------------------------------
END_OF_HEADER_1

print "# License Count\n";

foreach my $key ( @types ) {
    my $ls_count = $lic_stats_count{$key} ?
                   $lic_stats_count{$key} : 0;
    printf "# %20s %4d\n", $key, $ls_count;
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
#-----------------------------------------------------------------------
# This is the end ... (C) Jim Morrison
#-----------------------------------------------------------------------
# Any additional licenses to be added BELOW this comment.
########################################################################
END_OF_HEADER_3

#=======================================================================
# HTML footer
#-----------------------------------------------------------------------

FOOTER:
print "</pre>", $q->hr,
      "Product Support Engineering",
      $q->br,
      'Questions, issues, problems, bugs? - ',
      '<a href="mailto:vadim@vmware.com">Vadim Kouevda</a>',
      ' or <a href="mailto:egray@vmware.com">Eric Gray</a>',
      $q->end_html;

sub lic_print {
    my @lics;
    
}

# (@hosted);

#-----------------------------------------------------------------------
# $Id: lic_check.pl,v 1.53 2006-09-26 23:59:04 vadim Exp $
#-----------------------------------------------------------------------
# $Log: lic_check.pl,v $
# Revision 1.53  2006-09-26 23:59:04  vadim
# updated version to 1.2 due to changes regarding Whitney
#
# Revision 1.52  2006-09-26 23:58:15  vadim
# updated @types and fixed soime statistics which did not use @types
#
# Revision 1.51  2006-09-26 23:52:34  vadim
# fixed tool for Whitney
#
# Revision 1.50  2006-08-22 20:59:07  vadim
# updated accordingly version
#
# Revision 1.49  2006-08-22 20:51:59  vadim
# fixed licenseType, which now can be "production"
#
# Revision 1.48  2006-07-20 22:27:25  vadim
# added simple protection from no input
#
# Revision 1.47  2006-07-20 19:41:29  vadim
# *** empty log message ***
#
# Revision 1.46  2006-07-20 17:00:08  vadim
# *** empty log message ***
#
# Revision 1.45  2006-07-19 23:49:36  vadim
# *** empty log message ***
#
# Revision 1.44  2006-07-19 15:52:21  vadim
# *** empty log message ***
#
# Revision 1.43  2006-07-19 00:08:05  vadim
# *** empty log message ***
#
# Revision 1.42  2006-07-19 00:07:02  vadim
# *** empty log message ***
#
# Revision 1.41  2006-07-19 00:06:10  vadim
# *** empty log message ***
#
# Revision 1.40  2006-07-19 00:03:00  vadim
# *** empty log message ***
#
# Revision 1.39  2006-07-19 00:00:56  vadim
# *** empty log message ***
#
# Revision 1.38  2006-07-18 23:56:32  vadim
# *** empty log message ***
#
# Revision 1.37  2006-07-18 23:49:38  vadim
# *** empty log message ***
#
#-----------------------------------------------------------------------

