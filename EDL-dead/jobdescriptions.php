<?php 
$PageID = 54;
$ini_array = parse_ini_file("incl/edl.ini"); 
include "header.php";
header("Cache: private");
echo $HEAD;
if (isset($_POST["Submit"])) {
	if (isset($_POST["Active"])) {
		$Active = 'Y';
	} else {
		$Active = 'N';
	}
	if (isset($_POST["FieldWork"])) {
		$FieldWork = 'Y';
	} else {
		$FieldWork = 'N';
	}
	if (isset($_POST["DisplayOrder"])) {
		if (strlen($_POST["DisplayOrder"]) == 0) {
			$DisplayOrder = 0;
		} else {
			$DisplayOrder = $_POST["DisplayOrder"];
		}
	} else {
		$DisplayOrder = 0;
	}
	if (isset($_POST["JobDescription"])) {
		$JobDescription = sqlsafe($_POST["JobDescription"]);
	} else {
		$JobDescription = "";
	}
	if ($_POST["Submit"] == "Edit") {
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$sql = "usp_Update_JobDescription ".$_POST["DescriptionList"].", ".$DisplayOrder.", '".$_POST["JobTitle"]."', '".$JobDescription."', '".$FieldWork."', '".$Active."'";
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg(),$sql);
		odbc_free_result ($rs);
	}
	if ($_POST["Submit"] == "Add") {
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$sql = "usp_Insert_JobDescription ".$DisplayOrder.", '".sqlsafe($_POST["JobTitle"])."', '".$JobDescription."', '".$FieldWork."', '".$Active."'";
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg(),$sql);
		while($row=odbc_fetch_array($rs)){
			$JobDescriptionID = $row["NewID"];
		}
		odbc_free_result ($rs);
	}
}

if (isset($_POST["DescriptionList"])) {
	$JobDescriptionID = $_POST["DescriptionList"];
}
?>
<div class='main' id='main'>
<span class='title2'>Job Descriptions</span><br><br>
<?php
echo "<form action='JobDescriptions.php' method='post' name='ListChoice' id='ListChoice'>";
$sql="usp_Select_JobDescriptions";
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg(),$sql);
echo "Choose a job description <select name='DescriptionList' id='DescriptionList' onChange='this.form.submit()'>";
echo "<option value='0'>add new</option>";
while($row=odbc_fetch_array($rs)){
	echo "<option value='".$row["JobDescriptionID"]."'";
	if (isset($JobDescriptionID)) {
		if ($JobDescriptionID == $row["JobDescriptionID"]) {
			echo " SELECTED";
		}
	}
	echo ">".$row["JobTitle"];
	if ($row["Active"] <> "Y") {
		echo " (i)";
	}
	echo "</option>".$g_break;
}
echo "</select>";
odbc_close($conn);
echo "</form>".$g_break;

if (isset($JobDescriptionID)) {
	// Display the edit form.
	if ($JobDescriptionID > 0) { 
		$sql="usp_Select_JobDescription ".$JobDescriptionID;
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__, odbc_errormsg(), $sql);
		echo "<form action='JobDescriptions.php' method='post' name='edit' id='edit'>".$g_break;
		echo "<input type='hidden' name='DescriptionList' id='DescriptionList' value='".$JobDescriptionID."'>".$g_break;
		echo "<table class='table1'>".$g_break;
		while($row=odbc_fetch_array($rs)){
	
			echo "<tr>";
			echo "<td class='sideheader'>Job Title</td>";
			echo "<td class='formright'><input type='text' name='JobTitle' id='JobTitle' value='".$row['JobTitle']."' size='50' maxlength='50'></td>";
			echo "</tr>".$g_break;
			
			echo "<tr>";
			echo "<td class='sideheader'>Display Order</td>";
			echo "<td class='formright'><input type='text' name='DisplayOrder' id='DisplayOrder' value='".$row['DisplayOrder']."' size='4' maxlength='4'></td>";
			echo "</tr>".$g_break;
			
			echo "<tr>";
			echo "<td class='sideheader'>JobDescription</td>";
			echo "<td class='formright'><textarea cols='60' rows='5' name='JobDescription'>".$row['JobDescription']."</textarea></td>";
			echo "</tr>".$g_break;
			
			echo "<tr>";
			echo "<td class='sideheader'>Field Work</td>";
			echo "<td class='formright'>";
			echo "<input type='checkbox' name='FieldWork' id='FieldWork' value='Y'";
			if ($row['FieldWork'] == 'Y') { echo " CHECKED"; }
			echo ">";
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
			echo "<td class='formright'><input type='submit' name='Submit' id='Submit' value='Edit'></td>";
			echo "</tr>".$g_break;
		}
		echo "</table>";
		echo "</form>".$g_break;
		odbc_close($conn);
	} else {
		// Display the add form.
		echo "<form action='JobDescriptions.php' method='post' name='add' id='add'>".$g_break;
		echo "<table class='table1'>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Job Title</td>";
		echo "<td class='formright'><input type='text' name='JobTitle' id='JobTitle' value='' size='50' maxlength='50'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Display Order</td>";
		echo "<td class='formright'><input type='text' name='DisplayOrder' id='DisplayOrder' value='' size='4' maxlength='4'></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>JobDescription</td>";
		echo "<td class='formright'><textarea cols='60' rows='5' name='JobDescription'></textarea></td>";
		echo "</tr>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Field Work</td>";
		echo "<td class='formright'>";
		echo "<input type='checkbox' name='FieldWork' id='FieldWork' value='Y'";
		if ($row['FieldWork'] == 'Y') { echo " CHECKED"; }
		echo ">";
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
		echo "<td class='formright'><input type='submit' name='Submit' id='Submit' value='Add'></td>";
		echo "</tr>".$g_break;
		
		echo "</table>";
		echo "</form>".$g_break;
	}
}
?>
</div>
</body>
</html>