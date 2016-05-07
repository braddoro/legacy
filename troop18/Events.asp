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
<title>Event List</title>
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
<!-- The List cell. -->
<td width='15%' valign='top'>
<%	
int_PageName = 38
str_SQL = "SELECT LinkURL, LinkDisplay, Target FROM Links WHERE Links.Active='Y' AND " & _
		"PageNameID_fk=" & int_PageName & " or PageNameID_fk = 0 ORDER BY PageNameID_fk, Links.DisplayOrder"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
Do while not obj_RecordSet.eof
	if len(obj_RecordSet("LinkURL")) > 0 then
		response.write "<A href='" & obj_RecordSet("LinkURL") & _
					"' Target='" & obj_RecordSet("Target") & "'>" & _
					obj_RecordSet("LinkDisplay") & "</a><br>"
	else
		response.write obj_RecordSet("LinkDisplay") & "<br>"
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
		'"Where DateDiff('d',Now(),[ActivityStart]) >= 0 " & _
RESPONSE.write "<h2>Events</h2><br>"
'RESPONSE.write "<h5> as of " & now() & "</h5><br><br>"
str_SQL = "SELECT DateDiff('d',Now(),[ActivityStart]) AS DaysOut, Activities.ActivityStart, Activities.ActivityEnd, ActivityTypes.ActivityType, Activities.Activity, Activities.ActivityID, Activities.LastChangeDate, Activities.ActivityDetail " & _
		"FROM ActivityTypes INNER JOIN Activities ON ActivityTypes.ActivityTypeID = Activities.ActivityTypeID_fk " & _
		"Where ActivityStart >= date() and Activities.Active = 'Y' " & _
		"ORDER BY Activities.ActivityStart, Activities.ActivityEnd;"

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString

response.write "<table width='100%' border='0'>" 

	response.write "<tr>"

	response.write "<td>"
	response.write "<strong><em><u>Days Away</u></em></strong>"
	response.write "</td>"

	response.write "<td>"
	response.write "<strong><em><u>Starting</u></em></strong>"
	response.write "</td>"

	response.write "<td>"
	response.write "<strong><em><u>Ending</u></em></strong>"
	response.write "</td>"
	
	response.write "<td>"
	response.write "<strong><em><u>What</u></em></strong>"
	response.write "</td>"
	
	response.write "<td>"
	response.write "<strong><em><u>Where</u></em></strong>"
	response.write "</td>"
	response.write "</tr>"

Do while not obj_RecordSet.eof
	response.write "<tr>"

	response.write "<td><a name='" & obj_RecordSet("ActivityID") & "'>"
	response.write "<A href='EventEdit.asp?ID=" & obj_RecordSet("ActivityID") & "'>"
	If obj_RecordSet("DaysOut") <= 7 then
		response.write "<b>"
	end if
	
	If obj_RecordSet("DaysOut") <= 3 then
		response.write "<font color='red'>"
	End If
	
	If obj_RecordSet("DaysOut") = 0 then
		response.write "today"
	else
		response.write obj_RecordSet("DaysOut") 
	end if
	

	If obj_RecordSet("DaysOut") <= 3 then
		response.write "</font>"
	End If
	
	If obj_RecordSet("DaysOut") <= 7 then
		response.write "</b>"
	end if
	
	if obj_RecordSet("LastChangeDate") > date()-3 then
		response.write " <img src='images/newred.gif' alt='New Information' width='30' height='10' border='0'>"
	end if
	response.write "</a>"
	response.write "</td>"

	response.write "<td>"
	response.write obj_RecordSet("ActivityStart")
	response.write "</td>"

	response.write "<td>"
	response.write obj_RecordSet("ActivityEnd")
	response.write "</td>"
	
	response.write "<td>"
	if Len(trim(obj_RecordSet("ActivityDetail"))) > 0 then
		response.write "<a href='EventDetail.asp?ID=" & obj_RecordSet("ActivityID") & "'>" & obj_RecordSet("ActivityType") & "</a>"
	else
		response.write obj_RecordSet("ActivityType")
	end if
	response.write "</td>"
	
	response.write "<td>"
	response.write obj_RecordSet("Activity")
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