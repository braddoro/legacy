<?php 
$ini_array = parse_ini_file("inc/support.ini"); 
include "_functions.php";
session_start();
header("Cache: private");

if (isset($_POST["submit"]) and $_POST["UserID"] > 0 and isset($_POST["Password"])) {
	if ($_SESSION["Password"] == md5($_POST["Password"])) {
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$sql = "usp_insert_WorkHistory ".$_POST["ID"].", ".$_POST["UserID"].", 4, ".$_POST["StatusID"].", 22, '".$_POST["StartDate"]." ".$_POST["StartTime"]."', '".$_POST["EndDate"]." ".$_POST["EndTime"]."', '".SQLSafe($_POST["WorkPerformed"])."'";
		$rs=odbc_exec($conn,$sql);
		odbc_close($conn);
		header("Location:issue.php?ID=".$_POST["ID"], true);
	} else {
		$ErrorString = "Please supply the correct password";
	}
}

$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql = "usp_select_issueconditions ".$_REQUEST["ID"];
$rs=odbc_exec($conn,$sql);
while (odbc_fetch_row($rs)) {
	$Priority = odbc_result($rs,"PriorityID_fk");
	$Status = odbc_result($rs,"StatusID_fk");
	$IssueType = odbc_result($rs,"IssueTypeID_fk");
	$_SESSION["Password"] = odbc_result($rs,"Password");
	} 
odbc_close($conn);

$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql = "usp_Select_IssueDescription ".$_REQUEST["ID"];
$rs=odbc_exec($conn,$sql);
while (odbc_fetch_row($rs)) {
	$IssueDescription = stripslashes(nl2br(odbc_result($rs,"IssueDescription")));
	$IssueID = odbc_result($rs,"IssueID");
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


echo "<table class='table'>";
echo "<tr><td class='header'>Issue: ".$IssueID."</td></tr>";
echo "<tr><td class='rows'>".$IssueDescription."</td></tr>";
echo "</table>";
echo "<br>";
echo "<form action='addwork.php' method='post' name='add' id='add'>";
echo "<input type='hidden' name='ID' id='ID' value='".$_REQUEST["ID"]."'>";
echo "<table class='table'>";
echo "<tr><td class='header'>Work By</td>";
echo "<td class='rows'>";
echo "<select name='UserID' id='UserID'>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_Users";
$rs=odbc_exec($conn,$sql); 
echo "<option value='0'></option>";
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"UserID")."'>".odbc_result($rs,"Username")."</option>";
} 
odbc_close($conn); 
echo "</select>";

if (isset($_REQUEST["UserID"])) {
	if ($_REQUEST["UserID"] == 0) {
		echo " <span class='tinyred'>choose a user</span>";
	}
}

echo "</td></tr>";

echo "<tr><td class='header'>Priority</td>";
echo "<td class='rows'>";
echo "<select name='PriorityID' id='PriorityID'>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_Priorities";
$rs=odbc_exec($conn,$sql); 
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"PriorityID")."'";
	if ($Priority == odbc_result($rs,"PriorityID")) {echo "SELECTED";}
	echo ">".odbc_result($rs,"Priority")."</option>";
} 
odbc_close($conn); 
echo "</select>";
echo "</td></tr>";

echo "<tr><td class='header'>Severity</td>";
echo "<td class='rows'>";
echo "<select name='IssueTypeID' id='IssueTypeID'>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_IssueTypes";
$rs=odbc_exec($conn,$sql); 
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"IssueTypeID")."'";
	if ($IssueType == odbc_result($rs,"IssueTypeID")) {echo "SELECTED";}
	echo ">".odbc_result($rs,"IssueType")."</option>";
} 
odbc_close($conn); 
echo "</select>";
echo "</td></tr>";

echo "<tr><td class='header'>Status</td>";
echo "<td class='rows'>";
echo "<select name='StatusID' id='StatusID'>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_Statuses";
$rs=odbc_exec($conn,$sql); 
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"StatusID")."'";
	if ($Status == odbc_result($rs,"StatusID")) {echo "SELECTED";}
	echo ">".odbc_result($rs,"Status")."</option>";
} 
odbc_close($conn);
echo "</select>";
echo "</td></tr>";
?>
<tr>
<td class='header'>Work Start</td>
<td class='rows'>
date <input type="text" name="StartDate" id="StartDate" value="<?php echo date("m/d/y"); ?>" size="10">&nbsp;
time <input type="text" name="StartTime" id="StartTime" value="<?php echo date("g:i a"); ?>" size="10"></td>
</tr>

<tr>
<td class='header'>Work End</td>
<td class='rows'>
date <input type="text" name="EndDate" id="EndDate" value="<?php echo date("m/d/y"); ?>" size="10">&nbsp;
time <input type="text" name="EndTime" id="EndTime" value="<?php echo date("g:i a"); ?>" size="10">
</td>
</tr>

<tr>
<td class='header'>Work Performed</td>
<td class='rows'>
<textarea cols="80" rows="15" name="WorkPerformed" id="WorkPerformed"><?php if (isset($_REQUEST["WorkPerformed"])) {echo $_REQUEST["WorkPerformed"];} ?></textarea>
</td>
</tr>

<tr>
<td class='header'>Password</td>
<td class='rows'>
<input type='password' name='Password' ID='Password' size=15> <?php if (isset($ErrorString)) {echo "<span class='tinyred'>".$ErrorString."</span>"; } ?>
</td>
</tr>

<tr>
<td class='header'>&nbsp;</td>
<td class='rows'>
<input type="submit" name="submit" id="submit" value="submit">
</td>
</tr>

</table>
</form>
</div>
</body>
</html>