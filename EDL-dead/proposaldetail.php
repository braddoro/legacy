<?php 
$PageID = 60;
$ini_array = parse_ini_file("incl/edl.ini"); 
header("Cache: private");
include "header.php";

$ProposalID=0;
$JobSiteID=0;
if (isset($_GET["new"])) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql = "usp_Insert_Proposal ".$_GET["JSID"];
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	while($row=odbc_fetch_array($rs)){
		$ProposalID=$row['NewID'];
		$JobSiteID=$row['JobSiteID'];
	}
	odbc_close($conn);
}
if (isset($_REQUEST["PID"])) {
	$ProposalID = $_REQUEST["PID"];
}
if (isset($_POST["ProposalID"])) {
	$ProposalID = $_POST["ProposalID"];
}
if (isset($_POST['Submit'])) {	
	if ($_POST['Submit'] == "Save") {
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$sql = "usp_Insert_ProposalInformation ".$_POST["ProposalID"].", ".$_POST["JobSiteID"].", ".$_POST["PlantMarkup"].", ".$_POST["LaborCostPerHour"].", '".sqlsafe($_POST["ProposalName"])."', '".$_POST["DueDate"]."', '".$_POST["ShowDetail"]."'";
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
		odbc_close($conn);
	}
	if ($_POST['Submit'] == "Add") {
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$sql = "usp_Insert_ProposalDetail ".$_POST["ProposalID"].", ".$_POST["WorkItemID"].", ".$_POST["Units"].", ".$_POST["Cost"].", '".SQLSafe($_POST["Detail"])."'";
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
		odbc_close($conn);
	}
	//if ($_POST['Submit'] == "Note") {
	//	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	//	$sql = "usp_Insert_ProposalText ".$_POST["ProposalID"].", '".SQLSafe($_POST["Description"])."'";
	//	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	//	odbc_close($conn);
	//}
}
if (isset($_POST['ProposalDetailID'])) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql = "usp_Delete_ProposalDetail ".$_POST["ProposalDetailID"];
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	odbc_close($conn);
}
echo $HEAD;
include "_javascript.php";
//echo print_r($_POST);
?>
<div class='main' id='main'>
<span class='title2'>Edit Proposal</span><br><br>
<?php

/****************************************************************************************
Code to display the high level proposal information contained in dyn_Proposals.
****************************************************************************************/
echo "<span class='title3'>Proposal</span><br>";
$sql="usp_Select_Proposal ".$ProposalID;
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<form action='proposaldetail.php' method='post' name='Edit' id='Edit'>".$g_break;
echo "<table class='table1'>".$g_break;
while($row=odbc_fetch_array($rs)){
	echo "<input type='hidden' name='ProposalID' id='ProposalID' value='".$row['ProposalID']."'>";
	$JobSiteID = $row['JobSiteID_fk'];
	echo "<input type='hidden' name='JobSiteID' id='JobSiteID' value='".$JobSiteID."'>";
	
	echo "<tr>";
	echo "<td class='sideheader'>Company Name</td>";
	echo "<td class='even'><span class='title3'>".stripslashes($row['CompanyName'])."</span></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Job Site</td>";
	echo "<td class='even'><span class='title3'>".stripslashes($row['JobSiteName'])."</span></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Proposal Name</td>";
	echo "<td class='even'><input type='text' name='ProposalName' id='ProposalName' value='".stripslashes($row['ProposalName'])."' size='90' maxlength='100'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Due Date</td>";
	echo "<td class='even'><input type='text' name='DueDate' id='DueDate' value='".$row['DueDate']."' size='12' maxlength='12'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Plant Markup</td>";
	echo "<td class='even'><input type='text' name='PlantMarkup' id='PlantMarkup' value='".$row['PlantMarkup']."' size='6' maxlength='6'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Labor Cost Per Hour</td>";
	echo "<td class='even'><input type='text' name='LaborCostPerHour' id='LaborCostPerHour' value='".$row['LaborCostPerHour']."' size='6' maxlength='6'></td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'>Show Invoice Detail</td>";
	echo "<td class='even'>";
	echo "<input type='checkbox' name='ShowDetail' id='ShowDetail' value='Y'";
	if ($row['ShowDetail'] == 'Y') { echo " CHECKED"; }
	echo ">";
	echo "</td>";
	echo "</tr>".$g_break;
	
	echo "<tr>";
	echo "<td class='sideheader'></td>";
	echo "<td class='even'><input type='Submit' name='Submit' id='Submit' value='Save'></td>";
	echo "</tr>".$g_break;
}
odbc_close($conn);
echo "</table>".$g_break;
echo "</form>".$g_break;
echo "<br>".$g_break;

/****************************************************************************************
Code to display the line item information contained in dyn_ProposalDetails.
****************************************************************************************/
echo "<span class='title3'>Material</span><br>";
echo "<form action='proposaldetail.php' method='post' name='input' id='input'>".$g_break;
echo "<table class='table1'>".$g_break;
echo "<input type='hidden' name='ProposalID' id='ProposalID' value='".$ProposalID."'>";
echo "<input type='hidden' name='JobSiteID' id='JobSiteID' value='".$JobSiteID."'>";

echo "<tr>";
echo "<td class='sideheader'>Units</td>";
echo "<td class='even'>";
echo "<input type='text' name='Units' id='Units' size='5' maxlength='5'>";
echo "</td>";
echo "</tr>".$g_break;
if (isset($_POST['Submit'])) {
	if ($_POST['Submit'] == "Add") {
		echo "<script type='text/javascript'>setFocus('input', 'Units')</script>";
	}
}

echo "<tr>";
echo "<td class='sideheader'>Detail</td>";
echo "<td class='even'>";
echo "<input type='text' name='Detail' id='Detail' size='50' maxlength='100'>";
echo "</td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Item</td>";
echo "<td class='even'>";
$sql="usp_select_WorkItems";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<select name='WorkItemID' id='WorkItemID'>";
echo "<option value='0'></option>";
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"WorkItemID")."'";
	if (isset($_POST["WorkItemID"])) {
		if ($_POST["WorkItemID"] == odbc_result($rs,"WorkItemID")) {
			echo " SELECTED";
		}
	}
	echo ">".odbc_result($rs,"WorkItemName")."</option>".$g_break;
}
echo "</select>";
odbc_close($conn);
echo "</td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Cost Per</td>";
echo "<td class='even'>";
echo "<input type='text' name='Cost' id='Cost' size='7' maxlength='7'>";
echo "</td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'></td>";
echo "<td class='even'><input type='submit' name='Submit' id='Submit' value='Add'></td>";
echo "</tr>".$g_break;

echo "</table>";
echo "</form>".$g_break;

$sql="usp_Select_ProposalList ".$ProposalID;
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<table class='table1'>".$g_break;
echo "<tr>";
echo "<td class='header'>Units</td>";
echo "<td class='header'>Description</td>";
echo "<td class='header'>Size</td>";
echo "<td  align='right' class='header'>Material</td>";
echo "<td  align='right' class='header'>Total</td>";
echo "<td class='header'>Delete</td>";
echo "</tr>".$g_break;
$rows=1;
$GT_Cost=0;
$Minutes=0;
while($row=odbc_fetch_array($rs)){
	$Material = ($row['CostPerUnit'])*$row['PlantMarkup'];
	$Labor = ($row['WorkItemMinutes']*($row['LaborCostPerHour']/60));
	echo "<form action='proposaldetail.php' method='post' name='Description' id='Description'>".$g_break;
	echo "<input type='hidden' name='ProposalID' id='ProposalID' value='".$row['ProposalID_fk']."'>".$g_break;
	echo "<input type='hidden' name='JobSiteID' id='JobSiteID' value='".$JobSiteID."'>";
	echo "<input type='hidden' name='ProposalDetailID' id='ProposalDetailID' value='".$row['ProposalDetailID']."'>".$g_break;
	if (fmod($rows, 2) == 0) {
		echo "<tr class='even'>".$g_break;
	} else {
		echo "<tr class='odd'>".$g_break;
	}
	echo "<td>".$row['Units']."</td>".$g_break;
	echo "<td>".$row['Detail']."</td>".$g_break;
	echo "<td>".$row['WorkItemName']."</td>".$g_break;
	echo "<td align='right'>$".number_format($Material+$Labor,2)."</td>".$g_break;
	echo "<td align='right'>$".number_format(($Material+$Labor)*$row['Units'],2)."</td>".$g_break;
	echo "<td><input type='image' name='ItemDelete' id='ItemDelete' src='images/del.gif' alt='Item Delete' align='middle' width='20' height='20' border='0'></td>";
	echo "</tr>".$g_break;
	echo "</form>".$g_break;
	$GT_Cost=$GT_Cost+($Material+$Labor)*$row['Units'];
	$Minutes=$Minutes+($row['Units']*$row['WorkItemMinutes']);
	$rows++;
}
echo "<tr class='header'>".$g_break;
echo "<td class='tinywhite' colspan='3'>";
echo round($Minutes/60,0);
echo " hours</td>";
echo "<td>&nbsp;</td>";
echo "<td align='right' class='tinywhite'>$".number_format($GT_Cost,2)."</td>";
echo "<td>&nbsp;</td>";
echo "</tr>".$g_break;
echo "</table>".$g_break;
odbc_close($conn);
echo "<br>".$g_break;

/****************************************************************************************
Code to display the description contained in dyn_ProposalText.
****************************************************************************************/
echo "<span class='title3'>Work Description</span><br>";
$sql="usp_Select_ProposalText ".$ProposalID;
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
$Text = "";
while($row=odbc_fetch_array($rs)){
	$Text = $row['ProposalText'];
}
echo "<form action='proposaldetail.php' method='post' name='Description' id='Description'>";
echo "<input type='hidden' name='ProposalID' id='ProposalID' value='".$ProposalID."'>";
echo "<textarea cols='90' rows='10' name='Description' id='Description'>".(stripslashes($Text))."</textarea><br>";
echo "<input type='submit' name='Submit' id='Submit' value='Note'>".$g_break;
echo "</form>";
?>
</div>
</body>
</html>