<?php 
/**************************************************************************************************
File......: addnews.php
Purpose...: This page is used to add news.
Change Log:
Date		Name			Modification
---------------------------------------------------------------------------------------------------
10/29/2005	Brad Hughes		Created.
**************************************************************************************************/
$PageID = 15;
$ini_array = parse_ini_file("incl/the.ini"); 
session_start();
header("Cache: private");
include "_functions.php";
include "pagecheck.php";
include "heading.php";
include "footer.php";

if (isset($_POST["Submit"])) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql = "usp_insert_news ".$_SESSION["UserID"].", ".$_POST["TopicID"].", '".SQLSafe($_POST["Subject"])."', '".SQLSafe($_POST["News"])."'";
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	odbc_close($conn);
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<?php
echo "<link rel='stylesheet' href='".$ini_array["StyleSheet"]."'>";
echo "<title>".$ini_array["SiteName"]."</title>";
include "_javascript.php";
?>
</head>
<body class='body' id='body'>
<div class='main' id='main'>
<?php echo $Head; ?>
<span class='title2'>add news</span>
<?php
/*
echo "<form action='users.php' method='post' name='ListChoice' id='ListChoice'>";
$sql="usp_Select_UserList";
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "Choose a user <select name='UserID' id='UserID' onChange='this.form.submit()'>";
echo "<option value='0'></option>";
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"UserID")."'";
	if (isset($_POST["UserID"])) {
		if ($_POST["UserID"] == odbc_result($rs,"UserID")) {
			echo " SELECTED";
		}
	}
	echo ">".odbc_result($rs,"FullName")."</option>".$g_break;
}
echo "</select>";
odbc_close($conn);
echo "</form>".$g_break;
*/

//if (isset($_POST["UserID"])) {
	//$sql="usp_Select_Topics ".$_POST["UserID"];
	//$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<form action='addnews.php' method='post' name='add' id='add'>".$g_break;
	echo "<table class='table1'>".$g_break;
	//while($row=odbc_fetch_array($rs)){
		echo "<tr>";
		echo "<td class='sideheader'>Topic</td>";
		echo "<td class='even'>";
		$sql2="usp_Select_Topics";
		$rs2=odbc_exec($conn,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
		echo "<select name='TopicID' id='TopicID'>".$g_break;
		echo "<option value='0'></option>";
		while($row2=odbc_fetch_array($rs2)) {
			echo "<option value='".$row2['TopicID']."'";
			if ($row['TopicID'] == $row2['TopicID']) {
				echo " SELECTED";
			}
			echo ">".$row2['Topic']."</option>".$g_break;
		}
		echo "</select>".$g_break;
		
		echo "</td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Subject</td>";
		echo "<td class='even'><input type='text' name='Subject' id='Subject' value='' size='100' maxlength='200'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'></td>";
		echo "<td class='even'><textarea cols='80' rows='15' name='News' id='News'></textarea></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'></td>";
		echo "<td class='even'><input type='submit' name='Submit' id='Submit' value='Submit'></td>";
		echo "</tr>".$g_break;
	//}
	echo "</table>";
	echo "</form>".$g_break;
	//odbc_close($conn);
//}
?>
</div>
</body>
<?php echo $Foot; ?>
</html>