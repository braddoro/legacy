<?php
if (!isset($_SESSION["EmployeeID"])) {
	header("Location: logon.php");
}
if (!isset($_SESSION['Permissions'])) {
	// Build the list of permissions from the database.  This will be used to
	// see if this user has permision to visit the page currently being loaded.
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]);
	$sql="usp_select_ObjectPermissions ".$_SESSION["EmployeeID"];
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

/*
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]);
$sql="usp_Insert_ObjectHistory ".$PageID.",".$_SESSION["EmployeeID"].",'".$_SERVER['REMOTE_ADDR']."'";
$Update=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
odbc_close($conn);
*/
?>