<?php
/**************************************************************************************************
File......: footer.php
Purpose...: This file is to be included in all pages to display information at the bottom of the page.
Change Log:
Date		Name			Modification
---------------------------------------------------------------------------------------------------
10/13/2005	Brad Hughes		Created.
**************************************************************************************************/
$Foot = "<br>";
$Foot .= "<div class='foot'>";
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_Select_Objects 3";
$Links=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
while($row=odbc_fetch_array($Links)){
	$Foot .= "<a href='".$row['PageName']."'>".$row['ObjectName']."</a>&nbsp;&nbsp;";
}
odbc_close($conn);
$Foot .= "</div>";
?>