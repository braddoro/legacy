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
<title>Event Add</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName

dim obj_SelectBox
%>
<table width='100%' border='0'><% response.write vbcrlf %>
<!-- The header row. -->
<tr>
<th colspan='2'>
<% response.write str_LeftSideImage %> <h3><% response.write str_PageTitle %></h3><% response.write vbcrlf %>
</th>
<td><% Response.write str_RightSide%></td>
</tr>
<tr><td colspan='3'><hr width='100%' size='1'></td></tr>
<!-- The detail row. -->
<tr>
<!-- The List cell. -->
<td width='15%' valign='top'><% response.write vbcrlf %>
<%
int_PageName = 52
str_SQL = "SELECT LinkURL, LinkDisplay, Target FROM Links WHERE Links.Active='Y' AND " & _
		"PageNameID_fk=" & int_PageName & " or PageNameID_fk = 0 ORDER BY PageNameID_fk, Links.DisplayOrder"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
Do while not obj_RecordSet.eof
	if len(obj_RecordSet("LinkURL")) > 0 then
		response.write "<A href='" & obj_RecordSet("LinkURL") & _
					"' Target='" & obj_RecordSet("Target") & "'>" & _
					obj_RecordSet("LinkDisplay") & "</a><BR>" & vbcrlf
	else
		response.write obj_RecordSet("LinkDisplay") & "<BR>" & vbcrlf
	end if
	obj_RecordSet.movenext
loop
response.write "<A href='EditTripDetail.asp?ID=" & Request("ID") & "' target='_top'>Edit This Trip</a><BR>" & vbcrlf

obj_RecordSet.close
Set obj_RecordSet = nothing

gls_LogPage int_PageName, request("REMOTE_HOST")
%>
</td>
<!-- The Body cell. -->
<td>
<%
response.write "<h2>High Adventure Trip Detail</h2><br><br>"

str_SQL = "SELECT Trips.TripID, TripLocations.TripLocation, Trips.TripStartDate, Trips.TripEndDate, Trips.Milege, Trips.TripDescription FROM TripLocations INNER JOIN Trips ON TripLocations.TripLocationID = Trips.TripLocationID_fk WHERE Trips.TripID = " & Request("ID")
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table width='100%' border='0'>" 
Do while not obj_RecordSet.eof
	response.write "<h4>Trip Description for " & obj_RecordSet("TripLocation") & " - " & obj_RecordSet("TripStartDate") & " to " & obj_RecordSet("TripEndDate") & "</h4><br><br>"
	response.write "<h6>The icon: <img src='images/ar.gif' alt='' width='7' height='7' border='0' target='_blank'> denotes that a picture is available.</h6>"
	if obj_RecordSet("Milege") > 0 then
		response.write "<tr>"
		response.write "<td>"
		response.write "<b>Miles: </b>" & obj_RecordSet("Milege")
		response.write "</td>"
		response.write "</tr>"
	end if
	response.write "<tr>"
	response.write "<td>"
	response.write replace(obj_RecordSet("TripDescription"),vbcrlf,"<br>")
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>" & vbcrlf	
obj_RecordSet.close
Set obj_RecordSet = nothing
response.write "<br>"
response.write "<br>"
response.write "<h4>Crew Attending</h4><br>"
str_SQL = "SELECT Members.Adult, Members.FirstName, Members.LastName FROM Members INNER JOIN TripBeadMembers ON Members.MemberID = TripBeadMembers.MemberID_fk GROUP BY Members.Adult, Members.FirstName, Members.LastName, TripBeadMembers.TripID_fk HAVING (((TripBeadMembers.TripID_fk)=" & Request("ID") & ")) ORDER BY Members.Adult, Members.FirstName, Members.LastName;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table width='100%' border='0'>" 
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write obj_RecordSet("FirstName") & " " & obj_RecordSet("LastName")
	if obj_RecordSet("Adult") = "Y" then
		response.write " (adult)"
	end if
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>" & vbcrlf	
obj_RecordSet.close
Set obj_RecordSet = nothing

response.write "<br>"
response.write "<h4>Beads Awarded</h4><br>"
str_SQL = "SELECT HighAdventureBeads.BeadColor, HighAdventureBeads.BeadDescription FROM HighAdventureBeads INNER JOIN TripBeadMembers ON HighAdventureBeads.BeadID = TripBeadMembers.BeadID_fk GROUP BY TripBeadMembers.TripID_fk, HighAdventureBeads.BeadColor, HighAdventureBeads.BeadDescription HAVING (((TripBeadMembers.TripID_fk)=" & Request("ID") & ")) order by HighAdventureBeads.BeadColor"  
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table width='100%' border='0'>" 
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write obj_RecordSet("BeadColor") 
	response.write "</td>"
	response.write "<td>"
	response.write obj_RecordSet("BeadDescription") 
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>" & vbcrlf	
obj_RecordSet.close
Set obj_RecordSet = nothing
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>