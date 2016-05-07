<?php 
$ini_array = parse_ini_file("inc/support.ini"); 
include "_functions.php";
session_start();
header("Cache: private");

if (isset($_POST["submit"]) and isset($_POST["Password"])) {
	if ($_SESSION["Password"] == md5($_POST["Password"])) {	
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$sql = "usp_update_WorkDescription ".$_POST["WID"].", '".sqlsafe($_POST["Edit"])."', '".$_POST["StartDateTime"]."', '".$_POST["EndDateTime"]."'";
		//echo $sql;
		$rs=odbc_exec($conn,$sql);
		odbc_close($conn);
	} else {
		$ErrorString = " Please supply the correct password";
	}
}
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
<form action="editwork.php" method="post" name="edit" id="edit">
<tr>
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

$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_Select_WorkDescription ".$_REQUEST["WID"];
$rs=odbc_exec($conn,$sql); 
echo "<table class='table'>";
while (odbc_fetch_row($rs)) {
	echo "<tr>";
	echo "<input type='hidden' name='ID' id='ID' value='".$_REQUEST["ID"]."'>";
	echo "<input type='hidden' name='WID' id='WID' value='".odbc_result($rs,"WorkHistoryID")."'>";
	echo "<td class='header'>Start Date</td><td class='rows'><input name='StartDateTime' id='StartDateTime' value='".odbc_result($rs,"StartDateTime")."' size='20'></td>";
	echo "</tr>";

	echo "<tr>";
	echo "<td class='header'>End Date</td><td class='rows'><input name='EndDateTime' id='StartDateTime' value='".odbc_result($rs,"EndDateTime")."' size='20'></td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='header'>Description</td><td class='rows'><textarea cols='100' rows='20' name='Edit' id='Edit'>".stripslashes(odbc_result($rs,"WorkPerformed"))."</textarea></td>";
	echo "</tr>";
	
	$_SESSION["Password"] = odbc_result($rs,"Password");
	echo "<tr>";
	echo "<td class='header'>Password</td><td class='rows'><input type='password' name='Password' ID='Password' size=15>";
	if (isset($ErrorString)) {
		echo "<span class='tinyred'>".$ErrorString."</span>"; 
	}
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='header'></td><td class='rows'><input type='submit' name='submit' id='submit' value='submit'></td>";
	echo "</tr>";
}
echo "</table>";
odbc_close($conn);
?>
<BR>
</td>
</tr>
</table>
</form>
</div>
</body>
</html>