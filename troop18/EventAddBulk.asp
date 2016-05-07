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
int_PageName = 44
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
obj_RecordSet.close
Set obj_RecordSet = nothing
%>
</td>
<!-- The Body cell. -->
<td>
<%
RESPONSE.write "<h2>Add Event</h2><br><br>" & vbcrlf

response.write "<form action='EventAddBulk.asp' name='Add' id='Add'>" & vbcrlf
response.write "<table>" & vbcrlf

response.write "<tr><td>Start Date/Time</td><td>" & vbcrlf
response.write "<input type='text' name='Start' id='Start' value=" & request("Start") & "><h5>(format: mm/dd/yyy hh:mm)</h5>" & vbcrlf
response.write "</td</tr>" & vbcrlf

response.write "<tr><td>End Date/Time</td><td>" & vbcrlf
response.write "<input type='text' name='End' id='End'><h5>(format: mm/dd/yyy hh:mm)</h5>" & vbcrlf
response.write "</td</tr>" & vbcrlf

response.write "<tr><td>Activity Type</td><td>" & vbcrlf
response.write "<select name='ActivityType'>" & vbcrlf
str_SQL = "Select ActivityTypeID, ActivityType from ActivityTypes where Active = 'Y' Order by ActivityType"
set obj_SelectBox = server.createObject("ADODB.Recordset")
obj_SelectBox.Open str_SQL, str_ConnectionString
Do while not obj_SelectBox.eof
	response.write "<option value='" & obj_SelectBox("ActivityTypeID") & "'>" & obj_SelectBox("ActivityType") & "</option>" & vbcrlf
	obj_SelectBox.movenext
loop
obj_SelectBox.close
Set obj_SelectBox = nothing
response.write "</select>" & vbcrlf
response.write "</td></tr>" & vbcrlf

response.write "<tr><td>Activity Location</td><td>" & vbcrlf
response.write "<input type='text' name='Activity' id='Activity' size='60' maxlength='100'>" & vbcrlf
response.write "</td></tr>" & vbcrlf

response.write "<tr><td>Activity Detail</td><td>" & vbcrlf
response.write "<textarea cols='60' rows='10' name='ActivityDetail'></textarea>" & vbcrlf
response.write "</td></tr>" & vbcrlf

response.write "<tr><td>&nbsp;</td><td>" & vbcrlf
response.write "<input type='submit' name='Submit' id='Submit' value='Submit'>" & vbcrlf
response.write "</td></tr>" & vbcrlf

response.write "</table>" & vbcrlf
response.write "</form>" & vbcrlf

Dim int_RecordsUpdated
If len(request("submit")) > 0 then
	gls_LogPage int_PageName, request("REMOTE_HOST")
	response.write "<h4>Adding...</h4>"
	str_SQL = "Insert into Activities (ActivityTypeID_fk, Activity, ActivityStart, ActivityEnd, ActivityDetail) values("
	str_SQL = str_SQL & "" & request("ActivityType") & ", "
	str_SQL = str_SQL & "'" & glf_SQL_Safe3(request("Activity")) & "', "
	if isdate(request("Start")) then
		str_SQL = str_SQL & "#" & request("Start") & "#, "
	else
		str_SQL = str_SQL & "NULL, "
	end if
	if isdate(request("End")) then
		str_SQL = str_SQL & "#" & request("End") & "#, "
	else
		str_SQL = str_SQL & "NULL, "
	end if
	str_SQL = str_SQL & "'" & glf_SQL_Safe3(request("ActivityDetail")) & "')"
	
			glf_SQL_Safe3(request("Title")) & _
			"', '" & glf_SQL_Safe3(request("News")) & "')"
	'response.write str_SQL
	set obj_Command = server.createObject("ADODB.Command")
	obj_Command.ActiveConnection = str_ConnectionString
	obj_Command.CommandText = str_SQL
	obj_Command.Execute int_RecordsUpdated
	set obj_Command = nothing
	if int_RecordsUpdated = 1 then
		response.redirect("EventAddBulk.asp")
	end if
end if

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

	response.write "<td>"
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
		response.write " <img src='images/updated.gif' alt='New Information' width='52' height='15' border='0'>"
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