<?php 
$PageID = 44;
$ini_array = parse_ini_file("incl/edl.ini"); 
include "header.php";
header("Cache: private");
if (isset($_POST["Detail_x"])) {
	header("location: proposaldetail.php?PID=".$_POST["ProposalID"]);
}
if (isset($_POST["Print_x"])) {
	header("location: proposalprint.php?PID=".$_POST["ProposalID"]);
}
if (isset($_POST["Service_x"])) {
	header("location: servicedetail.php?PID=".$_POST["ProposalID"]);
}

echo $HEAD;
?>
<div class='main' id='main'>
<span class='title2'>Active Proposals</span><br><br>
<?php
$sql="usp_Select_ActiveProposalList";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<table class='table1'>".$g_break;
echo "<tr class='header'>";
echo "<td>Client</td>";
echo "<td>Job Site</td>";
echo "<td>Proposal</td>";
echo "<td>Due Date</td>";
echo "<td align='center'>Edit</td>";
echo "<td align='center'>Print</td>";
echo "<td align='center'>Service</td>";
echo "</tr>".$g_break;
$rows=0;
$pastdue=0;
while($row=odbc_fetch_array($rs)){
	if ($row['PastDue'] == 'Y') {
		if (fmod($rows, 2) == 0) {
			echo "<tr class='evenwarn'>".$g_break;
		} else {
			echo "<tr class='oddwarn'>".$g_break;
		}
		$pastdue++;
	} else {
		if (fmod($rows, 2) == 0) {
			echo "<tr class='formright'>".$g_break;
		} else {
			echo "<tr class='odd'>".$g_break;
		}
	}
	echo "<form action='activeproposals.php' method='post' name='Choose' id='Choose'>".$g_break;
	//echo "<input type='hidden' name='ClientID' id='ClientID' value='".$row['ClientID']."'>".$g_break;
	echo "<input type='hidden' name='JobSiteID' id='JobSiteID' value='".$row['JobSiteID']."'>".$g_break;
	echo "<input type='hidden' name='ProposalID' id='ProposalID' value='".$row['ProposalID']."'>".$g_break;
	echo "<td>".$row['CompanyName']."</td>".$g_break;
	echo "<td>".$row['JobSiteName']."</td>".$g_break;
	echo "<td>".$row['ProposalName']."</td>".$g_break;
	echo "<td>".$row['DueDates']."</td>".$g_break;
	echo "<td align='center'><input type='image' name='Detail' id='Detail' src='images/icon_reply_topic.gif' alt='Edit' align='middle' width='15' height='15' border='0'></td>";
	echo "<td align='center'><input type='image' name='Print' id='Print' src='images/PRINTER.GIF' alt='Print' align='middle' width='16' height='16' border='0'></td>";
	echo "<td align='center'><input type='image' name='Service' id='Service' src='images/GEARS.GIF' alt='Service' align='middle' width='16' height='16' border='0'></td>";
	echo "</tr>".$g_break;
	echo "</form>";
	$rows++;
}
odbc_close($conn);
echo "<tr class='header'>".$g_break;
echo "<td colspan='2'>";
echo $rows." active appraisals";
echo "</td>";
echo "<td colspan='2'>";
echo "<span class='tinywhite'>";
echo $pastdue." past due</span>";
echo "</td>";
echo "<td colspan='100%'>";
echo "</td>";
echo "</tr>".$g_break;
echo "</table>".$g_break;
echo "<br>".$g_break;
?>
</div>
</body>
</html>