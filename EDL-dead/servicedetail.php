<?php 
$PageID = 64;
$ini_array = parse_ini_file("incl/edl.ini");
include "header.php";
header("Cache: private");
if (isset($_POST['Submit'])) {
	if ($_POST['Submit'] == "Save") {
		$sql = "usp_Insert_NewService ".$_POST["ProposalID"].", ";
		if (isset($_POST["WorkDate"]) and isset($_POST["TimeIn"])) {
			$sql .= "'".$_POST["WorkDate"]." ".$_POST["TimeIn"]."', ";
		}
		$sql .= $_POST["LaborTime"].", ".$_POST["TravelTime"].", ";
		if (isset($_POST["Complete"])) {
			$sql .= "'Y'";
		} else {
			$sql .= "'N'";
		}
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
		// get the return values.
		while (odbc_fetch_row($rs)) {
			$ServiceID = odbc_result($rs,"ServiceID");
			$ServiceDetailID = odbc_result($rs,"ServiceDetailID");
		}
		odbc_close($conn);
		// insert the employees.
		if (isset($ServiceDetailID) && isset($_POST['EmployeeList'])) {
			foreach ($_POST['EmployeeList'] as &$value) {
				$sql="usp_Insert_ServiceEmployee ".$ServiceDetailID.", ".$value;
				$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
				$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
				odbc_close($conn);
			}
		}
		// insert the work items.
		if (isset($ServiceDetailID)) {
			foreach($_POST as $varName => $value) {
				if (substr($varName,0,4) == "WID_") {
					if (strlen($value) > 0) {
						$ID = substr($varName,4,strlen($varName));
						$sql="usp_Insert_ServiceItem ".$ServiceDetailID.", ".$ID.", ".$value;
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
if (isset($_REQUEST["PID"])) {
	$ProposalID = $_REQUEST["PID"];
}
if (isset($_POST["ProposalID"])) {
	$ProposalID = $_POST["ProposalID"];
}
?>
<div class='main' id='main'>
<span class='title2'>Time Sheets</span><br><br>
<?php
echo "<form action='servicedetail.php' method='post' name='input' id='input'>".$g_break;
if (isset($ProposalID)) {
	echo "<input type='hidden' name='ProposalID' id='ProposalID' value='".$ProposalID."'>";
}
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
echo "<td class='sideheader'>Labor Time</td>";
echo "<td class='formright'><input type='text' name='LaborTime' id='LaborTime' value='";
if (isset($_POST['LaborTime'])) {echo $_POST['LaborTime'];}
echo "' size='4' maxlength='7'> hours</td>";
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
if (isset($ProposalID)) {
	echo "<tr>";
	echo "<td class='sideheader'>Material</td>";
	echo "<td class='formright'>";
	echo "<br>".$g_break;
	echo "<table class='table1'>".$g_break;
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_ServiceWorkItems ".$ProposalID;
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	$rows=0;
	while($row=odbc_fetch_array($rs)) {
		if (fmod($rows, 2) == 0) {
			echo "<tr class='even'>".$g_break;
		} else {
			echo "<tr class='odd'>".$g_break;
		}
		echo "<td>";
		echo odbc_result($rs,"WorkItemName")." ".odbc_result($rs,"Detail");
		echo "</td>";
		echo "<td>";
		echo "<input type='text' name='WID_".odbc_result($rs,"ProposalDetailID")."' id='WID_".odbc_result($rs,"ProposalDetailID")."' size='6' maxlength='6'>";
		echo " (".odbc_result($rs,"Units").")";
		echo "</td>";
		echo "</tr>".$g_break;
		$rows++;
	}
	odbc_close($conn);
	if (fmod($rows, 2) == 0) {
		echo "<tr class='even'>".$g_break;
	} else {
		echo "<tr class='odd'>".$g_break;
	}
	echo "</table>".$g_break;
	echo "</td>";
	echo "</tr>";
}
/*
echo "<tr>";
echo "<td class='sideheader'>Description</td>";
echo "<td class='formright'>";
echo "<textarea cols='60' rows='3' name='Description' id='Description'>";
if (isset($_POST['Description'])) {echo $_POST['Description'];}
echo "</textarea>";
echo "</td>";
echo "</tr>";
*/
echo "<tr>";
echo "<td class='sideheader'>Complete</td>";
echo "<td class='formright'><input type='checkbox' name='Complete' id='Complete' value='Y'></td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'></td>";
echo "<td class='formright'><input type='submit' name='Submit' id='Submit' value='Save'></td>";
echo "</tr>".$g_break;
echo "</table>";
echo "</form>".$g_break;
?>
</div>
</body>
</html>