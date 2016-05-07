<?php 
$ini_array = parse_ini_file("incl/edl.ini"); 
session_start();
header("Cache: private");
if (isset($_POST['Submit'])) {
	if (strlen($_POST['Description']) > 0) {
		$_SESSION["Description"] = $_POST['Description'];
		header("Location: timesheetfinal.php");
	}
}
include "header.php";
echo $HEAD;
include "_functions.php";
echo print_r($_POST);
echo print_r($_SESSION);
?>
<div class='main' id='main'>
<span class='title2'>Time Sheet Step 3</span><br><br>
<?php
//echo print_r($_POST);
echo "<form action='timesheetdescription.php' method='post' name='input' id='input'>".$g_break;
echo "<table class='table1'>".$g_break;
echo "<tr>";
echo "<td class='sideheader'>Employees</td>";
echo "<td class='even'>";
echo "<textarea cols='60' rows='15' name='Description' id='Description'></textarea>";
echo "</td>";
echo "</tr>";

echo "<tr>";
echo "<td class='sideheader'></td>";
echo "<td class='even'><input type='submit' name='Submit' id='Submit' value='Done'></td>";
echo "</tr>".$g_break;

echo "</table>";
echo "</form>".$g_break;
?>
</div>
</body>
</html>