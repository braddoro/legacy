<?php 
/**************************************************************************************************
File......: logon.php
Purpose...: This is the logon page and is used to get user information from the database.
Change Log:
Date		Name			Modification
---------------------------------------------------------------------------------------------------
10/25/2005	Brad Hughes		Created.
**************************************************************************************************/
$PageID = 8;
$ini_array = parse_ini_file("incl/the.ini"); 
include "_functions.php";
session_start();
header("Cache: private");

// Default a few values
$_SESSION["LoggedIn"] = false;
$_SESSION["UserID"] = 4;
$_SESSION["PasswordReset"] = 'N';

if (isset($_POST["Submit"]) == "Submit") {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_UserAuth '".$_POST["UserName"]."', '".md5("salt".$_POST["Password"]).sha1($_POST["Password"]."salt")."', '".$_SERVER["REMOTE_ADDR"]."'";
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	while($row=odbc_fetch_array($rs)){
		$_SESSION["LoggedIn"] = true;
		$_SESSION["UserID"] = $row['UserID'];
		$_SESSION["UserName"] = $row['UserName'];
		$_SESSION["Password"] = $row['Password'];
		$_SESSION["FirstName"] = $row['FirstName'];
		$_SESSION["LastName"] = $row['LastName'];
		$_SESSION["EmailAddress"] = $row['EmailAddress'];
		$_SESSION["Signature"] = $row['Signature'];
		$_SESSION["Failures"] = $row['Failures'];
		$_SESSION["PasswordReset"] = $row['PasswordReset'];
		$_SESSION["LastLogon"] = $row['LastLogon'];
	}
	odbc_close($conn);
	
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]);
	$sql="usp_Insert_ObjectHistory ".$PageID.",".$_SESSION["UserID"].",'".$_SERVER['REMOTE_ADDR']."'";
	$Update=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	odbc_close($conn);
	
	// Build the list of permissions from the database.  This will be used by pagecheck.php to
	// see if this user has permiision to visit the page being loaded.
	$sql="usp_Select_UserPermissions ".$_SESSION["UserID"];
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	$Counter=1;
	while($row=odbc_fetch_array($rs)) {
		$_SESSION['Permissions'][$Counter] = $row['ObjectID'];
		$Counter++;
	}
	odbc_close($conn);
	
	// If the reset flag is on send the user to the reset password screen.
	if ($_SESSION["PasswordReset"] == "Y") {
		header("Location: stub.php");
	}
	
	// If the everything is cool then proceed.
	if ($_SESSION["LoggedIn"] == true and $_SESSION["PasswordReset"] <> "Y") {
		header("Location: news.php");
	}
}
?>
<html>
<head>
<link rel='stylesheet' href='<?php echo $ini_array["StyleSheet"];?>'>
<title></title>
</head>
<body class='body'>
<div class='main'>
<center><span class='title2'><?php echo $ini_array["SiteName"];?></span></center>
<form action="logon.php" method="post" name="formdata" id="formdata">
<span class="box">
<table class="table1" align="center">
<tr>
<td class="sideheader">User Name</td>
<td class="odd"><input type="text" name="UserName" id="UserName" size="20" maxlength="20"></td>
</tr>
<tr>
<td class="sideheader">Password</td>
<td class="odd"><input type="password" name="Password" id="Password" size="20" maxlength="20"></td>
</tr>
<tr>
<td class="sideheader"></td>
<td class="odd"><input type="submit" name="Submit" id="Submit" value="Submit"></td>
</tr>
</table>
</form>
</span>
</div>
</body>
</html>