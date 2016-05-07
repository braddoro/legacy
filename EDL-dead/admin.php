<?php 
$PageID = 46;
$ini_array = parse_ini_file("incl/edl.ini"); 
include "header.php";
header("Cache: private");
echo $HEAD;
?>
<div class='main' id='main'>
<span class='title2'>Admin</span><br><br>
<?php 
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_Select_Objects 2";
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<table class='table1'>".$g_break;
while($row=odbc_fetch_array($rs)){
	echo "<tr>";
	echo "<td class='formright'>";
	if (strlen($row['PageName']) == 0) {
		echo "<span class='tinyblue'>".$row['ObjectName']."</class>";
	} else {
		echo "<a href='".$row['PageName']."' title='".$row['Description']."'>".$row['ObjectName']."</a>";
	}
	echo "</td>";
	echo "</tr>".$g_break;
}
echo "</table>".$g_break;
odbc_close($conn);
?>
</div>
</body>
</html>