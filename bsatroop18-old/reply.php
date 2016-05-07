<?php 
/**************************************************************************************************
File......: stub.php
Purpose...: This is a blank page.
Change Log:
Date		Name			Modification
---------------------------------------------------------------------------------------------------
10/13/2005	Brad Hughes		Created.
**************************************************************************************************/
$PageID = 19;
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
<span class='title2'>reply</span>
<table class='table1'>
<form action="reply.php" method="post" name="add" id="add">
<input type="hidden" name="ID" id="ID" value="<?php if (isset($ID)) { echo $ID;} else {echo 0;} ?>">
<tr>
<td class='sideheader'></td>
<td class='even'><textarea cols="60" rows="10" name="Reply" id="Reply"></textarea></td>
</tr>
<tr>
<td class='sideheader'></td>
<td class='even'><input type="submit" name="submit" id="submit" value="Submit"></td>
</tr>
</form>
</table>
<!-- <span class='warnred'>This page intentionally left blank.</span><br><br> -->
<?php
?>
</div>
</body>
<?php echo $Foot; ?>
</html>