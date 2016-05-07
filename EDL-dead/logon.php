<?php 
$ini_array = parse_ini_file("incl/edl.ini"); 
include "_functions.php";
session_start();
header("Cache: private");
$_SESSION["LoggedIn"] = false;
if (isset($_POST["Submit"]) == "Submit") {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_UserAuth '".$_POST["UserName"]."', '".$_POST["Password"]."', '".$_SERVER["REMOTE_ADDR"]."'";
	//$sql="usp_Select_UserAuth '".$_POST["UserName"]."', '".md5($_POST["Password"]."salt").sha1($_POST["Password"]."salt")."', '".$_SERVER["REMOTE_ADDR"]."'";
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	while($row=odbc_fetch_array($rs)){
		$_SESSION["LoggedIn"] = true;
		$_SESSION["EmployeeID"] = $row['EmployeeID'];
		$_SESSION["UserName"] = $row['UserName'];
		$_SESSION["JobDescriptionID"] = $row['JobDescriptionID_fk'];
		$_SESSION["CasualName"] = $row['CasualName'];
		$_SESSION["FirstName"] = $row['FirstName'];
		$_SESSION["MiddleName"] = $row['MiddleName'];
		$_SESSION["LastName"] = $row['LastName'];
		$_SESSION["LastLogon"] = $row['LastLogon'];
		$_SESSION["PasswordReset"] = $row['PasswordReset'];
		$_SESSION["BranchID"] = $row['BranchID_fk'];
	}
	odbc_close($conn);
}
if (isset($_SESSION["PasswordReset"])) {
	if ($_SESSION["PasswordReset"] == "Y") {
		//header("Location: reset.php");
	}
}

//and $_SESSION["PasswordReset"] <> "Y"
if ($_SESSION["LoggedIn"] == true) {
	header("Location: main.php");
	// or die_well(__FILE__, __LINE__,trigger_error());
}
//echo print_r($_POST);
//echo md5($_POST["Password"]."salt").sha1($_POST["Password"]."salt");
?>
<html>
<head>
<link rel='stylesheet' href='<?php echo $ini_array["StyleSheet"];?>'>
<title></title>
</head>
<body class='body'>
<div class='main'>
<center><span class='title2'><?php echo $ini_array["SiteAbbr"];?></span></center>
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