<?php 
$PageID = 43;
$ini_array = parse_ini_file("incl/edl.ini"); 
include "header.php";
header("Cache: private");
if (isset($_POST["Detail_x"])) {
	header("location: contractdetail.php?CID=".$_POST["ContractID"]);
}
if (isset($_POST["Service_x"])) {
	header("location: contractservice.php?CID=".$_POST["ContractID"]);
}

echo $HEAD;
?>
<div class='main' id='main'>
<span class='title2'>Active Contracts</span><br><br>
<?php
$sql="usp_select_ActiveContracts";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<table class='table1'>".$g_break;
echo "<tr class='header'>";
echo "<td>Client</td>";
echo "<td>Job Site</td>";
echo "<td>Start Date</td>";
echo "<td>End Date</td>";
echo "<td align='center'>Edit</td>";
echo "<td align='center'>Service</td>";
echo "</tr>".$g_break;
$rows=0;
$pastdue=0;
while($row=odbc_fetch_array($rs)){
	if (fmod($rows, 2) == 0) {
		echo "<tr class='even'>".$g_break;
	} else {
		echo "<tr class='odd'>".$g_break;
	}
	echo "<form action='activecontracts.php' method='post' name='Choose' id='Choose'>".$g_break;
	echo "<input type='hidden' name='JobSiteID' id='JobSiteID' value='".$row['JobSiteID']."'>".$g_break;
	echo "<input type='hidden' name='ContractID' id='ContractID' value='".$row['ContractID']."'>".$g_break;
	echo "<td>".$row['CompanyName']."</td>".$g_break;
	echo "<td>".$row['JobSiteName']."</td>".$g_break;
	echo "<td>".$row['StartDate']."</td>".$g_break;
	echo "<td>".$row['EndDate']."</td>".$g_break;
	echo "<td align='center'><input type='image' name='Detail' id='Detail' src='images/icon_reply_topic.gif' alt='Edit' align='middle' width='15' height='15' border='0'></td>";
	echo "<td align='center'><input type='image' name='Service' id='Service' src='images/GEARS.GIF' alt='Service' align='middle' width='16' height='16' border='0'></td>";
	echo "</tr>".$g_break;
	echo "</form>";
	$rows++;
}
odbc_close($conn);
echo "<tr class='header'>".$g_break;
echo "<td colspan='100%'>";
echo "</td>";
echo "</tr>".$g_break;
echo "</table>".$g_break;
echo "<br>".$g_break;
?>
</div>
</body>
</html>