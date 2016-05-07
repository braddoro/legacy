<?php 
$PageID = 42;
$PageName="accounttypes.php";
$ListSP="usp_Select_AccountTypes_All";
$SelectSP="usp_Select_AccountType";
$UpdateSP="usp_Insert_AccountType";
$SelectedID="AccountTypeID";
$FieldString="AccountType";
$ViewString="Account Type";
$ini_array = parse_ini_file("incl/edl.ini"); 
include "header.php";
header("Cache: private");

$CurrentID = 0;
if (isset($_POST[$SelectedID])) {
	$CurrentID = $_POST[$SelectedID];
}

if (isset($_POST["Submit"])) {
	if (isset($_POST["Active"])) {
		$Active="Y";
	} else {
		$Active="N";
	}
	$sql = $UpdateSP." '".sqlsafe($_POST["TheString"])."', '".$Active."'";
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg(),$sql);
	while($row=odbc_fetch_array($rs)){
		$CurrentID = $row["NewID"];
	}
	odbc_free_result ($rs);
	odbc_close($conn);
}
echo $HEAD;
echo "<div class='main' id='main'>";
echo "<span class='title2'>".$ViewString."</span><br><br>";
echo "<form action='".$PageName."' method='post' name='List' id='List'>";
$sql=$ListSP;
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg(),$sql);
echo "Choose an ".$ViewString." <select name='".$SelectedID."' id='".$SelectedID."' onChange='this.form.submit()'>";
echo "<option value='0'>add new</option>";
while($row=odbc_fetch_array($rs)){
	echo "<option value='".$row[$SelectedID]."'";
	if (isset($CurrentID)) {
		if ($CurrentID == $row[$SelectedID]) {
			echo " SELECTED";
		}
	}
	echo ">".$row[$FieldString];
	if ($row["Active"] <> "Y") {
		echo " (i)";
	}
	echo "</option>".$g_break;
}
echo "</select>";
odbc_free_result ($rs);
odbc_close($conn);
echo "</form>".$g_break;

if (isset($CurrentID)) {
	// Display the edit form.
	if ($CurrentID > 0) { 
		$sql=$SelectSP." ".$CurrentID;
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__, odbc_errormsg(), $sql);
		echo "<form action='".$PageName."' method='post' name='edit' id='edit'>".$g_break;
		echo "<table class='table1'>".$g_break;
		while($row=odbc_fetch_array($rs)){
			echo "<tr>";
			echo "<td class='sideheader'>".$ViewString."</td>";
			echo "<td class='formright'><input type='text' name='TheString' id='TheString' value='".$row[$FieldString]."' size='50' maxlength='50'></td>";
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
		odbc_free_result ($rs);
		odbc_close($conn);
	} else {
		// Display the add form.
		echo "<form action='".$PageName."' method='post' name='add' id='add'>".$g_break;
		echo "<table class='table1'>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>".$ViewString."</td>";
		echo "<td class='formright'><input type='text' name='TheString' id='TheString' value='' size='50' maxlength='50'></td>";
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