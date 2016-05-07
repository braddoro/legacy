<%@ Language=VBScript %>
<%Option Explicit %>
<%Response.Buffer = True%>
<!-- #Include file="includes/connection.asp" 			-->
<!-- #Include file="includes/library.asp"				-->
<!-- 
COPYRIGHT NOTICE. 
All rights reserved. Any rights not expressly granted are reserved.
Copyright © 2002 Crucible Systems
-->
<html>
<head>
<title>Reservations</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
%>
<table width='100%' border='0'>
<!-- The header row. -->
<tr>
<td colspan='2'>
<% response.write str_LeftSideImage %> <h3><% response.write str_PageTitle %></h3>
</td>
<td><% Response.write str_RightSide%></td>
</tr>
<tr><td colspan='3'><hr width='100%' size='1'></td></tr>
<!-- The detail row. -->
<tr>
<!-- The List cell. -->
<td width='15%' valign='top'>
<%
int_PageName = 69
str_SQL = "SELECT LinkURL, LinkDisplay, Target FROM Links WHERE Links.Active='Y' AND " & _
		"PageNameID_fk=" & int_PageName & " or PageNameID_fk = 0 ORDER BY PageNameID_fk, Links.DisplayOrder"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
Do while not obj_RecordSet.eof
	if len(obj_RecordSet("LinkURL")) > 0 then
		response.write "<A href='" & obj_RecordSet("LinkURL") & _
					"' Target='" & obj_RecordSet("Target") & "'>" & _
					obj_RecordSet("LinkDisplay") & "</a><BR>"
	else
		response.write obj_RecordSet("LinkDisplay") & "<BR>"
	end if
	obj_RecordSet.movenext
loop
obj_RecordSet.close
Set obj_RecordSet = nothing
gls_LogPage int_PageName, request("REMOTE_HOST")
%>
</td>
<!-- The Body cell. -->
<td>
<%
response.write "<h3>Troop 18 Leaders Dinner</h3><br><br>"
response.write "We will be having dinner at the Longhorn Cafe on Mallard Creek and Harris Road.<br></P>Please join us for an evening of dinner and fun!.  We will be dining on December 4th or December 18th. Please indicate below who will be comingand which night you can attend."

response.write "<form action='Reservations.asp' name='Add' id='Add'>"
response.write "<table>"

response.write "<tr><td>Leader Name</td><td>"
response.write "<input type='text' name='ReservationName' id='ReservationName' size='80' maxlength='100'>"
response.write "</td</tr>"

response.write "<tr><td>Date</td><td>"
response.write "<select name='PreferredDate' id='PreferredDate'><option value='12/4/2003' SELECTED>December 4, 2003</option><option value='12/18/2003'>December 18, 2003</option></select>"
'response.write "<select name='PreferredDate' id='PreferredDate'><option value='12/4/2003' SELECTED>December 4, 2003</option></select>"
response.write "</td></tr>"

response.write "<tr><td></td><td>"
response.write "<input type='checkbox' name='AltDate' id='AltDate' value='Y'><h5>(I am also available on the alternate date if needed.)</h5>"
response.write "</td></tr>"

'response.write "<tr><td>Password</td><td>"
'response.write "<input type='password' name='Password' id='Password'><h5>(required to add news)</h5>"
'response.write "</td></tr>"

response.write "<tr><td>&nbsp;</td><td>"
response.write "<input type='submit' name='Submit' id='Submit' value='Submit'>"
response.write "</td></tr>"

response.write "</table>"
response.write "</form>"

Dim int_RecordsUpdated
if len(request("ReservationName")) > 0 then
	gls_LogPage int_PageName, request("REMOTE_HOST")
	str_SQL = "Insert into Reservations (ReservationDate, ReservationFor, AltDateAvailable) values('" & _
			glf_SQL_Safe3(request("PreferredDate")) & _
			"', '" & glf_SQL_Safe3(request("ReservationName")) & "', '" & request("AltDate") & "')"
	'response.write str_SQL
	set obj_Command = server.createObject("ADODB.Command")
	obj_Command.ActiveConnection = str_ConnectionString
	obj_Command.CommandText = str_SQL
	obj_Command.Execute int_RecordsUpdated
	set obj_Command = nothing
	if int_RecordsUpdated = 1 then
		response.redirect("Reservations.asp")
	end if
end if

response.write "<h3></h3>"
str_SQL = "SELECT Reservations.ReservationDate, Count(Reservations.ReservationID) AS Reservations FROM Reservations GROUP BY Reservations.ReservationDate ORDER BY Reservations.ReservationDate;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=1>"
response.write "<th colspan='2'>"
response.write "<b>Dates Chosen</b>"
response.write "</th>"
response.write "<tr>"
response.write "<th>"
response.write "Preferred Date"
response.write "</th>"
response.write "<th>"
response.write "Reservations"
response.write "</th>"
response.write "</tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write	obj_RecordSet("ReservationDate")
	response.write "</td>"
	response.write "<td>"
	response.write	obj_RecordSet("Reservations")
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close
response.write "</table><br>"
str_SQL = "SELECT Reservations.DateAdded, Reservations.ReservationDate, Reservations.ReservationFor, AltDateAvailable FROM Reservations ORDER BY Reservations.DateAdded desc;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table><table border=1>"
response.write "<th colspan='3'>"
response.write "<b>People Attending</b>"
response.write "</th>"
response.write "<tr>"
response.write "<th>"
response.write "Date"
response.write "</th>"
response.write "<th>"
response.write "Reservations"
response.write "</th>"
response.write "<th>"
response.write "Alt Date OK"
response.write "</th>"
response.write "</tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write	obj_RecordSet("ReservationDate")
	response.write "</td>"
	response.write "<td>"
	response.write	obj_RecordSet("ReservationFor")
	response.write "</td>"
	response.write "<td>"
	response.write	obj_RecordSet("AltDateAvailable") & "&nbsp;"
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close

response.write "</table>"
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>