<?php 
/**************************************************************************************************
File......: stub.php
Purpose...: This is a blank page.
Change Log:
Date		Name			Modification
---------------------------------------------------------------------------------------------------
10/13/2005	Brad Hughes		Created.
**************************************************************************************************/

$PageID = 6;
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
<span class='title2'>under construction</span><br><br>
<span class='warnred'>This page intentionally left blank.</span><br><br>
<?php
//$inis = ini_get_all();
//print_r($inis);
?>
</div>
</body>
<?php echo $Foot; ?>
</html>