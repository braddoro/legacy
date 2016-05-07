<?php 
$ini_array = parse_ini_file("inc/support.ini"); 
include "_functions.php";
session_start();
header("Cache: private");

$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql = "usp_Select_IssueDescription ".$_REQUEST["ID"];
$rs=odbc_exec($conn,$sql);
while (odbc_fetch_row($rs)) {
	$IssueID = odbc_result($rs,"IssueID");
	$IssueDescription = odbc_result($rs,"IssueDescription");
	$_SESSION["Password"] = odbc_result($rs,"Password");
}
odbc_close($conn); 

?>
<html>
<link rel='stylesheet' href='<?php echo $ini_array["StyleSheet"];?>'>
<head>
<title><?php echo $ini_array["SiteName"];?></title>
</head>
<body class="body" id="body1">
<div class="topbox" id="topbox1">
<span class="titleA" id="titleA1"><?php echo $ini_array["SiteName"];?></span>
<?php include "menu.php";?>
</div>
<div class="mainbox" id="mainbox1">
<?php


$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql = "usp_Select_CheckPass '".$_SESSION["ClientID"]."', '".$_SESSION["Password"]."'";
$rs=odbc_exec($conn,$sql);
$Found = 0;
while (odbc_fetch_row($rs)) { 
	$Found = odbc_result($rs,"Found");
} 
odbc_close($conn); 

if ($Found == 0) {
	exit("Incorrect Password");
}


echo "<table class='table' id='table3'>";
echo "<tr><td class='header'>Issue: ".$IssueID."</td></tr>";
echo "<tr><td class='rows'><a href='editissue.php?ID=".$IssueID."'>".stripslashes(nl2br($IssueDescription))."</a></td></tr>";
echo "</table>";
echo "<br>";

$SumMinutes = 0;
$SumCost = 0;
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_Issue ".$_REQUEST["ID"];
//echo $sql;
$rs=odbc_exec($conn,$sql); 
echo "<table class='table' id='table2'>";
echo "<tr>";
echo "<td class='header'>Age</td>";
//echo "<td class='header'>Priority</td>";
echo "<td class='header'>Status</td>";
//echo "<td class='header'>Severity</td>";
echo "<td class='header'>Work By</td>";
echo "<td class='header'>Minutes</td>";
echo "<td class='header'>Cost</td>";
//echo "<td class='header'>Work Start</td>";
//echo "<td class='header'>Work End</td>";
echo "<td class='header'>Work Performed</td>";
echo "</tr>";
$row = 1;
while (odbc_fetch_row($rs)) {
	$retval = fmod($row, 2);
	if ($retval == 0) {
		$class = 'odd';
	} else {
		$class = 'even';
	}
	echo "<tr class='".$class."'>";
	echo "<td valign='top'>".age(odbc_result($rs,"Age"))."</td>";
	//echo "<td valign='top'>".odbc_result($rs,"Priority")."</td>";
	echo "<td valign='top'>".odbc_result($rs,"Priority")."<br>".odbc_result($rs,"Status")."<br>".odbc_result($rs,"IssueType")."</td>";
	//echo "<td valign='top'>".odbc_result($rs,"IssueType")."</td>";
	echo "<td valign='top'>".odbc_result($rs,"WorkBy")."</td>";
	echo "<td valign='top'>".odbc_result($rs,"Minutes")."</td>";
	echo "<td valign='top'>$".number_format(odbc_result($rs,"Cost"),2)."</td>";
	//echo "<td valign='top'>".odbc_result($rs,"StartDateTime")."</td>";
	//echo "<td valign='top'>".odbc_result($rs,"EndDateTime")."</td>";
	echo "<td valign='top'><a href='editwork.php?ID=".$_REQUEST["ID"]."&WID=".odbc_result($rs,"WorkHistoryID")."'>".nl2br(stripslashes(odbc_result($rs,"WorkPerformed")))."</a></td>";
	echo "</tr>";
	$row++;
	$SumMinutes += odbc_result($rs,"Minutes");
	$SumCost += odbc_result($rs,"Cost");
} 
echo "<tr class='header'>";
//echo "<td valign='top'></td>";
//echo "<td valign='top'></td>";
echo "<td valign='top'></td>";
echo "<td valign='top'></td>";
echo "<td valign='top'>Total</td>";
echo "<td valign='top'>".age($SumMinutes)."</td>";
echo "<td valign='top'>$".number_format($SumCost,2)."</td>";
//echo "<td valign='top'></td>";
//echo "<td valign='top'></td>";
echo "<td valign='top'></td>";
echo "</tr>";
echo "</table>";
odbc_close($conn); 
?>
</div>
</body>
</html>