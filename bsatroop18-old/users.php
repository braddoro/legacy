<?php 
/**************************************************************************************************
File......: news.php
Purpose...: This file page displays the more recent news and serves as starting point for news.
Change Log:
Date		Name			Modification
---------------------------------------------------------------------------------------------------
10/13/2005	Brad Hughes		Created.
**************************************************************************************************/
$PageID = 13;
$ini_array = parse_ini_file("incl/the.ini"); 
session_start();
header("Cache: private");
include "_functions.php";
include "pagecheck.php";
include "heading.php";
include "footer.php";

$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
if (isset($_POST["Submit"])) {
	$sql = "usp_Update_User ".$_POST["UserID"].", '".$_POST["UserName"]."', '".$_POST["FirstName"]."', '".$_POST["LastName"]."', '".$_POST["Signature"]."', '".$_POST["EmailAddress"]."', ".$_POST["Failures"].", '".$_POST["PasswordReset"]."', '".$_POST["Active"]."'";
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
<span class='title2'>users</span>
<?php
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

if (isset($_POST["UserID"])) {
	$sql="usp_Select_User ".$_POST["UserID"];
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<form action='Users.php' method='post' name='edit' id='edit'>".$g_break;
	echo "<input type='hidden' name='UserID' id='UserID' value='".$_POST["UserID"]."'>".$g_break;
	echo "<table class='table1'>".$g_break;
	while($row=odbc_fetch_array($rs)){
		echo "<tr>";
		echo "<td class='sideheader'>User Name</td>";
		echo "<td class='even'><input type='text' name='UserName' id='UserName' value='".$row['UserName']."' size='30' maxlength='30'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>First Name</td>";
		echo "<td class='even'><input type='text' name='FirstName' id='FirstName' value='".$row['FirstName']."' size='20' maxlength='20'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Last Name</td>";
		echo "<td class='even'><input type='text' name='LastName' id='LastName' value='".$row['LastName']."' size='20' maxlength='20'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Signature</td>";
		echo "<td class='even'><input type='text' name='Signature' id='Signature' value='".$row['Signature']."' size='100' maxlength='100'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Email Address</td>";
		echo "<td class='even'><input type='text' name='EmailAddress' id='EmailAddress' value='".$row['EmailAddress']."' size='50' maxlength='50'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Reset Password</td>";
		echo "<td class='even'>";
		
		echo "<input type='checkbox' name='PasswordReset' id='PasswordReset' value='Y'";
		if ($row['PasswordReset'] == 'Y') { echo " CHECKED"; }
		echo ">";
		
		echo "</td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Failed Logon Attempts</td>";
		echo "<td class='even'><input type='text' name='Failures' id='Failures' value='".$row['Failures']."' size='1' maxlength='1' onBlur='IsNumber(this.form.name, this.name, this.value)'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Active</td>";
		echo "<td class='even'>";
		echo "<input type='checkbox' name='Active' id='Active' value='Y'";
		if ($row['Active'] == 'Y') { echo " CHECKED"; }
		echo ">";
		echo "</td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Last Logon</td>";
		echo "<td class='even'>".$row['LastLogon']."</td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Added Date</td>";
		echo "<td class='even'>".$row['AddedDate']."</td>";
		echo "</tr>".$g_break;

		echo "<tr>";
		echo "<td class='sideheader'></td>";
		echo "<td class='even'><input type='submit' name='Submit' id='Submit' value='Submit'></td>";
		echo "</tr>".$g_break;
	}
	echo "</table>";
	echo "</form>".$g_break;
	odbc_close($conn);
}
?>
</div>
</body>
<?php echo $Foot; ?>
</html>