<?php 
//ini_set("track_errors",true);
//ini_set("display_errors",false);

$g_break = chr(10).chr(13);

$AddNewRecord = "<input type='image' name='AddRecord' id='AddRecord' src='images/newgreen.gif' alt='add record' align='top' width='34' height='15' border='0'>";
$DeleteRecord = "<input type='image' name='DeleteRecord' id='DeleteRecord' src='images/del.gif' alt='delete record' align='top' width='20' height='20' border='0'>";

function SQLSafe($InString) {
	$OutString = str_replace("'", "''",$InString);
	//$OutString = addslashes($InString);
	return $OutString;
}

function die_well($page="", $line="", $string="", $Detail="") {
	$fp=fopen("odbcerror.txt","a");
	$output = date('Y-m-d H:i:s')." | ".$page." | ".$line." | ".$_SERVER["REMOTE_ADDR"]." | ".$string." | ".$Detail."\r\n";
	fputs($fp,$output);
	fclose($fp);
	//exit("An unexpected error has occured, please call for support.\r\n Page: ".$page."\r\n Line:".$line);
}

function divby($val, $by) {
   if ($val < 0)
   $val += -$val % $by;
   else
   $val -= $val % $by;
  
   return $val;
}
?>