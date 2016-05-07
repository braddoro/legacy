<html>
<head>
<title></title>
</head>
<body>
<?php 
if (isset($_POST["field"])) {
	echo "<b>md5+sha1+salted:</b> ".md5($_POST["field"]."salt").sha1($_POST["field"]."salt")."<br>";
} 
?>
<form action="md5.php" method="post" name="foo" id="foo">
<input type="text" name="field" id="field" value="<?php if (isset($_POST["field"])) {echo $_POST["field"];} ?>">
<input type="submit" name="Submit" id="Submit" value="Submit">
</form>
</body>
</html>
