<?php 
$PageID = 50;
$ini_array = parse_ini_file("incl/edl.ini");
include "header.php";
header("Cache: private");
$ContractID=0;
if (isset($_REQUEST["CID"])) {
	$ContractID = $_REQUEST["CID"];
}
if (isset($_POST["ContractID"])) {
	$ContractID = $_POST["ContractID"];
}
if (isset($_POST['Submit'])) {
	if ($_POST['Submit'] == "Save") {
		// insert the service item.
		$sql="usp_Insert_ContractService ".$ContractID.", ";
		$sql .= $_POST["TravelTime"].", ";
		if (isset($_POST["WorkDate"]) and isset($_POST["TimeIn"])) {
			$sql .= "'".$_POST["WorkDate"]." ".$_POST["TimeIn"]."', ";
		} else {
			$sql .= "'".date("j/n/Y")."', ";
		}
		if (isset($_POST["Complete"])) {
			$sql .= "'Y'";
		} else {
			$sql .= "'N'";
		}
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
		// get the return values.
		while (odbc_fetch_row($rs)) {
			$ContractID = odbc_result($rs,"ContractID");
			$ContractDetailID = odbc_result($rs,"ContractDetailID");
		}
		odbc_close($conn);
		
		// insert the employees.
		if (isset($ContractDetailID) && isset($_POST['EmployeeList'])) {
			foreach ($_POST['EmployeeList'] as &$value) {
				$sql="usp_Insert_ContractServiceEmployee ".$ContractDetailID.", ".$value;
				$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
				$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
				odbc_close($conn);
			}
		}
		// insert the work items.
		if (isset($ContractDetailID)) {
			foreach($_POST as $varName => $value) {
				if (substr($varName,0,4) == "MID_") {
					if (strlen($value) > 0) {
						$ID = substr($varName,4,strlen($varName));
						$sql="usp_Insert_ContractServiceItem ".$ContractDetailID.", ".$ID.", ".$value;
						$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
						$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
						odbc_close($conn);
					}
				}
			}
		}
	}
}
echo $HEAD;
?>
<div class='main' id='main'>
<span class='title2'>Contract Service</span><br><br>
<?php
echo "<form action='contractservice.php' method='post' name='detail' id='detail'>";
echo "<input type='hidden' name='ContractID' id='ContractID' value='".$ContractID."'>";
echo "<table class='table1'>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Work Date</td>";
echo "<td class='formright'><input type='text' name='WorkDate' id='WorkDate' value='";
if (isset($_POST['WorkDate'])) {
	echo $_POST['WorkDate'];
}
echo "' size='8' maxlength='10'></td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Arrival Time</td>";
echo "<td class='formright'><input type='text' name='TimeIn' id='TimeIn' value='";
if (isset($_POST['TimeIn'])) {echo $_POST['TimeIn'];}
echo "' size='6' maxlength='8'></td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Travel Time</td>";
echo "<td class='formright'><input type='text' name='TravelTime' id='TravelTime' value='";
if (isset($_POST['TravelTime'])) {
	echo $_POST['TravelTime'];
}
echo "' size='4' maxlength='7'> minutes</td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Employees</td>";
echo "<td class='formright'>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_EmployeeList_Field";
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<select name='EmployeeList[]' id='EmployeeList[]' size='10' multiple='yes'>";
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"EmployeeID")."'";
	if (isset($_POST["EmployeeList"])) {
		if ($_POST["EmployeeList"] == odbc_result($rs,"EmployeeID")) {
			echo " SELECTED";
		}
	}
	echo ">".odbc_result($rs,"FullName")."</option>".$g_break;
}
echo "</select>";
odbc_close($conn);
echo "</td>";
echo "</tr>";

echo "<tr>";
echo "<td class='sideheader'>Work Performed</td>";
echo "<td class='formright'>";

$sql="usp_Select_ContractTasks ".$ContractID;
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
$rows=0;
echo "<table class='table1'>".$g_break;
while($row=odbc_fetch_array($rs)){
	if (fmod($rows, 2) == 0) {
		echo "<tr class='even'>".$g_break;
	} else {
		echo "<tr class='odd'>".$g_break;
	}
	echo "<td>";
	echo $row['Task'];
	echo "</td>";
	echo "<td>";
	echo "<input type='text' name='MID_".$row['MaintenanceTaskID']."' id='MID_".$row['MaintenanceTaskID']."' size='3' maxlength='3'>";
	echo "&nbsp;";
	if ($row['MinutesToComplete'] <> 0) {
		echo "(".$row['MinutesToComplete'].")";
		echo "&nbsp;";
	}
	echo "</td>";
	echo "</tr>";
	$rows++;
}
echo "</table>".$g_break;
echo "</td>";
echo "</tr>";

echo "<tr>";
echo "<td class='sideheader'>Complete</td>";
echo "<td class='formright'><input type='checkbox' name='Complete' id='Complete' value='Y'></td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'></td>";
echo "<td class='formright'><input type='submit' name='Submit' id='Submit' value='Save'></td>";
echo "</tr>".$g_break;

echo "</table>";
echo "</form>";
odbc_close($conn);
?>
</div>
</body>
</html>