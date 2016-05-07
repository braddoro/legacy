<?php 
$ini_array = parse_ini_file("inc/support.ini"); 
include "_functions.php";
session_start();
header("Cache: private");

if (isset($_POST["submit"])) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql = "usp_insert_Issue ".$_POST["ClientID"].", 4, ".$_POST["StatusID"].", 22, '".SQLsafe($_POST["IssueDescription"])."'";
	$rs=odbc_exec($conn,$sql);
	odbc_close($conn);
	header("Location:default.php", true);
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
<?php
echo "<form action='addissue.php' method='post' name='add' id='add'>";
echo "<table class='table'>";
echo "<tr><td class='header'>Project</td>";
echo "<td class='rows'>";
echo "<select name='ClientID' id='ClientID'>";
echo "<option value='0'></option>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_Clients";
$rs=odbc_exec($conn,$sql); 
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"ClientID")."'>".odbc_result($rs,"ClientName")."</option>";
} 
odbc_close($conn); 
echo "</select>";
echo "</td></tr>";
/*
echo "<tr><td class='header'>Priority</td>";
echo "<td class='rows'>";
echo "<select name='PriorityID' id='PriorityID'>";
echo "<option value='0'></option>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_Priorities";
$rs=odbc_exec($conn,$sql); 
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"PriorityID")."'>".odbc_result($rs,"Priority")."</option>";
} 
odbc_close($conn); 
echo "</select>";
echo "</td></tr>";
*/

echo "<tr><td class='header'>Status</td>";
echo "<td class='rows'>";
echo "<select name='StatusID' id='StatusID'>";
echo "<option value='0'></option>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_Statuses";
$rs=odbc_exec($conn,$sql); 
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"StatusID")."'>".odbc_result($rs,"Status")."</option>";
} 
odbc_close($conn); 
echo "</select>";
echo "</td></tr>";
/*
echo "<tr><td class='header'>Severity</td>";
echo "<td class='rows'>";
echo "<select name='IssueTypeID' id='IssueTypeID'>";
echo "<option value='0'></option>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_IssueTypes";
$rs=odbc_exec($conn,$sql); 
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"IssueTypeID")."'>".odbc_result($rs,"IssueType")."</option>";
} 
odbc_close($conn); 
echo "</select>";
echo "</td></tr>";
*/
?>

<tr>
<td class='header'>Issue Description</td>
<td class='rows'>
<textarea cols="80" rows="15" name="IssueDescription" id="IssueDescription"></textarea>
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