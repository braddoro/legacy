<?php 
$ini_array = parse_ini_file("inc/support.ini"); 
include "_functions.php";
session_start();
header("Cache: private");
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

if (isset($_REQUEST["ClientID"])) {
	$_SESSION["ClientID"] = $_REQUEST["ClientID"];
} else {
	if (!isset($_SESSION["ClientID"])) {
		$_SESSION["ClientID"] = 0;
	}
}

if (isset($_REQUEST["Password"])) {
	$_SESSION["Password"] = md5($_REQUEST["Password"]);
} else {
	if (!isset($_SESSION["Password"])) {
		$_SESSION["Password"] = "";
	}
}

echo "<form action='default.php' method='post' name='add' id='add'>";
echo "<table class='table'>";
echo "<tr><td class='header'>Project</td>";
echo "<td class='rows'>";
echo "<select name='ClientID' id='ClientID'>";
echo "<option value='0'></option>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_Clients";
$rs=odbc_exec($conn,$sql); 
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"ClientID")."'";
	if (odbc_result($rs,"ClientID") == $_SESSION["ClientID"]) {
		echo " SELECTED";
	}
	echo ">".odbc_result($rs,"ClientName")."</option>";
}
odbc_close($conn); 
echo "</select>";
echo "</td>";
echo "<td class='rows'>";
echo "<input type='password' name='Password' id='Password' value='".$_SESSION["Password"]."' size='10'>";
echo "</td>";
echo "<td class='rows'>";
echo "<input type='submit' name='submit' id='submit' value='submit'>";
echo "</td>";
echo "</tr>";
echo "</table>";
echo "</form>";

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

/*
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql = "usp_Select_StatusSummary";
$rs=odbc_exec($conn,$sql);
echo "<table class='table' id='table0'>";
echo "<tr>";
echo "<td class='header'>Status</td>";
echo "<td class='header'>Issues</td>";
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
	echo "<td>".odbc_result($rs,"Status")."</td>";
	echo "<td>".odbc_result($rs,"Issues")."</td>";
	echo "</tr>";
	$row++;
} 
echo "</table>";
odbc_close($conn); 
echo "<br>";
*/

$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 

if (isset($_REQUEST["s"])) {
	$Sort = $_REQUEST["s"];
} else {
	$Sort = 4;
}

if ($Sort == 1) {
	$sql="usp_select_OpenJobsBySeverity ".$_SESSION["ClientID"];
}
if ($Sort == 2) {
	$sql="usp_select_OpenJobsByPriority ".$_SESSION["ClientID"];
}

if ($Sort == 3) {
	$sql="usp_select_OpenJobsByAge ".$_SESSION["ClientID"];
}

if ($Sort == 4) {
	$sql="usp_select_OpenJobsByStatus ".$_SESSION["ClientID"];
}

if ($Sort == 5) {
	$sql="usp_select_OpenJobsByTimeSpent ".$_SESSION["ClientID"];
}

if (strlen($sql) == 0) {
	$sql="usp_select_OpenJobsByStatus ".$_SESSION["ClientID"];
}

$TotalTime=0;
$rs=odbc_exec($conn,$sql); 
echo "<table class='table' id='table1'>";
echo "<tr>";
echo "<td class='header'><a href='default.php?s=3'>Age</a></td>";
//echo "<td class='header'><a href='default.php?s=2'>Priority</a></td>";
//echo "<td class='header'><a href='default.php?s=1'>Severity</a></td>";
echo "<td class='header'><a href='default.php?s=4'>Status</a></td>";
echo "<td class='header'><a href='default.php?s=5'>Time</a></td>";
echo "<td class='header'>Notes</td>";
echo "<td class='header'>Issue Description</td>";
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
	//echo "<td valign='top'>".odbc_result($rs,"IssueType")."</td>";
	echo "<td valign='top'>".odbc_result($rs,"Status")."</td>";
	echo "<td align='center' valign='top'>".age(odbc_result($rs,"TotalMinutes"))."</td>";
	echo "<td align='center' valign='top'>".odbc_result($rs,"Notes")."</td>";
	echo "<td valign='top'><a href='issue.php?ID=".odbc_result($rs,"IssueID")."'>".stripslashes(nl2br(odbc_result($rs,"IssueDescription")))."</a></td>";
	echo "</tr>";
	$row++;
	$TotalTime+=odbc_result($rs,"TotalMinutes");
} 
$retval = fmod($row, 2);
if ($retval == 0) {
	$class = 'odd';
} else {
	$class = 'even';
}
echo "<tr class='".$class."'>";
echo "<td></td>";
//echo "<td></td>";
//echo "<td></td>";
echo "<td></td>";
echo "<td><b>".$TotalTime."</b></td>";
echo "<td></td>";
echo "<td></td>";
echo "</tr>";
echo "</table>";
echo "<span class='tiny'>Total: ".odbc_num_rows($rs)."</span>";
odbc_close($conn); 
?>
</div>
</body>
</html>