#!/usr/bin/perl -w

#-----------------------------------------------------------------------
# $Id: lic_check.pl,v 1.65 2006-11-20 22:58:17 cscott Exp $
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
my $q = new CGI;        # To have useful printing shortcuts
my @lic_stats;          # 1st table of statistics for licenses
my %lic_stats_count;    # 2nd table of statistics for licenses

my @types = ( 'PROD_VC', 'PROD_VC_STARTER', 'VC_VMOTION', 'VC_ESXHOST',
              'VC_SERVERHOST', 'VC_DAS', 'VC_DRS',
    	      'PROD_ESX_FULL', 'ESX_FULL_BACKUP', 'PROD_ESX_STARTER',
    	      'PROD_ESX_SUBSTARTER', 'PROD_ESX_VDI', 'ESX_VDI_VM'
       	    );

my %pretty_types = (
    'PROD_VC' => 'VC Management Server',
    'PROD_VC_STARTER' => 'PROD_VC_STARTER',
    'VC_VMOTION' => 'VMotion',
    'VC_ESXHOST' => 'VC_ESXHOST',
    'VC_SERVERHOST' => 'VC_SERVERHOST',
    'VC_DAS' => 'VC_DAS',
    'VC_DRS' => 'DRS',
    'PROD_ESX_FULL' => 'PROD_ESX_FULL',
    'ESX_FULL_BACKUP' => 'ESX_FULL_BACKUP',
    'PROD_ESX_STARTER' => 'PROD_ESX_STARTER',
    'PROD_ESX_SUBSTARTER' => 'PROD_ESX_SUBSTARTER',
    'PROD_ESX_VDI' => 'PROD_ESX_VDI',
    'ESX_VDI_VM' => 'ESX_VDI_VM'
);

my $type_pattern = "(" . join('|', @types) . ")";

#-----------------------------------------------------------------------
# HTTP & HTML header including TITLE of the page and H1 on the page
#-----------------------------------------------------------------------

print $q->header;
      #$q->start_html('Server-based License File Checker'),
      #$q->h1('Server-based License File Checker'),
      #$q->hr;

print << "END_OF_HTML_HEADER";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
<meta http-equiv="content-language" content="en-us" />
<title>Server-based License File Checker</title>
<meta name="description" content="VMware is the global leader in virtualization software, providing desktop and server virtualization products for virtual infrastructure solutions." />
<meta name="keywords" content="virtualization, virtualisation, virtualizing, server virtualization, desktop virtualization, storage virtualization, virtual machine, virtual infrastructure, virtual computing, community source, hypervisor, server consolidation, server containment, development and test, workstation, esx, esx server, gsx, virtualcenter, virtual server, vserver, vmserver, p2v, vmtn, virtual appliances, vm, vmwear, free virtualization" />
<meta name="copyright" content="VMware, Inc. All rights reserved." />
<meta name="robots" content="noodp" />
<meta name="robots" content="index,follow" />
<link rel="alternate" type="application/rss+xml" href="/sitemap.xml" />
<link rel="alternate" type="application/rss+xml" href="/ror.xml" />

<link rel="alternate" type="application/rss+xml" href="http://vmware.simplefeed.net/rss" />

<link rel="shortcut icon" type="image/x-icon" href="/favicon.ico" />
<link rel="stylesheet" type="text/css" href="/inc/web_linux.css" />


<link rel="stylesheet" type="text/css" href="/inc/print.css" media="print" />
<script type="text/javascript" src="/inc/library.js"></script>
<script type="text/javascript" src="/inc/hbx.js"></script>

</head>

<body>


<ul id="sites">
    <li><a href="/">VMware.com</a></li>

    <li class="expand" id="vmtn"><a href="/vmtn/">Technology Network (VMTN) <img src="/img/expand_dark.gif" width="6" height="3" alt="+" class="expand" /></a>
        <ul>
            <li><a href="/vmtn/">VMTN Home</a></li>
            <li><a href="/vmtn/technology/">Technology Centers</a></li>
            <li><a href="/vmtn/appliances/">Virtual Appliances</a></li>

            <li><a href="/vmtn/resources/">Technical Papers</a></li>

            <li><a href="/support/pubs/">Documentation</a></li>
            <li><a href="http://kb.vmware.com/">Knowledge Base</a></li>
            <li><a href="/community/">Discussion Forums</a></li>
            <li><a href="/vmug">User Groups</a></li>
            <li><a href="/vmtn/blog/">VMTN Blog</a></li>

            <li><a href="/vmtn/beta/">Beta Programs</a></li>

        </ul>
    </li>
    <li><a href="/worldwide.html">Worldwide</a></li>
</ul>


<div id="page-border">
  <div id="page">

    <div id="top-of-page">

      <div id="logo">

        <a href="/"><img src="/img/logo_top.gif" width="173" height="54" border="0" alt="VMware, Inc." /></a><br />
        <img src="/img/logo_bottom.gif" width="173" height="23" border="0" alt="VMware" />
      </div>
      
      <div id="site-tools">
                <ul>
           <li><a href="/download/">Downloads</a></li>

           <li class="expand"><a href="/vmwarestore/">Store<img src="/img/expand.gif" width="6" height="3" alt="+" class="expand" /><img src="/img/expand_dark.gif" width="6" height="3" alt="+" class="expand hover" /></a>
                   <ul>

                     <li><a href="/vmwarestore/">Store Home</a></li>
                     <li><a href="/vmwarestore/serverinfo.html">Non-Store Orders</a></li>
                     <li><a href="/vmwarestore/newstore/cart.jsp">Shopping Cart</a></li>
                     <li><a href="/vmwarestore/pricing.html">Pricing</a></li>

                     <li><a href="/vmwarestore/salesfaq.html">Store FAQs</a></li>
                     <li><a href="/partnerlocator">Find a Reseller</a></li>

                     <li><a href="http://www.vmwarestore.com/">Company Store</a></li>
                   </ul>
           </li>
           <li class="expand"><a href="/vmwarestore/newstore/account.jsp">Account <img src="/img/expand.gif" width="6" height="3" alt="+" class="expand" /><img src="/img/expand_dark.gif" width="6" height="3" alt="+" class="expand hover" /></a>

                   <ul>
                     <li><a href="/vmwarestore/newstore/account.jsp">Account Home</a></li>
                     <li><a href="/download/licensing.html">Product Licensing</a></li>

                     <li><a href="/vmwarestore/newstore/login.jsp">Sign In or Register</a></li>
                     <li><a href="/request_processor?nextPage=/logout.html&action=CUSTLOGOUT">Logout</a></li>
                   </ul>

           </li>
           <li><a href="/help/">Help</a></li>
           <li><a href="/company/contact.html">Contact</a></li>
        </ul>

      </div>
      
      <div id="search">
        
            <form method="get" action="http://search.vmware.com/search" name="f">

                <input type="hidden" name="site" value="VMware_Site" />
                <input type="hidden" name="client" value="VMware_Site" />
                <input type="hidden" name="filter" value="0" />             
                <input type="hidden" name="proxystylesheet" value="VMware_Site" />
                <input type="hidden" name="output" value="xml_no_dtd" />
                <input type="hidden" name="restrict" value="" />

                <input type="hidden" name="num" value="10" />
                <input type="text" name="q" value="" class="searchterms" />
                <button type="submit"><img src="/img/button_tools_search.gif" width="44" height="15" alt="Search" class="mozfix" /></button>

            </form>
            <div><a href="/search/">advanced search</a></div>

      </div>
      
      
      <div id="primary-navigation">
        

<ul>
    <li><a href="/overview/">Overview</a>
        <div>

<ul>
    <li><a href="/overview/home.html">Overview Home</a></li>
    <li><a href="/virtualization/">Intro to Virtualization</a></li>
    <li><a href="/vinfrastructure/">Virtual Infrastructure </a></li>
    <li><a href="/appliances/">Virtual Appliances</a></li>

    <li><a href="/interfaces/">Open Interfaces and Formats</a></li>

</ul>
        </div></li></li>
    <li><a href="/solutions/">Solutions</a>
        <div>
<ul>
    <li><a href="/solutions/home.html">Solutions Home</a></li>
    <li><a href="/solutions/consolidation/">Server Consolidation</a></li>

    <li><a href="/solutions/development/">Development and Test Optimization</a></li>

    <li><a href="/solutions/continuity/">Business Continuity</a></li>
    <li><a href="/solutions/desktop/">Desktop Manageability and Security</a></li>
    <li><a href="/industry/government/">Government</a></li>
</ul>
        </div></li></li>
    <li><a href="/products/">Products</a>

        <div>

<ul>
    <li><a href="/products/home.html">Products Home</a></li>
    <li><a href="/products/data_center.html">Data Center Products</a></li>
    <li><a href="/products/developer_products.html">Developer Products</a></li>
    <li><a href="/products/enterprise_desktop.html">Enterprise Desktop Products</a></li>
    <li><a href="/products/accelerator.html">Accelerator Products</a></li>

    <li><a href="/products/free_virtualization.html">Free Virtualization Products</a></li>
    <li><a href="/products/product_index.html">Product Index</a></li>
</ul>
        </div></li></li>
    <li><a href="/services/">Services</a>
        <div>
<ul>
    <li><a href="/services/home.html">Services Home</a></li>

    <li><a href="/services/consulting.html">Consulting Services</a></li>
    <li><a href="/services/education-r.html">Education Services</a></li>
    <li><a href="/services/certification-r.html">Certification</a></li>
</ul>
        </div></li></li>
    <li><a href="/resources/">Resources</a>
        <div>

<ul>
    <li><a href="/resources/home.html">Resource Center Home</a></li>
    <li><a href="/events/">Events</a></li>
    <li><a href="/solutions/whitepapers.html">White Papers</a></li>
    <li><a href="/resources/techpapers-r.html">Technical Papers</a></li>
    <li><a href="/r/resources-stories.html">Customer Success Stories</a></li>

    <li><a href="/r/resources-documentation.html">Documentation</a></li>

    <li><a href="/resources/communities.html">Communities</a></li>
</ul>
        </div></li></li>
    <li><a href="/support/">Support</a>
        <div>
<ul>
    <li><a href="/support/home.html">Support Home</a></li>

    <li><a href="/r/support_requests.html">Support Requests</a></li>

    <li><a href="/support/phone_support.html">Phone Support</a></li>
    <li><a href="/support/services/">Support Services</a></li>
    <li><a href="/support/policies/">Support Policies</a></li>
    <li><a href="/r/documentation.html">Documentation</a></li>
    <li><a href="/r/knowledgebase.html">Knowledgebase</a></li>

    <li><a href="/r/discussion_forums.html">Discussion Forums</a></li>

    <li><a href="/r/your_account.html">Your Account</a></li>
    <li><a href="/r/product_licensing.html">Product Licensing</a></li>
</ul>
        </div></li></li>
    <li><a href="/customers/">Customers</a>
        <div>

<ul>
    <li><a href="/customers/home.html">Customers Home</a></li>

    <li><a href="/r/success_stories.html">Success Stories</a></li>
    <li><a href="/customers/program.html">Core Customer Program</a></li>
</ul>
        </div></li></li>
    <li><a href="/partners/">Partners</a>

        <div>
<ul>
    <li><a href="/partners/home.html">Partners Home</a></li>

    <li><a href="/partners/alliances/">Partner Showcase</a></li>
    <li><a href="/partners/alliances/programs/">Technology Alliance Program</a></li>
    <li><a href="/partners/vip/">Reseller Program</a></li>
    <li><a href="/partners/vac/index-overview.html">Authorized Consulting (VAC) Program</a></li>

    <li><a href="/partners/partners.html">Partner Sign-in</a></li>
    <li><a href="/partnerlocator/">Find a Reseller/Consultant</a></li>

</ul>
        </div></li></li>
    <li class=""><a href="/company/">About Us</a>
        <div>
<ul>
    <li><a href="/company/home.html">About Us Home</a></li>

    <li><a href="/company/news/index-r.html">News & Awards</a></li>
    <li><a href="/company/leadership.html">Leadership </a></li>

    <li><a href="/company/ir.html">Investor Relations</a></li>
    <li><a href="/company/jobs/">Jobs at VMware</a></li>
    <li><a href="/company/office_california-r.html">Office Locations</a></li>

    <li><a href="/company/contact-r.html">Contact VMware</a></li>
</ul>
        </div></li></li>
</ul>

      </div>
      
      
    </div>
    
    
    <div id="toolbox">
      <ul id="breadcrumbs">
      </ul>

      <ul id="page-tools">
        <li><a href="/vmwarestore/newstore/inc/email_page.jsp" target="wForm" class="popupLink">Email Page</a> <a href="/vmwarestore/newstore/inc/email_page.jsp" target="wForm" class="popupLink"><img src="/img/button_email.gif" align="absmiddle" border="0" /></a></li>
        <li><a onmouseout="window.status='';return true;" href="javascript:window.print();" onmouseover="window.status='Print';return true;">Print Page</a> <a onmouseout="window.status='';return true;" href="javascript:window.print();" onmouseover="window.status='Print';return true;"><img src="/img/button_print.gif" align="absmiddle" border="0" /></a></li>

      </ul>
    </div>
    

    <div id="content-wrapper" class="wider">

    <div id="content">
END_OF_HTML_HEADER

#-----------------------------------------------------------------------
# This section will contain all MESSAGES related to processing
#-----------------------------------------------------------------------

#print "<b>PROCESSING LICENSES</b><hr>";

#-----------------------------------------------------------------------
# Let's retrieve the license file from STDIN
#-----------------------------------------------------------------------

my %cgivars =  Vars();
my $lic_file = $cgivars{'LICENSE'};

# Set the DEBUG level from the CGI
my $D = $cgivars{'DEBUG'} || 0;

# Use a verbose variable for now to avoid a lot of spurious output
# in the interest of getting this out sooner rather than later
my $V = $cgivars{'VERBOSE'} || 0;

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
# Break accidently glued to the previous line INCREMENTs
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
    if ($V) {
        print "<br><b>WARNING</b>: Duplicate headers were detected and ".
            "discarded:<p>";
        print join("\n", grep { ! /^INCREMENT/ }
                          @input_lines[3..scalar(@input_lines)-1] ),
	    "<p>";
    }
}

print "<hr><pre><B>LINES:</B><BR>", Dumper(@lics), "</pre><hr>"
    if ($D);

#-----------------------------------------------------------------------
# Drop hosted
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: checking for hosted licenses<br>" if ($D);
my @hosted = grep { /licenseType=Host/ } @lics;
if ( scalar(@hosted) != 0 && $V) {
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

#-----------------------------------------------------------------------
# General check for INCREMENT format
#-----------------------------------------------------------------------

print "<b>NOTICE</b>: checking general INCREMENT format<p>" if ($D);
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
        if ($V) {
            print "<p><b>WARNING:</b> ",
                "A license in an unrecognized format has been removed:</p>";
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
        }
    } else {
        push(@lics, $f_lic);
    }
}

#-----------------------------------------------------------------------
# Check for duplicates
#-----------------------------------------------------------------------

print "<p><b>NOTICE</b>: checking for duplicates</p>" if ($D);
my %dups;
foreach my $d_lic ( @lics ) {
    if ( ! exists($dups{$d_lic}) ) {
        $dups{$d_lic} = 1;
    } else {
        if ($V) {
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
# Print statistics
#-----------------------------------------------------------------------

print "<hr><b>VALID LICENSES FOUND</b><hr>";

print "<table border=1>\n";
print "<tr><th>License</th><th>Count</th><th>Issued</th>" .
      "<th>ID</th><th>Expires</th></tr>\n";
foreach my $lic ( @lic_stats ) {
    print "<tr><td>", $pretty_types{$lic->[0]},
          "</td><td>", $lic->[1],
          "</td><td>", $lic->[2],
          "</td><td>", $lic->[3],
          "</td><td>", $lic->[4],
          "</td></tr>";
}
print "</table><p>\n";

print "<hr><b>LICENSE TOTALS</b><hr>";

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

print "<hr><B>LICENSES</B><hr>";

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
<hr/>
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
    </div>
    <div id="footer">
        <div class="inner">

        
<p>Copyright &copy; 2006 VMware, Inc. All rights reserved.</p>
<ul>
  <li><a href="/help/legal.html">Legal</a></li>

  <li><a href="/help/privacy.html">Privacy</a></li>
  <li><a href="/help/accessibility.html">Accessibility</a></li>
  <li><a href="/site_index.html">Site Index</a></li>

</ul>
<div align="right"><a href="http://vmware.simplefeed.net/subscription" class="rssfeed"><img src="http://www.vmware.com/img/rss.gif" border="0" alt="RSS Newsfeed" align="absmiddle" /></a></div>
        </div>
        <div id="footer-corner"><div><!-- . --></div></div>
    </div>

  </div>
</div>



<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>

<script type="text/javascript">
_uacct = "UA-225180-1";
urchinTracker();
</script>

</body>
</html>
END_OF_HTML_FOOTER

sub lic_print {
    my @lics;
    
}

# (@hosted);

#-----------------------------------------------------------------------
# $Id: lic_check.pl,v 1.65 2006-11-20 22:58:17 cscott Exp $
#-----------------------------------------------------------------------
# $Log: lic_check.pl,v $
# Revision 1.65  2006-11-20 22:58:17  cscott
# HTML compliance
#
# Revision 1.64  2006-11-20 18:11:38  cscott
# More beautification, one small bug fix
#
# Revision 1.63  2006-11-17 20:13:43  cscott
# Take two on the branding... still not right but closer
#
# Revision 1.62  2006-11-17 01:03:28  cscott
# Lots of changes toward user-friendliness... formatting changes
# Silence a lot of verbose stuff and key it off of a verbose value
#
# Revision 1.61  2006-11-14 18:39:30  cscott
# Move informational lines to debug and set debug from CGI vars
#
# Revision 1.60  2006-11-14 17:50:32  cscott
# I think taht's the last of it
#
# Revision 1.59  2006-11-14 17:37:58  cscott
# Beautification project continues...
#
# Revision 1.58  2006-11-13 19:22:20  cscott
# Some warnings were backwards... use friendly names more often
#
# Revision 1.57  2006-11-13 18:50:24  cscott
# Some known license names, minor bug fix
#
# Revision 1.56  2006-11-13 17:56:24  cscott
# More changes
#
# Revision 1.55  2006-11-13 17:35:50  cscott
# Collision resolution (oops) and additional cleanup for customer-facing
#
# Revision 1.54  2006-11-10 17:51:01  cscott
# Clean-up and more customer-friendly output.
#
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
