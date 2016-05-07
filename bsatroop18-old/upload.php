<?php 
/**************************************************************************************************
File......: upload.php
Purpose...: A page to upload a file.
Change Log:
Date		Name			Modification
---------------------------------------------------------------------------------------------------
10/13/2005	Brad Hughes		Created.
**************************************************************************************************/
$PageID = 10;
$ini_array = parse_ini_file("incl/the.ini"); 
session_start();
header("Cache: private");
include "_functions.php";
include "heading.php";
include "footer.php";
include "pagecheck.php";

$Message = "";
if (isset($_POST["FileUp"])) {
	$FileUp=$_POST["FileUp"];
} else {
	$FileUp="";
}
$UploadDir = "news/";

if (isset($_FILES["FileUp"]["name"])) {
	$CompareTo = ".asax.ascx.ashx.asmx.aspx.ade.adp.asa.asp.asx.axd.bas.bat.cfm.cs.cdx.config.csproj.cfml.cer.chm.cmd.com.cpl.crt.dbm.dll.exe.hlp.hta.htr.htm.html.idc.inf.ins.isp.js.jse.licx.lnk.mdb.mde.mdt.mdw.mdz.msc.msi.msp.mst.pcd.printer.pif.pl.pm.php.reg.red.resx.resources.scf.soap.scr.sct.shb.shtm.shtml.stm.shs.url.vb.vbe.vbs.vbproj.vsdisco.ws.webinfo.wsc.wsf.wsh";
	$Spot = strpos(strrev($_FILES["FileUp"]["name"]),".");
	$Extention = substr($_FILES["FileUp"]["name"],strlen($_FILES["FileUp"]["name"])-$Spot, $Spot);
	if (strpos($CompareTo, $Extention)) {
		$Message .= "<b>Rejected:</b> Files with an extention of ".$Extention." are not allowed.<br>";
	} else {
		if (move_uploaded_file($_FILES["FileUp"]["tmp_name"], $UploadDir.$_FILES["FileUp"]["name"])) {
			$Message .= "uploaded to: <a href='".$UploadDir.$_FILES["FileUp"]["name"]."'>".$UploadDir.$_FILES["FileUp"]["name"]."</a> size: ".$_FILES["FileUp"]["size"]."<br>";
		} else {
			switch (true) {
		    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_OK): // 0
		        $Message .= "<span class='warnred'>There is no error, the file uploaded with success.</span><br>";
		        break;
		    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_INI_SIZE): // 1
		        $Message .= "<span class='warnred'>The uploaded file exceeds the upload_max_filesize directive in php.ini.</span><br>";
		        break;
		    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_FORM_SIZE): // 2
		        $Message .= "<span class='warnred'>The uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the HTML form.</span><br>";
		        break;
		    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_PARTIAL): // 3
		        $Message .= "<span class='warnred'>The uploaded file was only partially uploaded.</span><br>";
		        break;
		    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_NO_FILE): // 4
		        $Message .= "<span class='warnred'>No file was uploaded.</span><br>";
		        break;
		    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_NO_TMP_DIR): // 6
		        $Message .= "<span class='warnred'>Missing a temporary folder.</span><br>";
		        break;
		    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_CANT_WRITE): // 7
		        $Message .= "<span class='warnred'>Failed to write file to disk.</span><br>";
		        break;
			default:
		        $Message .= "<span class='warnred'>An unknown file upload error occured.</span><br>";
		        break;
			}
		}
	}
}
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
<span class='title2'>file upload</span><br><br>
<form action='upload.php' method='post' enctype='multipart/form-data' name='upload' id='upload'>
<input type='hidden' name='MAX_FILE_SIZE' id='MAX_FILE_SIZE' value='10485760'>
Choose a file name 
<input type='file' name='FileUp' id='FileUp' size='50'><br>
<input type='submit' name='Submit' id='Submit' value='submit'>
</form>
<?php echo $Message; ?>

</div>
</body>
<?php echo $Foot; ?>
</html>