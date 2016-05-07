<html>
<head>
<title>Cemetery Search</title>
</head>
<body>
<table border="2" cellpadding="3" cellspacing="3" width="752" id="table7">
    <tr>
      <td width="141" height="103" valign="top" align="center">
      <a href='http://www.newellpresby.org/'>
      <img border="0" src="pcusac.gif" width="129" height="130"></td>
      </a>
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
<form action="cemetery.php" id="searchform" name="searchform" title="search" method="POST">
<input type="text" id="search" name="search" value="<?php if (isset($sql_search)) {echo $sql_search;} ?>" size="20" maxlength="20">
<input type="submit" name="Submit" value="Search" alt="Search" id="Submit" title="Search">
</form>
<?php
$username = "root";
$password = "alvahugh";
$dsn = "cemetery";
$conn = odbc_connect($dsn, $username, $password);
if (isset($_POST["search"]) || isset($_REQUEST["search"])) {
  if (isset($_POST["search"])) {
    $sql_search= $_POST["search"];
  } else {
    $sql_search= $_REQUEST["search"];
  }
  $sql="select cemetery_id, prefix, first_name, middle_name, last_name, maiden_name, suffix, DOB, DOD, section, comments from cemetery_names where ";
  $sql=$sql."deleted <> 'Y' and (";
  $sql=$sql."prefix like '%".$sql_search."%' ";
  $sql=$sql."or first_name like '%".$sql_search."%' ";
  $sql=$sql."or middle_name like '%".$sql_search."%' ";
  $sql=$sql."or last_name like '%".$sql_search."%' ";
  $sql=$sql."or maiden_name like '%".$sql_search."%' ";
  $sql=$sql."or suffix like '%".$sql_search."%' ";
  $sql=$sql."or DOB like '%".$sql_search."%' ";
  $sql=$sql."or DOD like '%".$sql_search."%' ";
  $sql=$sql."or section = '".$sql_search."' ";
  $sql=$sql."or comments like '%".$sql_search."%')";
} else {
  $sql="select cemetery_id, prefix, first_name, middle_name, last_name, maiden_name, suffix, DOB, DOD, section, comments from cemetery_names";
}
$sql=$sql." order by section, last_name, first_name";
//echo $sql;
if (!isset($_REQUEST["id"])) {
  $rs=odbc_exec($conn,$sql) or die(__FILE__."<hr>".odbc_errormsg());
  if (odbc_num_rows($rs) == 0) {
    echo "No matching records.<br>";
  } else {
    echo "<table border='0' style='border-collapse:collapse;'>";
    echo "<tr><th colspan='100%'>Search Results</th></tr>";
    echo "<tr bgcolor='#DCDCDC'>";
    echo "<td>Name</td>";
    echo "<td align='right'>DOB</td>";
    echo "<td align='right'>DOD</td>";
    echo "<td align='center'>Section</td>";
    echo "<td>Comments</td>";
    echo "</tr>\n";
  $curr_row=0;
  while (odbc_fetch_row($rs)) {
    if (fmod($curr_row, 2) == 0) {
      $bgcolor="#F0F0F0";
    } else {
      $bgcolor="#FFFFF0";
    }
    echo "<tr bgcolor='".$bgcolor."'>";
    echo "<td nowrap='nowrap' valign='top'>".odbc_result($rs,"prefix")." ".odbc_result($rs,"first_name")." ";
    echo odbc_result($rs,"middle_name")." ".odbc_result($rs,"last_name");
    if (strlen(odbc_result($rs,"maiden_name")) > 0) {
      echo " [".odbc_result($rs,"maiden_name")."] ";
    }
    echo " ".odbc_result($rs,"suffix")."</td>";
    echo "<td align='right' valign='top'>".odbc_result($rs,"DOB")."</td>";
    echo "<td align='right' valign='top'>".odbc_result($rs,"DOD")."</td>";
    echo "<td align='center' valign='top'>".odbc_result($rs,"section")."</td>";
    echo "<td valign='top'>".odbc_result($rs,"comments")."</td>";
    echo "</tr>\n";
    $curr_row++;
  }
  echo "</table>";
  odbc_close($conn);
  }
}
?>
</body>
</html>