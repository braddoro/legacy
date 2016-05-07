<?php 
$PageID = 49;
$ini_array = parse_ini_file("incl/edl.ini");
include "header.php";
header("Cache: private");
echo $HEAD;

$ContractID=0;
$JobSiteID=0;
if (isset($_GET["new"])) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql = "usp_Insert_Contract null, ".$_GET["JSID"];
	die_well(__FILE__, __LINE__,$sql);
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	while($row=odbc_fetch_array($rs)){
		$ContractID=$row['NewID'];
		$JobSiteID=$row['JobSiteID'];
	}
	odbc_close($conn);
}
if (isset($_REQUEST["CID"])) {
	$ContractID = $_REQUEST["CID"];
}
if (isset($_POST["ContractID"])) {
	$ContractID = $_POST["ContractID"];
}

if (isset($_POST['Submit'])) {
	if ($_POST['Submit'] == "Edit") {
		$sql = "usp_Insert_Contract ";
		$sql .= $ContractID.", ";
		$sql .= $_POST["JobSiteID"].", ";
		$sql .= $_POST["MonthlyRevenue"].", ";
		$sql .= $_POST["SquareFeet"].", ";
		$sql .= "'".$_POST["StartDate"]."', ";
		$sql .= "'".$_POST["EndDate"]."'";
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
		odbc_close($conn);
	}
	if ($_POST['Submit'] == "Save") {
		foreach($_POST as $varName => $value) {
			if (substr($varName,0,4) == "MID_") {
				if (strlen($value) > 0) {
					$ID = substr($varName,4,strlen($varName));
					$sql="usp_Insert_ContractItem ".$ContractID.", ".$ID.", ".$value.", ".$_POST["FRE_".$ID];
					$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
					$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
					odbc_close($conn);
				}
			}
		}
	}
}
?>
<div class='main' id='main'>
<span class='title2'>Contract Details</span><br><br>
<?php
//echo print_r($_POST);
echo "<form action='contractdetail.php' method='post' name='detail' id='detail'>";
echo "<table class='table1'>".$g_break;
$sql="usp_Select_Contract ".$ContractID;
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
while ($row=odbc_fetch_array($rs)) {
	echo "<input type='hidden' name='ContractID' id='ContractID' value='".$row['ContractID']."'>";
	echo "<input type='hidden' name='JobSiteID' id='JobSiteID' value='".$row['JobSiteID_fk']."'>";
	
	echo "<tr>";
	echo "<td class='sideheader'>Monthly Revenue</td>";
	echo "<td class='even'><input type='text' name='MonthlyRevenue' id='MonthlyRevenue' value='".$row['MonthlyRevenue']."' size='8' maxlength='8'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Square Feet</td>";
	echo "<td class='even'><input type='text' name='SquareFeet' id='SquareFeet' value='".$row['SquareFeet']."' size='8' maxlength='8'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Start Date</td>";
	echo "<td class='even'><input type='text' name='StartDate' id='StartDate' value='".$row['StartDate']."' size='15' maxlength='15'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>End Date</td>";
	echo "<td class='even'><input type='text' name='EndDate' id='EndDate' value='".$row['EndDate']."' size='15' maxlength='15'></td>";
	echo "</tr>".$g_break;
}
odbc_close($conn);
echo "<tr>";
echo "<td class='sideheader'>End Date</td>";
echo "<td class='even'><input type='submit' name='Submit' id='Submit' value='Edit'></td>";
echo "</tr>".$g_break;
echo "</table>";
echo "</form>";
echo "<br>";
echo "<form action='contractdetail.php' method='post' name='workitems' id='workitems'>";
echo "<table class='table1'>".$g_break;

echo "<tr>";
echo "<td class='header'>Task</td>";
echo "<td class='header'>Frequency</td>";
echo "<td class='header'>Time Each</td>";
echo "<td class='header'>Total</td>";
echo "</tr>".$g_break;
echo "<input type='hidden' name='ContractID' id='ContractID' value='".$ContractID."'>";
$sql="usp_Select_ContractTasks ".$ContractID;
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
$rows=0;
$Minutes=0;
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
	echo "<input type='text' name='FRE_".$row['MaintenanceTaskID']."' id='FRE_".$row['MaintenanceTaskID']."' value='".$row['FrequencyOfTask']."' size='5' maxlength='5'>";
	echo "&nbsp;</td>";
	echo "<td>";
	echo "<input type='text' name='MID_".$row['MaintenanceTaskID']."' id='MID_".$row['MaintenanceTaskID']."' value='".$row['MinutesToComplete']."' size='5' maxlength='5'>";
	echo "</td>";
	echo "<td>";
	if (($row['FrequencyOfTask']*$row['MinutesToComplete']) <> 0) {
		echo round(($row['FrequencyOfTask']*$row['MinutesToComplete'])/60,2);
		$Minutes=$Minutes+$row['FrequencyOfTask']*$row['MinutesToComplete'];
	}
	echo "</td>";
	echo "</tr>";
	$rows++;
}
$rows++;
if (fmod($rows, 2) == 0) {echo "<tr class='even'>".$g_break;} else {echo "<tr class='odd'>".$g_break;}
echo "<tr>";
echo "<td></td>";
echo "<td></td>";
echo "<td>Total Hours</td>";
echo "<td>".round($Minutes/60,2)."</td>";
echo "</tr>".$g_break;
$rows++;
if (fmod($rows, 2) == 0) {echo "<tr class='even'>".$g_break;} else {echo "<tr class='odd'>".$g_break;}
echo "<tr>";
echo "<td>";
echo "<td colspan='100%'><input type='submit' name='Submit' id='Submit' value='Save'></td>";
echo "</tr>".$g_break;
echo "</table>";
echo "</form>";
odbc_close($conn);
?>
</div>
</body>
</html>