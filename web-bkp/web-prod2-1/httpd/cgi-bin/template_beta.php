#!/usr/local/apache-ssl/cgi-bin/php.cgi
<?php
$referer = $_SERVER['HTTP_REFERER'];
$allowed = array('vmware.com','vmware.rsc02.net','simplefeed.net');
/*
if ($referer) {
  $pass = false;
  foreach ($allowed as $q) {
    if (preg_match("/^http.*\:\/\/.*$q\//",$referer)) $pass = $q;
  }
  if (!$pass) exit;
} else { exit; }
*/

header('Content-type: text/javascript');

include ('./cache_start.php');

$whichset = $_GET['set'];
if ($whichset) {
  printScripts($whichset);
}

print <<<END
function vmimport(url,whichlayer) {
  document.getElementById(whichlayer).innerHTML = url;
}

loadTemplate(); //global template
END;

include ('./cache_end.php');

function printScripts($set) {
  print "\nloadTemplate = function() {";
    switch ($set) {
      case 'main':
          print("\n  vmimport(\"".getInc($set,'sites')."\",\"mysites\");");
	  print("\n  vmimport(\"".getInc($set,'site-tools_text')."\",\"site-tools\");");
	  print("\n  vmimport(\"".getInc($set,'search_text')."\",\"search\");");
	  print("\n  vmimport(\"".getInc($set,'primary_nav')."\",\"primary-navigation\");");
	  print("\n  vmimport(\"".getInc($set,'footer_text')."\",\"myfooter\");");
      break;
      case 'vmtn':
          print("\n  vmimport(\"".getInc($set,'vmtn_toolbar')."\",\"mytoolbar\");");
	  print("\n  vmimport(\"".getInc('main','footer_text')."\",\"footer\");");
	  if ($_GET['side']) {
	    $leftnav = preg_replace ("/<.*(left-nav-td|leftnav)[^>]*>/","",getInc($set,'vmtn_leftnav'));
	    $leftnav = preg_replace ("/<\/td>$/","",$leftnav);
	    print("\n  vmimport(\"".$leftnav."\",\"leftnav\");");
	  }
      break;
      default:
          print("\n  vmimport(\"".getInc($set,'sites')."\",\"mysites\");");
          print("\n  vmimport(\"".getInc($set,'site-tools_text')."\",\"site-tools\");");
          print("\n  vmimport(\"".getInc($set,'search_text')."\",\"search\");");
          print("\n  vmimport(\"".getInc($set,'primary_nav')."\",\"primary-navigation\");");
          print("\n  vmimport(\"".getInc($set,'footer_text')."\",\"myfooter\");");
      break;
    }
  print "\n}\n\n";
}

function getInc($set,$item) {
  switch ($set) {
    case 'main':
      if (isset($item)) {
        $file = file_get_contents('http://www.vmware.com/inc/' . $item . '.htmlf');
        $file = preg_replace ("/(href=\"\/)/","href=\"http://www.vmware.com/",$file);
        $file = preg_replace ("/(src=\"\/)/","src=\"http://www.vmware.com/",$file);
        $file = preg_replace ("/[\r\n\t]+/","",$file);
        $file = addslashes($file);
        return $file;
      } else {
        break;
      }
    break;
    case 'vmtn':
      if (isset($item)) {
        $file = file_get_contents('http://www.vmware.com/vmtn/inc/' . $item . '.htmlf');
        $file = preg_replace ("/(href=\"\/)/","href=\"http://www.vmware.com/",$file);
        $file = preg_replace ("/(src=\"\/)/","src=\"http://www.vmware.com/",$file);
        $file = preg_replace ("/[\r\n\t]+/","",$file);
        $file = addslashes($file);
        return $file;
      } else {
        break;
      }
    break;
    case 'jp':
      if (isset($item)) {
        $file = file_get_contents('http://www.vmware.com/jp/inc/' . $item . '.htmlf');
	//$file = urlencode(utf8_encode($file));
        $file = preg_replace ("/(href=\"\/)/","href=\"http://www.vmware.com/",$file);
        $file = preg_replace ("/(src=\"\/)/","src=\"http://www.vmware.com/",$file);
        $file = preg_replace ("/[\r\n\t]+/","",$file);
        $file = addslashes($file);
        return $file;
      } else {
        break;
      }
    break;
    case 'de':
      if (isset($item)) {
        $file = file_get_contents('http://www.vmware.com/de/inc/' . $item . '.htmlf');
        $file = preg_replace ("/(href=\"\/)/","href=\"http://www.vmware.com/",$file);
        $file = preg_replace ("/(src=\"\/)/","src=\"http://www.vmware.com/",$file);
        $file = preg_replace ("/[\r\n\t]+/","",$file);
        $file = addslashes($file);
        return $file;
      } else {
        break;
      }
    break;
    case 'fr':
      if (isset($item)) {
        $file = file_get_contents('http://www.vmware.com/fr/inc/' . $item . '.htmlf');
        $file = preg_replace ("/(href=\"\/)/","href=\"http://www.vmware.com/",$file);
        $file = preg_replace ("/(src=\"\/)/","src=\"http://www.vmware.com/",$file);
        $file = preg_replace ("/[\r\n\t]+/","",$file);
        $file = addslashes($file);
        return $file;
      } else {
        break;
      }
    break;
    default:
      return '<font color="#ff0000">syntax error</font>';
    break;
  }
}

?>

