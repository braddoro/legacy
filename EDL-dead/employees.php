<?php 
$PageID = 53;
$ini_array = parse_ini_file("incl/edl.ini"); 
include "header.php";
header("Cache: private");

$EmployeeID=0;
if (isset($_REQUEST["EmployeeID"])) {
	$EmployeeID = $_REQUEST["EmployeeID"];
}

if (isset($_POST["EmployeeID"])) {
	$EmployeeID = $_POST["EmployeeID"];
}

if (isset($_POST["DeleteAddress_x"])) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql = "usp_Delete_EmployeeAddress ".$_POST["EmployeeAddressID"];
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	odbc_close($conn);
}
if (isset($_POST["DeleteNumber_x"])) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql = "usp_Delete_EmployeeNumber ".$_POST["EmployeeNumberID"];
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	odbc_close($conn);
}
if (isset($_POST["DeleteDate_x"])) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql = "usp_Delete_EmployeeDate ".$_POST["EmployeeDateID"];
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	odbc_close($conn);
}

if (isset($_POST["Submit"])) {
	if ($_POST["Submit"] == "Edit") {
		$sql = "usp_Update_Employee ".
		$EmployeeID.", ".
		$_POST["BranchID"].", ".
		$_POST["SexID"].", ".
		$_POST["JobTitleID"].", '".
		sqlsafe($_POST["SSN"])."', '".
		sqlsafe($_POST["CasualName"])."', '".
		sqlsafe($_POST["FirstName"])."', '".
		sqlsafe($_POST["MiddleName"])."', '".
		sqlsafe($_POST["LastName"])."', '".
		sqlsafe($_POST["UserName"])."', ".
		$_POST["Failures"].", '".
		$_POST["Active"]."', '".
		$_POST["PasswordReset"]."'";
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	}
	if ($_POST["Submit"] == "Add") {
		if ($_POST["Password"] == $_POST["Password2"]) {
			$sql = "usp_Insert_Employee ".
			$_POST["BranchID"].", ".
			$_POST["SexID"].", ".
			$_POST["JobTitleID"].", '".
			sqlsafe($_POST["SSN"])."', '".
			sqlsafe($_POST["CasualName"])."', '".
			sqlsafe($_POST["FirstName"])."', '".
			sqlsafe($_POST["MiddleName"])."', '".
			sqlsafe($_POST["LastName"])."', '".
			sqlsafe($_POST["UserName"])."', '".
			md5("salt".$_POST["Password"]).sha1($_POST["Password"]."salt")."'";
			$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
			$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
			while (odbc_fetch_row($rs)) {
				$EmployeeID = odbc_result($rs,"NewID");
			}
			odbc_close($conn);
		}
		
	}
	if ($_POST["Submit"] == "Add Address") {
		$sql = "usp_Insert_EmployeeAddresses ".
		$EmployeeID.", ".
		$_POST["AddressTypeID"].", ".
		$_POST["StreetTypeID"].", ".
		$_POST["UnitTypeID"].", '".
		sqlsafe($_POST["House"])."', '".
		$_POST["Direction"]."', '".
		sqlsafe($_POST["Street"])."', '".
		sqlsafe($_POST["Unit"])."', '".
		sqlsafe($_POST["City"])."', '".
		$_POST["State"]."', '".
		sqlsafe($_POST["Zip"])."'";
		$foo=$sql;
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
		odbc_close($conn);
	}
	
	if ($_POST["Submit"] == "Add Number") {
		if ($_POST["NumberTypeID"] > 0 and strlen($_POST["Number"]) > 0) {
			$sql = "usp_Insert_EmployeeNumber ".
			$EmployeeID.", ".
			$_POST["NumberTypeID"].", '".
			sqlsafe($_POST["Number"])."'";
			$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
			$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
			odbc_close($conn);
		}
	}
	if ($_POST["Submit"] == "Add Date") {
		if ($_POST["DateTypeID"] > 0) {
			$sql = "usp_Insert_EmployeeDate ".
			$EmployeeID.", ".
			$_POST["DateTypeID"].", '".
			sqlsafe($_POST["Date"])."'";
			$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
			$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
			odbc_close($conn);
		}
	}
}
echo $HEAD;
?>
<div class='main' id='main'>
<span class='title2'>Employees</span><br><br>
<?php
//echo print_r($_POST);
echo "<form action='employees.php' method='post' name='ListChoice' id='ListChoice'>";
$sql="usp_select_EmployeeList_all";
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "Choose an employee <select name='EmployeeID' id='EmployeeID' onChange='this.form.submit()'>";
echo "<option value='0'>Add New</option>";
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"EmployeeID")."'";
	if (isset($EmployeeID)) {
		if ($EmployeeID == odbc_result($rs,"EmployeeID")) {
			echo " SELECTED";
		}
	}
	echo ">".odbc_result($rs,"FullName")."</option>".$g_break;
}
echo "</select>";
odbc_close($conn);
echo "</form>".$g_break;
if ($EmployeeID > 0) {
	$sql="usp_select_Employee ".$EmployeeID;
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<form action='employees.php' method='post' name='editemployee' id='editemployee'>".$g_break;
	echo "<input type='hidden' name='EmployeeID' id='EmployeeID' value='".$EmployeeID."'>".$g_break;
	echo "<table class='table1'>".$g_break;
	while($row=odbc_fetch_array($rs)){
		echo "<tr>";
		echo "<td class='sideheader'>Branch</td>";
		echo "<td class='formright'>";
		$sql2="usp_select_Branches 'Y'";
		$rs2=odbc_exec($conn,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
		echo "<select name='BranchID' id='BranchID'>".$g_break;
		echo "<option value='0'></option>";
		while($row2=odbc_fetch_array($rs2)) {
			echo "<option value='".$row2['BranchID']."'";
			if ($row['BranchID_fk'] == $row2['BranchID']) {
				echo " SELECTED";
			}
			echo ">".$row2['Branch']."</option>".$g_break;
		}
		echo "</select>".$g_break;
		
		echo "</td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Job Description</td>";
		echo "<td class='formright'>";
		$sql2="usp_Select_JobDescriptions 'Y'";
		$conn2=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$rs2=odbc_exec($conn2,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
		echo "<select name='JobTitleID' id='JobTitleID'>".$g_break;
		echo "<option value='0'></option>";
		while($row2=odbc_fetch_array($rs2)) {
			echo "<option value='".$row2['JobDescriptionID']."'";
			if ($row['JobDescriptionID_fk'] == $row2['JobDescriptionID']) {
				echo " SELECTED";
			}
			echo ">".$row2['JobTitle']."</option>".$g_break;
		}
		echo "</select>".$g_break;
		
		echo "</td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>User Name</td>";
		echo "<td class='formright'><input type='text' name='UserName' id='UserName' value='".$row['UserName']."' size='30' maxlength='30'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Casual Name</td>";
		echo "<td class='formright'><input type='text' name='CasualName' id='CasualName' value='".$row['CasualName']."' size='10' maxlength='20'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>First Name</td>";
		echo "<td class='formright'><input type='text' name='FirstName' id='FirstName' value='".$row['FirstName']."' size='20' maxlength='20'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Middle Name</td>";
		echo "<td class='formright'><input type='text' name='MiddleName' id='MiddleName' value='".$row['MiddleName']."' size='10' maxlength='20'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Last Name</td>";
		echo "<td class='formright'><input type='text' name='LastName' id='LastName' value='".$row['LastName']."' size='20' maxlength='20'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>SSN</td>";
		echo "<td class='formright'><input type='text' name='SSN' id='SSN' value='".trim($row['SSN'])."' size='9' maxlength='9' onBlur='IsNumber(this.form.name, this.name, this.value)'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Sex</td>";
		echo "<td class='formright'>";
		echo "<select name='SexID' id='SexID'>";
		echo "<option value='0'></option>";
		echo "<option value='1'";
		if ($row['SexID_fk'] == 1) { echo " SELECTED"; }
		echo ">Male</option>";
		echo "<option value='2'";
		if ($row['SexID_fk'] == 2) { echo " SELECTED"; }
		echo ">Female</option>";
		echo "</select>";
		echo "</td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Reset Password</td>";
		echo "<td class='formright'>";
		
		echo "<input type='checkbox' name='PasswordReset' id='PasswordReset' value='Y'";
		if ($row['PasswordReset'] == 'Y') { echo " CHECKED"; }
		echo ">";
		
		echo "</td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Logon Attempts</td>";
		echo "<td class='formright'><input type='text' name='Failures' id='Failures' value='".$row['Failures']."' size='1' maxlength='1' onBlur='IsNumber(this.form.name, this.name, this.value)'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Active</td>";
		echo "<td class='formright'>";
		echo "<input type='checkbox' name='Active' id='Active' value='Y'";
		if ($row['Active'] == 'Y') { echo " CHECKED"; }
		echo ">";
		echo "</td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Last Logon</td>";
		echo "<td class='formright'>".$row['LastLogon']."</td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'></td>";
		echo "<td class='formright'><input type='submit' name='Submit' id='Submit' value='Edit'></td>";
		echo "</tr>".$g_break;
	}	
	echo "</table>";
	echo "</form>".$g_break;
	odbc_close($conn);
	
} else {
	echo "<form action='employees.php' method='post' name='addemployee' id='addemployee'>".$g_break;
	echo "<table class='table1'>".$g_break;
	echo "<tr>";
	echo "<td class='sideheader'>Branch</td>";
	echo "<td class='formright'>";
	$sql2="usp_select_Branches 'Y'";
	$rs2=odbc_exec($conn,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<select name='BranchID' id='BranchID'>".$g_break;
	echo "<option value='0'></option>";
	while($row2=odbc_fetch_array($rs2)) {
		echo "<option value='".$row2['BranchID']."'";
		if ($row['BranchID_fk'] == $row2['BranchID']) {
			echo " SELECTED";
		}
		echo ">".$row2['Branch']."</option>".$g_break;
	}
	echo "</select>".$g_break;
	
	echo "</td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Job Description</td>";
	echo "<td class='formright'>";
	$sql2="usp_Select_JobDescriptions 'Y'";
	$conn2=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs2=odbc_exec($conn2,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<select name='JobTitleID' id='JobTitleID'>".$g_break;
	echo "<option value='0'></option>";
	while($row2=odbc_fetch_array($rs2)) {
		echo "<option value='".$row2['JobDescriptionID']."'";
		if ($row['JobDescriptionID_fk'] == $row2['JobDescriptionID']) {
			echo " SELECTED";
		}
		echo ">".$row2['JobTitle']."</option>".$g_break;
	}
	echo "</select>".$g_break;
	
	echo "</td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>User Name</td>";
	echo "<td class='formright'><input type='text' name='UserName' id='UserName' value='' size='30' maxlength='30'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Casual Name</td>";
	echo "<td class='formright'><input type='text' name='CasualName' id='CasualName' value='' size='10' maxlength='20'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>First Name</td>";
	echo "<td class='formright'><input type='text' name='FirstName' id='FirstName' value='' size='20' maxlength='20'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Middle Name</td>";
	echo "<td class='formright'><input type='text' name='MiddleName' id='MiddleName' value='' size='10' maxlength='20'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Last Name</td>";
	echo "<td class='formright'><input type='text' name='LastName' id='LastName' value='' size='20' maxlength='20'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>SSN</td>";
	echo "<td class='formright'><input type='text' name='SSN' id='SSN' value='' size='9' maxlength='9' onBlur='IsNumber(this.form.name, this.name, this.value)'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Sex</td>";
	echo "<td class='formright'>";
	echo "<select name='SexID' id='SexID'>";
	echo "<option value='0'></option>";
	echo "<option value='1'";
	if ($row['SexID_fk'] == 1) { echo " SELECTED"; }
	echo ">Male</option>";
	echo "<option value='2'";
	if ($row['SexID_fk'] == 2) { echo " SELECTED"; }
	echo ">Female</option>";
	echo "</select>";
	echo "</td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Password</td>";
	echo "<td class='formright'><input type='text' name='Password' id='Password' value='' size='30' maxlength='30'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Password Again</td>";
	echo "<td class='formright'><input type='text' name='Password2' id='Password2' value='' size='30' maxlength='30'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'></td>";
	echo "<td class='formright'><input type='submit' name='Submit' id='Submit' value='Add'></td>";
	echo "</tr>".$g_break;
	echo "</table>";
	echo "</form>".$g_break;
}

if ($EmployeeID > 0) {
	//---------------------------------------------------------------------------------------------
	// Employee address display.
	//---------------------------------------------------------------------------------------------
	echo "<table class='table1'>".$g_break;
	echo "<tr class='header'>";
	echo "<td>Address Type</td>";
	echo "<td>Address</td>";
	echo "<td>Unit</td>";
	echo "<td>CSZ</td>";
	echo "<td></td>";
	echo "</tr>".$g_break;
	$sql="usp_Select_EmployeeAddresses ".$EmployeeID;
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	$rows=0;
	while($row=odbc_fetch_array($rs)){
		echo "<form action='Employees.php' method='post' name='Numbers' id='Numbers'>";
		echo "<input type='hidden' name='EmployeeID' id='EmployeeID' value='".$EmployeeID."'>".$g_break;
		echo "<input type='hidden' name='EmployeeAddressID' id='EmployeeAddressID' value='".$row['EmployeeAddressID']."'>".$g_break;
		if (fmod($rows, 2) == 0) {
			echo "<tr class='even'>".$g_break;
		} else {
			echo "<tr class='odd'>".$g_break;
		}
		echo "<td>".$row['AddressType']."</td>".$g_break;
		echo "<td>".$row['StreeNumber']." ".$row['StreetDirection']." ".$row['StreetName']." ".$row['StreetAbbr']."</td>".$g_break;
		echo "<td>".$row['UnitType']." ".$row['Unit']."</td>".$g_break;
		echo "<td>".$row['City']." ".$row['State']." ".$row['Zip']."</td>".$g_break;
		echo "<td>";
		echo "<input type='image' name='DeleteAddress' id='DeleteAddress' src='images/del.gif' alt='delete record' align='top' width='20' height='20' border='0'>";
		echo "</td>";
		echo "</tr>".$g_break;
		$rows++;
	}
	odbc_close($conn);
	echo "</table>".$g_break;
	echo "<br>".$g_break;
	
	//---------------------------------------------------------------------------------------------
	// Employee address entry.
	//---------------------------------------------------------------------------------------------
	echo "<form action='Employees.php' method='post' name='addaddress' id='addaddress'>";
	echo "<input type='hidden' name='EmployeeID' id='EmployeeID' value='".$EmployeeID."'>";
	echo "<table class='table1'>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Address Type</td>";
	echo "<td class='formright'>";
	$sql2="usp_select_AddressTypes";
	$rs2=odbc_exec($conn,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<select name='AddressTypeID' id='AddressTypeID'>".$g_break;
	echo "<option value='0'></option>";
	while($row2=odbc_fetch_array($rs2)) {
		echo "<option value='".$row2['AddressTypeID']."'>".$row2['AddressType']."</option>".$g_break;
	}
	echo "</select>";
	odbc_close($conn);
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='sideheader'>Street Number</td>";
	echo "<td class='formright'>";
	echo "<input type='text' name='House' id='House' value='' size='6' maxlength='6'>";
	echo "</td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td class='sideheader'>Direction</td>";
	echo "<td class='formright'>";
	$sql2="usp_select_Directions";
	$rs2=odbc_exec($conn,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<select name='Direction' id='Direction'>".$g_break;
	echo "<option value=''></option>";
	while($row2=odbc_fetch_array($rs2)) {
		echo "<option value='".$row2['Direction']."'>".$row2['Direction']."</option>".$g_break;
	}
	echo "</select>";
	odbc_close($conn);
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='sideheader'>Street</td>";
	echo "<td class='formright'>";
	echo "<input type='text' name='Street' id='Street' size='30' maxlength='30'>";
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='sideheader'>Street Type</td>";
	echo "<td class='formright'>";
	$sql2="usp_select_StreetTypes";
	$rs2=odbc_exec($conn,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<select name='StreetTypeID' id='StreetTypeID'>".$g_break;
	echo "<option value='0'></option>";
	while($row2=odbc_fetch_array($rs2)) {
		echo "<option value='".$row2['StreetTypeID']."'>".$row2['StreetType']."</option>".$g_break;
	}
	echo "</select>";
	odbc_close($conn);
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='sideheader'>Unit Type</td>";
	echo "<td class='formright'>";
	$sql2="usp_select_UnitTypes";
	$rs2=odbc_exec($conn,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<select name='UnitTypeID' id='UnitTypeID'>".$g_break;
	echo "<option value='0'></option>";
	while($row2=odbc_fetch_array($rs2)) {
		echo "<option value='".$row2['UnitTypeID']."'>".$row2['UnitType']."</option>".$g_break;
	}
	echo "</select>";
	odbc_close($conn);
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='sideheader'>Unit</td>";
	echo "<td class='formright'>";
	echo "<input type='text' name='Unit' id='Unit' size='6' maxlength='6'>";
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='sideheader'>City</td>";
	echo "<td class='formright'>";
	echo "<input type='text' name='City' id='City' size='30' maxlength='30'>";
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='sideheader'>State</td>";
	echo "<td class='formright'>";
	
	$sql2="usp_select_States";
	$rs2=odbc_exec($conn,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<select name='State' id='State'>".$g_break;
	echo "<option value=''></option>";
	while($row2=odbc_fetch_array($rs2)) {
		echo "<option value='".$row2['StateAbbr']."'>".$row2['State']."</option>".$g_break;
	}
	echo "</select>";
	odbc_close($conn);
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='sideheader'>Zip</td>";
	echo "<td class='formright'>";
	echo "<input type='text' name='Zip' id='Zip' size='5' maxlength='5'>";
	echo "</td>";
	echo "</tr>";
	
	echo "<tr>";
	echo "<td class='sideheader'></td>";
	echo "<td class='formright'><input type='submit' name='Submit' id='Submit' value='Add Address'>";
	echo "</td>";
	echo "</tr>".$g_break;
	echo "</table>";
	echo "</form>";
	echo "<br>";
	
	//---------------------------------------------------------------------------------------------
	// Employee numbers display.
	//---------------------------------------------------------------------------------------------
	$conn_numbers=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_EmployeeNumbers ".$EmployeeID;
	$numbers=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<table class='table1'>".$g_break;
	echo "<tr>";
	echo "<td class='header'>Number Type</td>";
	echo "<td class='header'>Number</td>";
	echo "<td class='header'></td>";
	echo "</tr>".$g_break;
	$rows=0;
	while($row=odbc_fetch_array($numbers)){
		echo "<form action='Employees.php' method='post' name='delnumber' id='delnumber'>";
		echo "<input type='hidden' name='EmployeeID' id='EmployeeID' value='".$EmployeeID."'>".$g_break;
		echo "<input type='hidden' name='EmployeeNumberID' id='EmployeeNumberID' value='".$row['EmployeeNumberID']."'>".$g_break;
		if (fmod($rows, 2) == 0) {
			echo "<tr class='even'>".$g_break;
		} else {
			echo "<tr class='odd'>".$g_break;
		}
		echo "<td>".$row['NumberType']."</td>";
		echo "<td>";
		switch ($row['NumberFormatID_fk']) {
		case 1:
		   echo substr($row['EmployeeNumber'],0,3).".".substr($row['EmployeeNumber'],3,3).".".substr($row['EmployeeNumber'],6,4);
		   break;
		case 2:
			echo "<a href='mailto:".$row['EmployeeNumber']."'>".$row['EmployeeNumber']."</a>";
		   break;
		case 3:
		   echo "<a href='".$row['EmployeeNumber']."'>".$row['EmployeeNumber']."</a>";
		   break;
		case 4:
		   echo $row['EmployeeNumber'];
		   break;
		default:
		   echo $row['EmployeeNumber'];
		}
		echo "</td>";
		echo "<td>";
		echo "<input type='image' name='DeleteNumber' id='DeleteNumber' src='images/del.gif' alt='delete record' align='top' width='20' height='20' border='0'>";
		echo "</td>";
		echo "</tr>".$g_break;
		echo "</form>";
		$rows++;
	}
	echo "</table>";
	odbc_close($conn);
	echo "<br>".$g_break;
	
	//---------------------------------------------------------------------------------------------
	// Employee numbers entry.
	//---------------------------------------------------------------------------------------------
	echo "<form action='Employees.php' method='post' name='addnumber' id='addnumber'>".$g_break;
	echo "<input type='hidden' name='EmployeeID' id='EmployeeID' value='".$EmployeeID."'>".$g_break;
	echo "<table class='table1'>".$g_break;
	echo "<tr>";
	echo "<td class='sideheader'>Number Type</td>";
	echo "<td class='formright'>";
	$sql2="usp_select_NumberTypes";
	$rs2=odbc_exec($conn,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<select name='NumberTypeID' id='NumberTypeID'>".$g_break;
	echo "<option value='0'></option>";
	while($row2=odbc_fetch_array($rs2)) {
		echo "<option value='".$row2['NumberTypeID']."'";
		if ($row['NumberTypeID'] == $row2['NumberTypeID']) {
			echo " SELECTED";
		}
		echo ">".$row2['NumberType']."</option>".$g_break;
	}
	odbc_close($conn);
	echo "</td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Number</td>";
	echo "<td class='formright'><input type='text' name='Number' id='Number' size='50' maxlength='50'></td>";
	echo "</tr>".$g_break;
	echo "<tr>";
	echo "<td class='sideheader'></td>";
	echo "<td class='formright'><input type='submit' name='Submit' id='Submit' value='Add Number'>";
	echo "</td>";
	echo "</tr>".$g_break;
	echo "</table>";
	echo "</form>".$g_break;
	
	//---------------------------------------------------------------------------------------------
	// Employee dates display.
	//---------------------------------------------------------------------------------------------
	$conn_numbers=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_EmployeeDates ".$EmployeeID;
	$numbers=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<table class='table1'>".$g_break;
	echo "<tr>";
	echo "<td class='header'>Date Type</td>";
	echo "<td class='header'>Date</td>";
	echo "<td class='header'></td>";
	echo "</tr>".$g_break;
	$rows=0;
	while($row=odbc_fetch_array($numbers)){
		echo "<form action='Employees.php' method='post' name='delnumber' id='delnumber'>";
		echo "<input type='hidden' name='EmployeeID' id='EmployeeID' value='".$EmployeeID."'>".$g_break;
		echo "<input type='hidden' name='EmployeeDateID' id='EmployeeDateID' value='".$row['EmployeeDateID']."'>".$g_break;
		if (fmod($rows, 2) == 0) {
			echo "<tr class='even'>".$g_break;
		} else {
			echo "<tr class='odd'>".$g_break;
		}
		echo "<td>".$row['DateType']."</td>";
		echo "<td>";
	   echo $row['EmployeeDate'];
		echo "&nbsp;<input type='image' name='DeleteDate' id='DeleteDate' src='images/del.gif' alt='delete record' align='top' width='20' height='20' border='0'>";
		echo "</td>";
		echo "</tr>".$g_break;
		echo "</form>";
		$rows++;
	}
	echo "</table>";
	odbc_close($conn);
	echo "<br>".$g_break;
	
	//---------------------------------------------------------------------------------------------
	// Employee dates entry.
	//---------------------------------------------------------------------------------------------
	echo "<form action='Employees.php' method='post' name='addDate' id='addDate'>".$g_break;
	echo "<input type='hidden' name='EmployeeID' id='EmployeeID' value='".$EmployeeID."'>".$g_break;
	echo "<table class='table1'>".$g_break;
	echo "<tr>";
	echo "<td class='sideheader'>Date Type</td>";
	echo "<td class='formright'>";
	$sql2="usp_select_DateTypes";
	$rs2=odbc_exec($conn,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
	echo "<select name='DateTypeID' id='DateTypeID'>".$g_break;
	echo "<option value='0'></option>";
	while($row2=odbc_fetch_array($rs2)) {
		echo "<option value='".$row2['DateTypeID']."'";
		if ($row['DateTypeID'] == $row2['DateTypeID']) {
			echo " SELECTED";
		}
		echo ">".$row2['DateType']."</option>".$g_break;
	}
	odbc_close($conn);
	echo "</td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Date</td>";
	echo "<td class='formright'><input type='text' name='Date' id='Date' size='10' maxlength='10'></td>";
	echo "</tr>".$g_break;
	echo "<tr>";
	echo "<td class='sideheader'></td>";
	echo "<td class='formright'><input type='submit' name='Submit' id='Submit' value='Add Date'>";
	echo "</td>";
	echo "</tr>".$g_break;
	echo "</table>";
	echo "</form>".$g_break;

}
?>
</div>
</body>
</html>