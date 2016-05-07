<?php 
error_log("Started", 3, "/incl/errors.txt");
$g_break = chr(10).chr(13);
$php_errormsg = "";

function SQLSafe($InString) {
	$OutString = str_replace("'", "''",$InString);
	//$OutString = addslashes($InString);
	return $OutString;
}

function die_well($page="", $line="", $string="", $Detail="") {
	$fp=fopen("incl/odbcerror.txt","a");
	$output = date('Y-m-d H:i:s')." | ".$page." | ".$line." | ".$_SERVER["REMOTE_ADDR"]." | ".$string." | ".$Detail."\r\n";
	fputs($fp,$output);
	fclose($fp);
	//exit("<br>An unexpected error has occured, please call for support.\r\n Page: ".$page."\r\n Line:".$line);
}
?>