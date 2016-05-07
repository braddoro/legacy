<?php
/**************************************************************************************************
File......: pagecheck.php
Purpose...: This page provides security and should be used on every page to prohibit improper access.
Change Log:
Date		Name			Modification
---------------------------------------------------------------------------------------------------
10/13/2005	Brad Hughes		Created.
**************************************************************************************************/
if (!isset($_SESSION["UserID"])) {
	$_SESSION["UserID"] = 4;
}

if (!isset($_SESSION['Permissions'])) {
	// Build the list of permissions from the database.  This will be used to
	// see if this user has permision to visit the page currently being loaded.
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]);
	$sql="usp_Select_UserPermissions ".$_SESSION["UserID"];
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	$Counter=1;
	while($row=odbc_fetch_array($rs)) {
		$_SESSION['Permissions'][$Counter] = $row['ObjectID'];
		$Counter++;
	}
	odbc_close($conn);
}

if (!in_array($PageID, $_SESSION['Permissions'])) { 
	header("Location: logon.php");
}

$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]);
$sql="usp_Insert_ObjectHistory ".$PageID.",".$_SESSION["UserID"].",'".$_SERVER['REMOTE_ADDR']."'";
$Update=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
odbc_close($conn);
?>