<?php 
function SQLSafe($InString) {
	$OutString = str_replace("'", "''",$InString);
	//$OutString = addslashes($InString);
	return $OutString;
}

function LogHistory($ObjectID_fk, $UserID_fk, $Record) {
	if (substr($_SERVER['REMOTE_ADDR'],0,10) != "192.168.1.") {
		//$conn=odbc_connect($ini_array["DSN"], $ini_array["UN"], $ini_array["PWD"]); 
		$conn=odbc_connect("Blog", "webapp", "braddoro"); 
		$sql="usp_Insert_History ".$ObjectID_fk.", ".$UserID_fk.", ".$Record.", '".$_SERVER['REMOTE_ADDR']."'";
		//echo $sql;
		$rs=odbc_exec($conn,$sql); 
		odbc_close($conn);
	}
}

function Age($Age) {
	$TheBlock = $Age;
	switch ($Age) {
	case ($Age > 0) && ($Age <= 60):
	   $TheBlock = ($Age)." minutes";
	   break;
	case ($Age > 60) && ($Age <= 1440):
	   $TheBlock = round($Age / 60)." hours";
	   break;
	case ($Age > 1440) && ($Age <= 10080):
	   $TheBlock = round($Age / 1440)." days";
	   break;
	case ($Age > 10080) && ($Age <= 43200):
	   $TheBlock = round($Age / 10080)." weeks";
	   break;
	case ($Age > 43200) && ($Age <= 518400):
	   $TheBlock = round($Age / 43829.0639)." months";
	   break;
	case ($Age > 518400):
	   $TheBlock = round($Age / 525948.766)." years";
	   break;
	}
	return $TheBlock;
}

?>