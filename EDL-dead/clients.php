<?php 
$PageID = 48;
$ini_array = parse_ini_file("incl/edl.ini"); 
include "header.php";
header("Cache: private");
echo $HEAD;

if (isset($_REQUEST["ClientID"])) {
	$ClientID = $_REQUEST["ClientID"];
}

if (isset($_POST["ClientID"])) {
	$ClientID = $_POST["ClientID"];
}

if (isset($_POST["AddRecord_x"])) {
	$sql = "usp_Insert_ClientBlank";
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	while($row=odbc_fetch_array($rs)){
		$ClientID = $row['NewID'];
	}
	odbc_close($conn);
}
if (isset($_POST["DeleteAddress_x"])) {
	$sql = "usp_Delete_ClientAddress ".$_POST["ClientAddressID"];
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	odbc_close($conn);
}
if (isset($_POST["DeleteNumber_x"])) {
	$sql = "usp_Delete_ClientNumber ".$_POST["ClientNumberID"];
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	odbc_close($conn);
}

if (isset($_POST["Add"])) {
	if ($_POST["NumberTypeID"] > 0 and strlen($_POST["Number"]) > 0) {
		$sql = "usp_Insert_ClientNumber ".$ClientID.", ".$_POST["NumberTypeID"].", '".$_POST["Number"]."'";
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
		odbc_close($conn);
	}
}

if (isset($_POST["Submit"])) {
	if ($_POST["Submit"] == "Edit") {
		$ClientID = $_POST["ClientID"];
		$sql = "usp_Update_Client ".
		$_POST["ClientID"].", ".
		$_POST["SexID"].", '".
		$_POST["CompanyName"]."', '".
		$_POST["FirstName"]."', '".
		$_POST["MiddleName"]."', '".
		$_POST["LastName"]."', '".
		$_POST["Title"]."', '".
		$_POST["Active"]."'";
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
		odbc_close($conn);
	}
	if ($_POST["Submit"] == "Add Address") {
		$sql = "usp_Insert_ClientAddresses ".
		$_POST["ClientID"].", ".
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
			$sql = "usp_Insert_ClientNumber ".
			$ClientID.", ".
			$_POST["NumberTypeID"].", '".
			sqlsafe($_POST["Number"])."'";
			$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
			$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
			odbc_close($conn);
		}
	}
}
?>
<div class='main' id='main'>
<span class='title2'>Clients</span>
<?php
/*
echo "<br>";
echo print_r($_POST);
echo "<br>";
echo print_r($_REQUEST);
echo "<br>";
*/
echo "<form action='clients.php' method='post' name='List' id='List'>";
$sql="usp_Select_ClientList_All";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "Choose a client <select name='ClientID' id='ClientID' onChange='this.form.submit()'>";
echo "<option value='0'></option>";
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"ClientID")."'";
	if (isset($ClientID)) {
		if ($ClientID == odbc_result($rs,"ClientID")) {
			echo " SELECTED";
		}
	}
	echo ">".odbc_result($rs,"CompanyName")."</option>".$g_break;
}
echo "</select>";
echo $AddNewRecord;
odbc_close($conn);
echo "</form>".$g_break;
if (isset($ClientID)) {
	//---------------------------------------------------------------------------------------------
	// Client display.
	//---------------------------------------------------------------------------------------------
	$sql="usp_select_Client ".$ClientID;
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__, odbc_errormsg());
	
	echo "<form action='clients.php' method='post' name='update' id='update'>".$g_break;
	echo "<input type='hidden' name='ClientID' id='ClientID' value='".$ClientID."'>".$g_break;
	echo "<table class='table1'>".$g_break;
	while($row=odbc_fetch_array($rs)){
		echo "<tr>";
		echo "<td class='sideheader'>Company Name</td>";
		echo "<td class='formright'><input type='text' name='CompanyName' id='CompanyName' value='".$row['CompanyName']."' size='80' maxlength='200'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>First Name</td>";
		echo "<td class='formright'><input type='text' name='FirstName' id='FirstName' value='".$row['FirstName']."' size='20' maxlength='20'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Middle Name</td>";
		echo "<td class='formright'><input type='text' name='MiddleName' id='MiddleName' value='".$row['MiddleName']."' size='20' maxlength='20'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Last Name</td>";
		echo "<td class='formright'><input type='text' name='LastName' id='LastName' value='".$row['LastName']."' size='20' maxlength='20'></td>";
		echo "</tr>".$g_break;
		
		echo "<td class='sideheader'>Title</td>";
		echo "<td class='formright'><input type='text' name='Title' id='Title' value='".$row['Title']."' size='75' maxlength='100'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Sex</td>";
		echo "<td class='formright'>";
		echo "<select name='SexID' id='SexID'>";
		echo "<option value='0'></option>".$g_break;
		echo "<option value='1'";
		if ($row['SexID_fk'] == 1) { echo " SELECTED"; }
		echo ">Male</option>".$g_break;
		echo "<option value='2'";
		if ($row['SexID_fk'] == 2) { echo " SELECTED"; }
		echo ">Female</option>".$g_break;
		echo "</select>";
		echo "</td>";
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
		echo "<td class='sideheader'></td>";
		echo "<td class='formright'><input type='submit' name='Submit' id='Submit' value='Edit'>";
		echo "<div align='center'>";
		echo "<a href='jobsites.php?ClientID=".$row['ClientID']."'>Job Sites</a>&nbsp;";
		echo "</div>";
		echo "</td>";
		echo "</tr>".$g_break;
	}
	echo "</table>";
	echo "</form>".$g_break;
	odbc_close($conn);
	
	//---------------------------------------------------------------------------------------------
	// Client address display.
	//---------------------------------------------------------------------------------------------
	echo "<table class='table1'>".$g_break;
	echo "<tr class='header'>";
	echo "<td>Address Type</td>";
	echo "<td>Address</td>";
	echo "<td>Unit</td>";
	echo "<td>CSZ</td>";
	echo "<td></td>";
	echo "</tr>".$g_break;
	$sql="usp_Select_ClientAddresses ".$ClientID;
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	$rows=0;
	while($row=odbc_fetch_array($rs)){
		echo "<form action='Clients.php' method='post' name='Numbers' id='Numbers'>";
		echo "<input type='hidden' name='ClientID' id='ClientID' value='".$ClientID."'>".$g_break;
		echo "<input type='hidden' name='ClientAddressID' id='ClientAddressID' value='".$row['ClientAddressID']."'>".$g_break;
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
	// Client address entry.
	//---------------------------------------------------------------------------------------------
	echo "<form action='Clients.php' method='post' name='addaddress' id='addaddress'>";
	echo "<input type='hidden' name='ClientID' id='ClientID' value='".$ClientID."'>";
	echo "<table class='table1'>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Address Type</td>";
	echo "<td class='formright'>";
	$sql2="usp_select_AddressTypes";
	$conn2=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs2=odbc_exec($conn2,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
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
	$conn2=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
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
	$conn2=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
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
	$conn2=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
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
	$conn2=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
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
	echo "<br>".$g_break;
	
	//---------------------------------------------------------------------------------------------
	// Client numbers display.
	//---------------------------------------------------------------------------------------------
	$sql="usp_Select_ClientNumbers ".$ClientID;
	$conn_numbers=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$numbers=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__, odbc_errormsg());
	//ClientID_fk ClientNumberID 
	echo "<table class='table1'>".$g_break;
	echo "<tr>";
	echo "<td class='header'>Number Type</td>";
	echo "<td class='header'>Number</td>";
	echo "<td class='header'>Added</td>";
	echo "<td class='header'></td>";
	echo "</tr>".$g_break;
	$rows=0;
	while($row=odbc_fetch_array($numbers)){
		echo "<form action='clients.php' method='post' name='delnumber' id='delnumber'>";
		echo "<input type='hidden' name='ClientID' id='ClientID' value='".$ClientID."'>".$g_break;
		echo "<input type='hidden' name='ClientNumberID' id='ClientNumberID' value='".$row['ClientNumberID']."'>".$g_break;
		if (fmod($rows, 2) == 0) {
			echo "<tr class='even'>".$g_break;
		} else {
			echo "<tr class='odd'>".$g_break;
		}
		echo "<td>".$row['NumberType']."</td>";
		echo "<td>";
		switch ($row['NumberFormatID_fk']) {
		case 1:
		   echo substr($row['ClientNumber'],0,3).".".substr($row['ClientNumber'],3,3).".".substr($row['ClientNumber'],6,4);
		   break;
		case 2:
			echo "<a href='mailto:".$row['ClientNumber']."'>".$row['ClientNumber']."</a>";
		   break;
		case 3:
		   echo "<a href='".$row['ClientNumber']."'>".$row['ClientNumber']."</a>";
		   break;
		case 4:
		   echo $row['ClientNumber'];
		   break;
		default:
		   echo $row['ClientNumber'];
		}
		echo "</td>";
		echo "<td>".$row['AddedDate']."</td>";
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
	// Client numbers display.
	//---------------------------------------------------------------------------------------------
	echo "<form action='clients.php' method='post' name='addnumber' id='addnumber'>".$g_break;
	echo "<input type='hidden' name='ClientID' id='ClientID' value='".$ClientID."'>".$g_break;
	echo "<table class='table1'>".$g_break;
	echo "<tr>";
	echo "<td class='sideheader'>Number Type</td>";
	echo "<td class='formright'>";
	$sql2="usp_select_NumberTypes";
	$conn2=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs2=odbc_exec($conn2,$sql2) or die_well(__FILE__, __LINE__, odbc_errormsg());
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
}
?>
</div>
</body>
</html>