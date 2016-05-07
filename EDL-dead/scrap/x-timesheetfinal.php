<?php 
$ini_array = parse_ini_file("incl/edl.ini"); 
session_start();
header("Cache: private");
if (isset($_POST['Submit'])) {
	if (strlen($_POST['Description']) > 0) {
		//header("Location: timesheets.php");
	}
}
include "header.php";
echo $HEAD;
include "_functions.php";
?>
<div class='main' id='main'>
<span class='title2'>Time Sheet Step 4</span><br><br>
<?php
echo print_r($_SESSION);
?>
</div>
</body>
</html>