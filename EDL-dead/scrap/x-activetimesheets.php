<?php 
$ini_array = parse_ini_file("incl/edl.ini");
session_start();
header("Cache: private");
include "header.php";
if (isset($_POST['Submit'])) {
	if ($_POST['Submit'] == "Save") {
		$sql = "usp_Insert_NewService ".$_POST["ChooseClientID"].", ".$_POST["ChooseJobSiteID"].", ".$_POST["ChooseProposalID"].", ";
		if (isset($_POST["InvoiceDate"]) and isset($_POST["TimeIn"])) {
			$sql .= "'".$_POST["InvoiceDate"]." ".$_POST["TimeIn"]."', ";
		}
		$sql .= $_POST["LaborTime"].", ".$_POST["TravelTime"].", ";
		if (isset($_POST["Contractual"])) {
			$sql .= "'Y', ";
		} else {
			$sql .= "'N', ";
		}
		if (isset($_POST["Complete"])) {
			$sql .= "'Y', ";
		} else {
			$sql .= "'N', ";
		}
		$sql.="'".sqlsafe($_POST["Description"])."'";
		$foo=$sql;
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
		$zax="A";
		while (odbc_fetch_row($rs)) {
			$zax="B";
			$ServiceID = odbc_result($rs,"ServiceID");
			$ServiceDetailID = odbc_result($rs,"ServiceDetailID");
		}
		/*
		while($row=odbc_fetch_array($rs)){
			$zax="B";
			$ServiceID = $row["ServiceID"];
			$ServiceDetailID = $row["ServiceDetailID"];
		}
		*/
		odbc_close($conn);
		if (isset($ServiceDetailID)) {
			$zax="C";
			$baz.="";
			foreach ($_POST['EmployeeList'] as &$value) {
				$zax="D";
				$sql="usp_Insert_ServiceEmployee ".$ServiceDetailID.", ".$value;
				$baz.=$sql;
				$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
				$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
				odbc_close($conn);
			}
		}
	}
}
echo $HEAD;
?>
<div class='main' id='main'>
<span class='title2'>Time Sheets</span><br><br>
<?php
if (isset($foo)) {echo $foo."<br>";}
if (isset($baz)) {echo $baz."<br>";}
if (isset($zax)) {echo $zax."<br>";}
echo "<form action='activetimesheets.php' method='post' name='input' id='input'>".$g_break;
echo "<table class='table1'>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Client</td>";
echo "<td class='even'>";
$sql="usp_Select_Clients";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<select name='ChooseClientID' id='ChooseClientID' onChange='this.form.submit()'>";
echo "<option value='0'></option>";
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"ClientID")."'";
	if (isset($_POST["ChooseClientID"])) {
		if ($_POST["ChooseClientID"] == odbc_result($rs,"ClientID")) {
			echo " SELECTED";
		}
	}
	echo ">".odbc_result($rs,"CompanyName")."</option>".$g_break;
}
echo "</select>";
odbc_close($conn);
echo "</td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Job Site</td>";
echo "<td class='even'>";
if (isset($_POST["ChooseClientID"])) {
	$sql="usp_select_ClientJobSites ".$_POST["ChooseClientID"];
} else {
	$sql="usp_select_ClientJobSites";
}
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<select name='ChooseJobSiteID' id='ChooseJobSiteID' onChange='this.form.submit()'>";
echo "<option value='0'></option>";
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"JobSiteID")."'";
	if (isset($_POST["ChooseJobSiteID"])) {
		if ($_POST["ChooseJobSiteID"] == odbc_result($rs,"JobSiteID")) {
			echo " SELECTED";
		}
	}
	echo ">".odbc_result($rs,"JobSiteName")."</option>".$g_break;
}
echo "</select>";
odbc_close($conn);
echo "</td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Proposal</td>";
echo "<td class='even'>";
if (isset($_POST["ChooseProposalID"])) {
	$sql="usp_select_ActiveProposalsByJobSite ".$_POST["ChooseJobSiteID"];
} else {
	$sql="usp_select_ActiveProposalsByJobSite";
}
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<select name='ChooseProposalID' id='ChooseProposalID' onChange='this.form.submit()'>";
echo "<option value='0'></option>";
while (odbc_fetch_row($rs)) {
	echo "<option value='".odbc_result($rs,"ProposalID")."'";
	if (isset($_POST["ChooseProposalID"])) {
		if ($_POST["ChooseProposalID"] == odbc_result($rs,"ProposalID")) {
			echo " SELECTED";
		}
	}
	echo ">".odbc_result($rs,"ProposalName")."</option>".$g_break;
}
echo "</select>";
odbc_close($conn);
echo "</td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Contractual</td>";
echo "<td class='even'><input type='checkbox' name='Contractual' id='Contractual' value='Y'></td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Date</td>";
echo "<td class='even'><input type='text' name='InvoiceDate' id='InvoiceDate' value='";
if (isset($_POST['InvoiceDate'])) {
	echo $_POST['InvoiceDate'];
}
echo "' size='8' maxlength='10'></td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Arrival Time</td>";
echo "<td class='even'><input type='text' name='TimeIn' id='TimeIn' value='";
if (isset($_POST['TimeIn'])) {echo $_POST['TimeIn'];}
echo "' size='6' maxlength='8'></td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Labor Time</td>";
echo "<td class='even'><input type='text' name='LaborTime' id='LaborTime' value='";
if (isset($_POST['LaborTime'])) {echo $_POST['LaborTime'];}
echo "' size='4' maxlength='7'> hours</td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Travel Time</td>";
echo "<td class='even'><input type='text' name='TravelTime' id='TravelTime' value='";
if (isset($_POST['TravelTime'])) {
	echo $_POST['TravelTime'];
}
echo "' size='4' maxlength='7'> minutes</td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'>Employees</td>";
echo "<td class='even'>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_select_EmployeeList_Field";
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<select name='EmployeeList[]' id='EmployeeList[]' size='10' multiple='yes'>";
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
echo "</td>";
echo "</tr>";

echo "<tr>";
echo "<td class='sideheader'>Description</td>";
echo "<td class='even'>";
echo "<textarea cols='80' rows='10' name='Description' id='Description'>";
if (isset($_POST['Description'])) {echo $_POST['Description'];}
echo "</textarea>";
echo "</td>";
echo "</tr>";

echo "<tr>";
echo "<td class='sideheader'>Complete</td>";
echo "<td class='even'><input type='checkbox' name='Complete' id='Complete' value='Y'></td>";
echo "</tr>".$g_break;

echo "<tr>";
echo "<td class='sideheader'></td>";
echo "<td class='even'><input type='submit' name='Submit' id='Submit' value='Save'></td>";
echo "</tr>".$g_break;
echo "</table>";
echo "</form>".$g_break;
if (isset($_POST["ChooseProposalID"])) {
	echo "<br>".$g_break;
	echo "<form action='activetimesheets.php' method='post' name='input' id='input'>".$g_break;
	//odbc_result($rs,"ProposalID")
	echo "<table class='table1'>".$g_break;
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_ServiceWorkItems ".$_POST["ChooseProposalID"];
	$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
	$rows=0;
	while($row=odbc_fetch_array($rs)) {
		if (fmod($rows, 2) == 0) {
			echo "<tr class='even'>".$g_break;
		} else {
			echo "<tr class='odd'>".$g_break;
		}
		echo "<td>";
		echo odbc_result($rs,"WorkItemName")." ".odbc_result($rs,"Detail");
		echo "</td>";
		echo "<td>";
		echo "<input type='text' name='WID_".odbc_result($rs,"WorkItemID")."' id='WID_".odbc_result($rs,"WorkItemID")."' size='6' maxlength='6'>";
		echo " (".odbc_result($rs,"Units").")";
		echo "</td>";
		echo "</tr>".$g_break;
		$rows++;
	}
	odbc_close($conn);
	if (fmod($rows, 2) == 0) {
		echo "<tr class='even'>".$g_break;
	} else {
		echo "<tr class='odd'>".$g_break;
	}
	echo "<td></td>";
	echo "<td><input type='submit' name='Submit' id='Submit' value='Add'></td>";
	echo "</tr>".$g_break;
	echo "</table>";
	echo "</form>".$g_break;
}
?>
</div>
</body>
</html>