<html>
<head>
<title>Cemetery Search</title>
</head>
<script language = "Javascript">
// Declaring valid date character, minimum year and maximum year
var dtCh= "/";
var minYear=1700;
var maxYear=2100;

function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

function stripCharsInBag(s, bag){
	var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){   
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}

function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
		if (i==2) {this[i] = 29}
   } 
   return this
}

function isDate(dtStr){
  if (dtStr.length > 4) {
	var daysInMonth = DaysArray(12)
	var pos1=dtStr.indexOf(dtCh)
	var pos2=dtStr.indexOf(dtCh,pos1+1)
	var strMonth=dtStr.substring(0,pos1)
	var strDay=dtStr.substring(pos1+1,pos2)
	var strYear=dtStr.substring(pos2+1)
	strYr=strYear
	if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
	if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
	for (var i = 1; i <= 3; i++) {
		if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
	}
	month=parseInt(strMonth)
	day=parseInt(strDay)
	year=parseInt(strYr)
	if (pos1==-1 || pos2==-1){
		alert("The date format should be : mm/dd/yyyy")
  		return false
	}
	if (strMonth.length<1 || month<1 || month>12){
		alert("Please enter a valid month")
		return false
	}
	if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
		alert("Please enter a valid day")
		return false
	}
	if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
		alert("Please enter a valid 4 digit year between "+minYear+" and "+maxYear)
		return false
	}
	if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
		alert("Please enter a valid date")
		return false
	}
  }
return true
}
</script>
<body>
<table border="2" cellpadding="3" cellspacing="3" width="752" id="table7">
    <tr>
      <td width="141" height="103" valign="top" align="center">
      <img border="0" src="pcusac.gif" width="129" height="130"></td>
      <td width="582" height="103" colspan="3">
        <P align="center" style="word-spacing: 0; line-height: 100%; margin: 0">&nbsp;</P>
        <P align="center" style="word-spacing: 0; line-height: 100%; margin: 0">
        <font color="#800040" size="6" face="Lucida Calligraphy">Newell</font>
        <font color="#800040" face="Lucida Calligraphy" size="6">Presbyterian Church</font></P>
      <P align="center" style="word-spacing: 0; line-height: 100%; margin: 0">
      <font face="Lucida Calligraphy" size="1" color="#800040">&nbsp;</font></P>
        <P align="center" style="word-spacing: 0; line-height: 100%; margin: 0">
        &nbsp;</P>
        <P align="center" style="word-spacing: 0; line-height: 100%; margin: 0">
        <font face="Lucida Calligraphy" size="7" color="#800040">Cemetery</font></P>
        </td>
    </tr>
</table>
<br>
<?php
$username = "root";
$password = "alvahugh";
$dsn = "cemetery";
if (isset($_POST["edit_submit"])) {
  $sql="update cemetery_names set ";
  $sql=$sql."prefix = '".$_POST["prefix"]."', ";
  $sql=$sql."first_name = '".$_POST["first_name"]."', ";
  $sql=$sql."middle_name = '".$_POST["middle_name"]."', ";
  $sql=$sql."last_name = '".$_POST["last_name"]."', ";
  $sql=$sql."maiden_name = '".$_POST["maiden_name"]."', ";
  $sql=$sql."suffix = '".$_POST["suffix"]."', ";
  $sql=$sql."DOB = '".$_POST["DOB"]."', ";
  $sql=$sql."DOD = '".$_POST["DOD"]."', ";
  $sql=$sql."section = ".$_POST["section"].", ";
  $sql=$sql."comments = '".$_POST["comments"]."' ";
  $sql=$sql."where cemetery_id = ".$_POST["cemetery_id"]."";
  //echo $sql;
  $conn = odbc_connect($dsn, $username, $password);
  $rs=odbc_exec($conn,$sql) or die(__FILE__."<hr>".odbc_errormsg());
  odbc_close($conn);
}
if (isset($_POST["search"]) || isset($_REQUEST["search"])) {
  if (isset($_POST["search"])) {
    $sql_search=$_POST["search"];
  } else {
    $sql_search=$_REQUEST["search"];
  }
}
?>
<form action="cemetery.php" id="searchform" name="searchform" title="search" method="POST">
<input type="text" id="search" name="search" value="<?php if (isset($sql_search)) {echo $sql_search;} ?>" size="20" maxlength="20">
<input type="submit" name="Submit" value="Search" alt="Search" id="Submit" title="Search">
</form>
<?php
$conn = odbc_connect($dsn, $username, $password);
if (isset($_POST["search"]) || isset($_REQUEST["search"])) {
  if (isset($_POST["search"])) {
    $sql_search= $_POST["search"];
  } else {
    $sql_search= $_REQUEST["search"];
  }
  $sql="select cemetery_id, prefix, first_name, middle_name, last_name, maiden_name, suffix, DOB, DOD, section, comments from cemetery_names where first_name like '%".$sql_search."%' or middle_name like '%".$sql_search."%' or last_name like '%".$sql_search."%' or maiden_name like '%".$sql_search."%'";
} else {
  $sql="select cemetery_id, prefix, first_name, middle_name, last_name, maiden_name, suffix, DOB, DOD, section, comments from cemetery_names";
}
$sql=$sql." order by section";
if (!isset($_REQUEST["id"])) {
  $rs=odbc_exec($conn,$sql) or die(__FILE__."<hr>".odbc_errormsg());
    echo "<table border='0' style='border-collapse:collapse;'>";
    echo "<tr><th colspan='100%'>Search Results</th></tr>";
    echo "<tr bgcolor='#DCDCDC'>";
    //echo "<td>Name<td>";
    echo "<td>Prefix<td>";
    echo "<td>First Name<td>";
    echo "<td>Middle Name<td>";
    echo "<td>Last Name<td>";
    echo "<td>Maiden Name<td>";
    echo "<td>Suffix<td>";
    echo "<td>DOB<td>";
    echo "<td>DOD<td>";
    echo "<td>Section<td>";
    echo "<td>Comments<td>";
    echo "<td>Edit<td>";
    echo "</tr>";
  $curr_row=0;
  while (odbc_fetch_row($rs)) {
    if (fmod($curr_row, 2) == 0) {
      $bgcolor="#F0F0F0";
    } else {
      $bgcolor="#FFFFFF";
    }
    echo "<tr bgcolor='".$bgcolor."'>";
    //echo "<td>".odbc_result($rs,"prefix")." ".odbc_result($rs,"first_name")." ".odbc_result($rs,"middle_name")." ".odbc_result($rs,"last_name")." ".odbc_result($rs,"maiden_name")." ".odbc_result($rs,"suffix")."<td>";
    echo "<td>".odbc_result($rs,"prefix")."<td>";
    echo "<td>".odbc_result($rs,"first_name")."<td>";
    echo "<td>".odbc_result($rs,"middle_name")."<td>";
    echo "<td>".odbc_result($rs,"last_name")."<td>";
    echo "<td>".odbc_result($rs,"maiden_name")."<td>";
    echo "<td>".odbc_result($rs,"suffix")."<td>";
    echo "<td>".odbc_result($rs,"DOB")."<td>";
    echo "<td>".odbc_result($rs,"DOD")."<td>";
    echo "<td>".odbc_result($rs,"section")."<td>";
    echo "<td>".odbc_result($rs,"comments")."<td>";
    $temp = "<td><a href='cemetery.php?";
    if (isset($sql_search)) {
      $temp = $temp."search=".$sql_search."&";
    }
    $temp = $temp."id=".odbc_result($rs,"cemetery_id")."'>".odbc_result($rs,"cemetery_id");
    echo $temp;
    echo "<td>";
    echo "</tr>";
    $curr_row++;
  }
  echo "</table>";
  echo "Rows found: ".odbc_num_rows($rs);
  odbc_close($conn);
}

if (isset($_REQUEST["id"])) {
  if (isset($_REQUEST["search"])) {
    $sql_search = $_REQUEST["search"];
} else {
    $sql_search = "";
  }
  $conn = odbc_connect($dsn, $username, $password);
  $sql="select cemetery_id, prefix, first_name, middle_name, last_name, maiden_name, suffix, DOB, DOD, section, comments from cemetery_names where cemetery_id =".$_REQUEST["id"];
  $rs=odbc_exec($conn,$sql) or die(__FILE__."<hr>".odbc_errormsg());
  while (odbc_fetch_row($rs)) {
    echo "<hr>";
    echo "<form action='cemetery.php' id='edit' name='edit' title='edit' method='POST'>";
    echo "<table>";
    echo "<tr><th>Edit Entry</th><td align='right'><a href='cemetery.php?search=".$sql_search."'>show all names</td></tr>";
    echo "<INPUT type='hidden' name='cemetery_id' value='".odbc_result($rs,"cemetery_id")."' id='cemetery_id'>";
    echo "<INPUT type='hidden' name='search' value='".$sql_search."' id='search'>";
    echo "<D border='1' style='border-collapse:collapse;'>";
    echo "<tr>";
    echo "<TD>Name Prefix</TD>";
    echo "<TD><input type='text' id='prefix' name='prefix' value='".odbc_result($rs,"prefix")."' size='25' maxlength='25'></TD>";
    echo "</tr>";
    echo "<tr>";
    echo "<TD>First Name</TD>";
    echo "<TD><input type='text' id='first_name' name='first_name' value='".odbc_result($rs,"first_name")."' size='25' maxlength='25'></TD>";
    echo "</tr>";
    echo "<tr>";
    echo "<TD>Middle Name</TD>";
    echo "<TD><input type='text' id='middle_name' name='middle_name' value='".odbc_result($rs,"middle_name")."' size='25' maxlength='25'></TD>";
    echo "</tr>";
    echo "<tr>";
    echo "<TD>Last Name</TD>";
    echo "<TD><input type='text' id='last_name' name='last_name' value='".odbc_result($rs,"last_name")."' size='25' maxlength='25'></TD>";
    echo "</tr>";
    echo "<tr>";
    echo "<TD>Maiden Name</TD>";
    echo "<TD><input type='text' id='maiden_name' name='maiden_name' value='".odbc_result($rs,"maiden_name")."' size='25' maxlength='25'></TD>";
    echo "</tr>";
    echo "<tr>";
    echo "<TD>Name Suffix</TD>";
    echo "<TD><input type='text' id='suffix' name='suffix' value='".odbc_result($rs,"suffix")."' size='25' maxlength='25'></TD>";
    echo "</tr>";
    echo "<tr>";
    echo "<TD>Date of Birth</TD>";
    echo "<TD><input type='text' id='DOB' name='DOB' value='".odbc_result($rs,"DOB")."' size='10' maxlength='12' onblur='isDate(this.value);'></TD>";
    echo "</tr>";
    echo "<tr>";
    echo "<TD>Date of Death</TD>";
    echo "<TD><input type='text' id='DOD' name='DOD' value='".odbc_result($rs,"DOD")."' size='10' maxlength='12' onblur='isDate(this.value);'></TD>";
    echo "</tr>";
    echo "<tr>";
    echo "<TD>Section</TD>";
    echo "<TD><input type='text' id='section' name='section' value='".odbc_result($rs,"section")."' size='2' maxlength='2'></TD>";
    echo "</tr>";
    echo "<tr>";
    echo "<TD>Comments</TD>";
    echo "<TD><textarea cols='60' rows='5' name='comments' id='comments'>".odbc_result($rs,"comments")."</textarea></TD>";
    echo "</tr>";
    echo "<TD>&nbsp;</TD>";
    echo "<TD><INPUT type='submit' name='edit_submit' value='Save' alt='Save' id='edit_submit'></TD>";
    echo "</tr>";
    echo "</table>";
    echo "</form>";
  }
  odbc_close($conn);
}
?>
</body>
</html>