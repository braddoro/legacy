<?php 
$PageID = 47;
$ini_array = parse_ini_file("incl/edl.ini"); 
header("Cache: private");

//from K_F foreach($states as $key=>$value){echo "<option value=\"{$key}\">$value</option>\n";}

?>
<html>
<head>
<link rel='stylesheet' href='<?php echo $ini_array["StyleSheet"];?>'>
<title></title>
</head>
<body class='body' id='body1'>
<div class='bigbox' id='bigbox1'>
<span class='title1'><?php echo $ini_array["SiteName"];?></span><br>
<span class='title2'>Main</span><br>
<br>
<a href='employees.php'>Employees</a>
<?php

//highlight_file("main.php");

?>

</div>
</body>
</html>