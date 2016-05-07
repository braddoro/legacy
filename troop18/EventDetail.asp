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
<title>Event Detail</title>
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
int_PageName = 42
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
RESPONSE.write "<h2>Event Detail</h2><br><br>"
str_SQL = "SELECT DateDiff('d',Now(),[ActivityStart]) AS DaysOut, Activities.ActivityStart, Activities.ActivityEnd, ActivityTypes.ActivityType, Activities.Activity, Activities.ActivityID, Activities.ActivityDetail " & _
		"FROM ActivityTypes INNER JOIN Activities ON ActivityTypes.ActivityTypeID = Activities.ActivityTypeID_fk " & _
		"Where ActivityID = " & Request("ID") 

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString

response.write "<table width='100%' border='0'>" 
Do while not obj_RecordSet.eof
	'response.write "<tr>"
	'response.write "<td valign='top'>"
	'response.write "<strong><em><u>Days Away</u></em></strong>"
	'response.write "</td>"
	'response.write "<td>"
	'response.write obj_RecordSet("DaysOut")
	'response.write "</td>"
	'response.write "</tr>"
	
	response.write "<tr>"
	response.write "<td valign='top'>"
	response.write "<strong><em><u>Date</u></em></strong>"
	response.write "</td>"
	
	response.write "<td>"
	if len(obj_RecordSet("ActivityEnd")) > 0 then
		response.write obj_RecordSet("ActivityStart") & " to " & obj_RecordSet("ActivityEnd")
	else
		response.write obj_RecordSet("ActivityStart")
	end if
	response.write "</td>"
	response.write "</tr>"
	
	response.write "<tr>"
	response.write "<td valign='top'>"
	response.write "<strong><em><u>What</u></em></strong>"
	response.write "</td>"
	
	response.write "<td>"
	response.write obj_RecordSet("ActivityType") & " at " & obj_RecordSet("Activity")
	response.write "</td>"
	response.write "</tr>"
	
	response.write "<tr>"
	response.write "<td>&nbsp;</td>"
	response.write "</td>"
	
	response.write "<tr>"
	response.write "<td valign='top'>"
	response.write "<strong><em><u>More Info</u></em></strong>"
	response.write "</td>"
	
	response.write "<td>"
	response.write replace(replace(obj_RecordSet("ActivityDetail"),vbcrlf,"<br>"),"`","'")
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