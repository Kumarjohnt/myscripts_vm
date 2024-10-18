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

//print("alert(\"". $referer . ", pass? " . $pass ."\");"); //DEBUG

$whichset = $_GET['set'];
if ($whichset) {
  printScripts($whichset);
}

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
      break;
      default:
        print '<font color="#ff0000">syntax error</font>';
      break;
    }
  print "\n}\n\n";
}

function getInc($set,$item) {
  switch ($set) {
    case 'main':
      if (isset($item)) {
        $file = addslashes(preg_replace ( "/[\r\n\t]+/" , "" , (file_get_contents('http://www.vmware.com/inc/' . $item . '.htmlf'))));
        return $file;
      } else {
        break;
      }
    break;
    case 'vmtn':
      if (isset($item)) {
        $file = addslashes(preg_replace ( "/[\r\n\t]+/" , "" , (file_get_contents('http://www.vmware.com/vmtn/inc/' . $item . '.htmlf'))));
        return $file;
      } else {
        break;
      }
    break;
    default:
      print '<font color="#ff0000">syntax error</font>';
    break;
  }
}

print <<<END
function vmimport(url,whichlayer) {
  document.getElementById(whichlayer).innerHTML = url;
}

loadTemplate(); //global template
END;

?>

