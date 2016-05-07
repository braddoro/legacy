<?php 
$ini_array = parse_ini_file("inc/support.ini"); 
include "_functions.php";
session_start();
header("Cache: private");

if (isset($_POST["submit"]) and isset($_SESSION["Password"])) {
	if ($_SESSION["Password"] == md5($_POST["Password"])) {
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$sql = "usp_update_IssueDescription ".$_POST["ID"].", '".sqlsafe($_POST["Edit"])."'";
		//echo $sql;
		$rs=odbc_exec($conn,$sql);
		odbc_close($conn);
	} else {
		$ErrorString = " Please supply the correct password";
	}
}

/*
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql = "usp_Select_IssueDescription ".$_REQUEST["ID"];
$rs=odbc_exec($conn,$sql);
while (odbc_fetch_row($rs)) {
	$IssueDescription = odbc_result($rs,"IssueDescription");
	$IssueID = odbc_result($rs,"IssueID");
	$_SESSION["Password"] = odbc_result($rs,"Password");
} 
odbc_close($conn); 
*/
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
<form action="editissue.php" method="post" name="edit" id="edit">
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
$sql="usp_Select_IssueDescription ".$_REQUEST["ID"];
$rs=odbc_exec($conn,$sql); 
while (odbc_fetch_row($rs)) {
	echo "<input type='hidden' name='ID' id='ID' value='".odbc_result($rs,"IssueID")."'>";
	echo "<td class='rows'><textarea cols='100' rows='20' name='Edit' id='Edit'>".stripslashes(odbc_result($rs,"IssueDescription"))."</textarea></td><br>";
	echo "Password <input type='password' name='Password' ID='Password' size=15>";
	$_SESSION["Password"] = odbc_result($rs,"Password");
	if (isset($ErrorString)) {
		echo "<span class='tinyred'>".$ErrorString."</span>"; 
	}
	echo "<br>";
} 
odbc_close($conn);
?>
<BR><input type="submit" name="submit" id="submit" value="submit">
</td>
</tr>
</table>
</form>
</div>
</body>
</html>