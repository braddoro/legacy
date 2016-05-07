<?php 
$ini_array = parse_ini_file("incl/edl.ini"); 
session_start();
header("Cache: private");
include "_functions.php";
include "pagecheck.php";
$HEAD = "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>".$g_break;
$HEAD .= "<html>".$g_break;
$HEAD .= "<link rel='stylesheet' href='".$ini_array["StyleSheet"]."'>".$g_break;
$HEAD .= "<head>".$g_break;
$HEAD .= "<title></title>".$g_break;
$HEAD .= "</head>".$g_break;
$HEAD .= "<body class='body' id='body'>".$g_break;
$HEAD .= "<div class='top'><span class='title1'>".$ini_array["SiteName"]."</span><br>";
$HEAD .= "<span class='onright'>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_Select_Objects 1";
$Links=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
while($row=odbc_fetch_array($Links)){
	$HEAD .= "<a class='toplinks1' href='".$row['PageName']."'>".$row['ObjectName']."</a>&nbsp;";
}
odbc_close($conn);
$HEAD .= "</span>";
$HEAD .= "</div>";
?>