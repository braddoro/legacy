<?php 
/**************************************************************************************************
File......: news.php
Purpose...: This file page displays the more recent news and serves as starting point for news.
Change Log:
Date		Name			Modification
---------------------------------------------------------------------------------------------------
10/13/2005	Brad Hughes		Created.
**************************************************************************************************/
$PageID = 5;
$ini_array = parse_ini_file("incl/the.ini"); 
session_start();
header("Cache: private");
include "_functions.php";
include "pagecheck.php";
include "heading.php";
include "footer.php";
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<?php
echo "<link rel='stylesheet' href='".$ini_array["StyleSheet"]."'>";
echo "<title>".$ini_array["SiteName"]."</title>";
?>
</head>
<body class='body' id='body'>
<div class='main' id='main'>
<?php echo $Head; ?>
<span class='title2'>News</span>
<?php 
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]) or die_well(__FILE__, __LINE__,odbc_errormsg());
$sql="usp_select_News";
$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
echo "<table class='table1'>".$g_break;
while($row=odbc_fetch_array($rs)) {
	echo "<tr>";
	echo "<td width='75%'><span class='header'>".$row['AddedDate']."</span> <span class='header2'>".$row['Topic']." :: ".stripslashes($row['Subject'])."</span></td>";
	echo "<td class='header' align='right'><a href='reply.php?ID=".$row['NewsID']."'><img src='images/Comment.gif' alt='reply' width='18' height='18' border='0'></a></td>";
	echo "</tr>".$g_break;
	echo "<tr><td class='odd' colspan='100%'>".stripslashes(nl2br($row['News']))."</td></tr>".$g_break;
	echo "<tr><td colspan='100%' align='left' class='odd'>by ".$row['Name']." ".$row['Signature']."</td>";
	echo "<tr><td class='odd' colspan='100%'><br></td></tr>".$g_break;
}
echo "</table>".$g_break;
odbc_close($conn);
?>
</div>
</body>
<?php echo $Foot; ?>
</html>