<?php 
if (isset($_POST["submit"])) {
	if ($_POST["submit"] == "refresh") {
		header("Location: errors.php");
	}
	if ($_POST["submit"] == "erase") {
		unlink("incl/odbcerror.txt");
		$fp=fopen("incl/odbcerror.txt","a");
		$output = date('Y-m-d H:i:s')." | Error file truncated.\r\n";
		fputs($fp,$output);
		fclose($fp);
		header("Location: errors.php");
	}
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled</title>
</head>
<body>
<form action="errors.php" method="post" name="delete" id="delete">
<input type="submit" name="submit" id="submit" value="erase">
<input type="submit" name="submit" id="submit" value="refresh">
</form>
<?php 
highlight_file("incl/odbcerror.txt"); 
?>
</body>
</html>