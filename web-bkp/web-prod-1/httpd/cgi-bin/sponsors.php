#!/usr/local/apache-ssl/cgi-bin/php.cgi
<?php

$sourcefile = "http://pa-webdev2.vmware.com/sponsors/vmworld_sponsors.xml";
$finalfile  = "/usr/local/apache-ssl/cgi-bin/vmworld_sponsors.xml";

if (isset($_GET['update'])) {
	$newfile = file_get_contents($sourcefile);
	file_put_contents($finalfile,$newfile) or die("cannot write to file!");
} else {
        header("Content-type: text/xml;");
        $str = file_get_contents($finalfile);
        echo $str;
}

exit;

?>
