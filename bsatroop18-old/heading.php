<?php
/**************************************************************************************************
File......: heading.php
Purpose...: This file is to be included in all pages to provide navigation.
Change Log:
Date		Name			Modification
---------------------------------------------------------------------------------------------------
10/13/2005	Brad Hughes		Created.
**************************************************************************************************/
$Head = "";
$Head .= "<span class='title1'>".$ini_array["SiteName"]."</span>";
$Head .= "<span class='onright'>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]);
$sql="usp_Select_ObjectPermissions 2,".$_SESSION["UserID"];
$Links=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
while($row=odbc_fetch_array($Links)){
	$Head .= "<a class='toplinks' href='".$row['PageName']."'>".$row['ObjectName']."</a>&nbsp;";
}
odbc_close($conn);
$Head .= "</span>";
?>