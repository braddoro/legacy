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
<title>High Adventure</title>
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
int_PageName = 51
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
<h2>High Adventure Home</h2><br><br>
<h4>The Outdoor Code</h4><br>
<strong>As an American, I will do my best to:</strong>
<br>
Be clean in my outdoor manners.<br>
Be careful with fire.<br>
Be considerate in the outdoors.<br>
Be conservation minded.<br>
<br>
<h4>High Adventure Prerequisites</h4><br>
The High Adventure patrol is designed for experienced scouts who are ready both mentally and physically to challenge themselves with outings that take scouting to the “next level” in a team setting.  The following requirements are in place to ensure that each scout is ready to partake in high adventure activities.
<br><br>
In order to participate in the high adventure patrol, each scout must first:<br>
<li>Achieve the rank of Star</li>
<li>Attend 1 long term campout</li>
<li>Complete 2 years in Scouting</li>
<li>Demonstrate fundamental camping knowledge by attending a troop campout where the scout must camp and eat individually using gear that he will use on high adventure campouts</li>
<li>Have approval of the Scoutmaster</li>
<li>Serve the troop in some form of leadership</li>
<li>Turn in the required medical forms</li>
<br><br>

<%
str_SQL = "SELECT TripID, TripLocationID_fk, TripLocation, TripStartDate, TripEndDate FROM TripLocations INNER JOIN Trips ON TripLocations.TripLocationID = Trips.TripLocationID_fk Order by TripStartDate DESC"

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<BR>"
response.write "<h4>Past High Adventure Outings</h4>" 
response.write "<table width='100%' border='0'>" 
Do while not obj_RecordSet.eof
	response.write "<tr><td><a href='TripDetail.asp?ID=" & obj_RecordSet("TripID") & "'>"
	response.write obj_RecordSet("TripLocation") & " ("
	response.write obj_RecordSet("TripStartDate") & " - "
	response.write obj_RecordSet("TripEndDate") & ")"
	response.write "</a></td></tr>"

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




















