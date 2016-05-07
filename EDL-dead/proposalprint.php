<html>
<body class='plain'>
<?php
$ini_array = parse_ini_file("incl/edl.ini"); 
echo "<link rel='stylesheet' href='".$ini_array["StyleSheet"]."'>";
include "_functions.php";
$ProposalID = $_REQUEST["PID"];
$GT_Cost=0;
$Material=0;
$Labor=0;
$sql="usp_Select_Proposal ".$ProposalID;
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<table>".$g_break;
$ShowDetail = 'N';
while($row=odbc_fetch_array($rs)){
	echo "<tr>";
	echo "<td colspan='4' align='center'><b>Environmental Design Landscape</b></td>";
	echo "<td align='right'>".date("m/d/Y")."</td>";
	echo "</tr>".$g_break;
	echo "<tr>";
	echo "<td>P.O. Box 10</td>";
	echo "<td>Newell NC 28126</td>";
	echo "<td colspan='2'>704.597.2196 Fax: 704.597.4328</td>";
	echo "</tr>".$g_break;
	echo "<tr>";
	echo "<td colspan='2'>".stripslashes($row['CompanyName'])."</td>";
	echo "<td colspan='2'>".stripslashes($row['JobSiteName'])."</td>";
	echo "<td align='right'>".$row['ProposalID']."</td>";
	echo "</tr>".$g_break;
	$ShowDetail = $row['ShowDetail'];
}
odbc_close($conn);
echo "<tr>";
echo "<td colspan='5' align='center'>&nbsp;</td>";
echo "</tr>".$g_break;

if ($ShowDetail == 'Y') {
	echo "<tr>";
	echo "<td><b>Quantity</b></td>";
	echo "<td><b>Description</b></td>";
	echo "<td><b>Size</b></td>";
	echo "<td align='right'><b>Unit</b></td>";
	echo "<td align='right'><b>Total</b></td>";
	echo "</tr>".$g_break;
	$sql="usp_Select_ProposalList ".$ProposalID;
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	while($row=odbc_fetch_array($rs)) {
		$Material = ($row['CostPerUnit'])*$row['PlantMarkup'];
		$Labor = ($row['WorkItemMinutes']*($row['LaborCostPerHour']/60));
		echo "<tr>";
		echo "<td>".$row['Units']."</td>".$g_break;
		echo "<td>".$row['Detail']."</td>".$g_break;
		echo "<td>".$row['WorkItemName']."</td>".$g_break;
		echo "<td align='right'>$".number_format($Material+$Labor,2)."</td>".$g_break;
		echo "<td align='right'>$".number_format(($Material+$Labor)*$row['Units'],2)."</td>".$g_break;
		echo "</tr>".$g_break;
		$GT_Cost=$GT_Cost+($Material+$Labor)*$row['Units'];
	}
	echo "<tr>";
	echo "<td colspan='4'>&nbsp;</td>";
	echo "<td align='right'><b>$".number_format($GT_Cost,2)."</b></td>";
	echo "</tr>";
	odbc_close($conn);
	echo "<br>".$g_break;
}
echo "<tr>";
echo "<td colspan='5' align='center'>&nbsp;</td>";
echo "</tr>".$g_break;
echo "<tr>";
echo "<td colspan='5' align='left'>";
$sql="usp_Select_ProposalText ".$ProposalID;
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
while($row=odbc_fetch_array($rs)) {
	echo nl2br(stripslashes($row['ProposalText']));
}
echo "</td>";
echo "</tr>".$g_break;
echo "</table>";
?>
</body>
</html>