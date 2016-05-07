<?php 
$PageID = 62;
$ini_array = parse_ini_file("incl/edl.ini"); 
include "header.php";
header("Cache: private");
echo $HEAD;

if (isset($_POST["Password"]) and isset($_POST["Password2"])) {
	$Message = "";
	
	if (strlen($_POST["Password"]) < $ini_array["MinPassLength"]) {
		$Message = "Your password must be a minimum of ".$ini_array["MinPassLength"]." characters in length.";
	}
	
	if (strlen($Message) == 0) {
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$sql="usp_Update_ChangePassword ".$_SESSION["EmployeeID"].", '".md5($_POST["Password"]."salt").sha1($_POST["Password"]."salt")."'";
		$rs=odbc_exec($conn,$sql) or die_well(__FILE__, __LINE__,odbc_errormsg());
		header("Location: main.php");
	}
}
?>
<div class='main' id='main'>
<span class='title1'><?php echo $ini_array["SiteName"];?></span><br>
<span class='title2'>Reset Password</span><br>
<?php 
if (isset($Message)) {
	echo "<span class='warnred'>".$Message."</span>";
}
?>
<br>
<form action='reset.php' method='post' name='send' id='send'>
<table class="table1">
<tr>
<td class='sideheader'>New Password</td>
<td class='even'><input type='password' name='Password' id='Password' size='15' maxlength='30'></td>
</tr>
<tr>
<td class='sideheader'>Verify Password</td><td class='even'><input type='password' name='Password2' id='Password2' size='15' maxlength='30'></td>
</tr>
<tr>
<td class='sideheader'></td><td class='even'><input type='submit' name='Submit' id='Submit' value='Submit'></td>
</tr>
</table>
</form>
<a href='employees.php'>Employees</a>
</div>
</body>
</html>