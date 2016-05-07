<?php 
$PageID = 33;
$ini_array = parse_ini_file("incl/edl.ini"); 
include "header.php";
header("Cache: private");
echo $HEAD;

if (isset($_POST["AccountTypeID"])) {
	$AccountTypeID = $_POST["AccountTypeID"];
}

if (isset($_POST["Submit"])) {
	if (isset($_POST["Active"])) {
		$Active="Y";
	} else {
		$Active="N";
	}
	$sql = "usp_Insert_AccountType '".$_POST["AccountType"]."', '".$Active."'";
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg(),$sql);
	while($row=odbc_fetch_array($rs)){
		$AccountTypeID = $row["NewID"];
	}
	odbc_free_result ($rs);
	odbc_close($conn);
}
?>
<div class='main' id='main'>
<span class='title2'>Account Types</span><br><br>
<?php
echo "<form action='accounttypes.php' method='post' name='ListChoice' id='ListChoice'>";
$sql="usp_Select_AccountTypes_All";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg(),$sql);
echo "Choose an account type <select name='AccountTypeID' id='AccountTypeID' onChange='this.form.submit()'>";
echo "<option value='0'>add new</option>";
while($row=odbc_fetch_array($rs)){
	echo "<option value='".$row["AccountTypeID"]."'";
	if (isset($AccountTypeID)) {
		if ($AccountTypeID == $row["AccountTypeID"]) {
			echo " SELECTED";
		}
	}
	echo ">".$row["AccountType"];
	if ($row["Active"] <> "Y") {
		echo " (i)";
	}
	echo "</option>".$g_break;
}
echo "</select>";
odbc_close($conn);
echo "</form>".$g_break;

if (isset($AccountTypeID)) {
	// Display the edit form.
	if ($AccountTypeID > 0) { 
		$sql="usp_Select_AccountType ".$AccountTypeID;
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__, odbc_errormsg(), $sql);
		echo "<form action='accounttypes.php' method='post' name='edit' id='edit'>".$g_break;
		echo "<input type='hidden' name='AccountType' id='AccountType' value='".$AccountTypeID."'>".$g_break;
		echo "<table class='table1'>".$g_break;
		while($row=odbc_fetch_array($rs)){
			
			echo "<tr>";
			echo "<td class='sideheader'>Account Type</td>";
			echo "<td class='formright'><input type='text' name='AccountType' id='AccountType' value='".$row['AccountType']."' size='50' maxlength='50'></td>";
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
		echo "<form action='accounttypes.php' method='post' name='add' id='add'>".$g_break;
		echo "<table class='table1'>".$g_break;
		
		echo "<tr>";
		echo "<td class='sideheader'>Account Type</td>";
		echo "<td class='formright'><input type='text' name='AccountType' id='AccountType' value='' size='50' maxlength='50'></td>";
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