<?php 
$ini_array = parse_ini_file("incl/edl.ini"); 
session_start();
header("Cache: private");
if (isset($_POST['Submit'])) {
	if (isset($_POST["EmployeeList"])) {
		$_SESSION["EmployeeList"] = $_POST['EmployeeList'];
		header("Location: timesheetdescription.php");
	}
}
include "header.php";
echo $HEAD;
include "_functions.php";
echo print_r($_POST);
echo print_r($_SESSION);
?>
<div class='main' id='main'>
<span class='title2'>Time Sheet Step 2</span><br><br>
<?php
echo "<form action='timesheetemployees.php' method='post' name='input' id='input'>".$g_break;
echo "<table class='table1'>".$g_break;
echo "<tr>";
echo "<td class='sideheader'>Employees</td>";
echo "<td class='even'>";
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
echo "<td class='sideheader'></td>";
echo "<td class='even'><input type='submit' name='Submit' id='Submit' value='Next'></td>";
echo "</tr>".$g_break;

echo "</table>";
echo "</form>".$g_break;
?>
</div>
</body>
</html>