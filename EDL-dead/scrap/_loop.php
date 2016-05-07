$sql="usp_select_EmployeeList_all";
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "Choose an employee <select name='EmployeeList' id='EmployeeList' onChange='submitbutton()'>";
echo "<option value='0'></option>";
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



// load field list [multiselect box] from $_POST
     $fields = $_POST['fields'];

     // walk through all fields and build WHERE clause
     for ($i = 0; $i < count($fields); $i++) {
       if ($i > 0) {
         $addtoquery .= ' OR ';
       }
	 }