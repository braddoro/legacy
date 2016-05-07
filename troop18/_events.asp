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
<title>New Scout Events</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim X
%>
<table border='0'>
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
<!-- The Body cell. -->
<td>
<%
Response.write "<h2>New Scout Plan</h2> <a href='eventadd.asp?ActivityType=17'><img src='images/newred.gif' alt='' width='30' height='10' border='0'></a><br>"
str_SQL = "Select ActivityID, Activity, ActivityStart, ActivityEnd, ActivityDetail from Activities where ActivityTypeID_fk = 17 and Active = 'Y' order by ActivityStart"

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString

response.write "<table width='100%' border='0'>" 
response.write "<tr>"
response.write "<th>Date</th><th>Location</th><th>Activity</th>"
response.write "</tr>"
do while not obj_RecordSet.eof
	response.write "<tr>"

	response.write "<td valign='top'>"
	response.write obj_RecordSet("ActivityStart")
	if len(obj_RecordSet("ActivityEnd"))  > 0 then
		response.write " - " & obj_RecordSet("ActivityEnd")
	end if
	response.write "</td>"

	response.write "<td valign='top'>"
	response.write obj_RecordSet("Activity")
	response.write "<a href='EventEdit.asp?ID=" & obj_RecordSet("ActivityID") & "'>"
	response.write " <img src='images/ico_entente.jpg' alt='' width='19' height='19' border='0'>"
	response.write "</a>"
	response.write "</td>"

	response.write "<td>"
	response.write replace(replace(obj_RecordSet("ActivityDetail"),vbcrlf,"<br>"),"`","'")
	response.write "</td>"

	response.write "</tr>"
	
	response.write "<tr>"
	response.write "<td colspan='3'>"
	response.write "<HR>"
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
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0">
</body>
</html>