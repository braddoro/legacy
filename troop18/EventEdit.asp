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
int_PageName = 48
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
RESPONSE.write "<h2>Edit Event</h2><br><br>" & vbcrlf

str_SQL = "SELECT DateDiff('d',Now(),[ActivityStart]) AS DaysOut, Activities.ActivityStart, Activities.ActivityEnd, ActivityTypes.ActivityType, Activities.Activity, Activities.ActivityID, ActivityTypeID, Activities.ActivityDetail, Activities.Active " & _
		"FROM ActivityTypes INNER JOIN Activities ON ActivityTypes.ActivityTypeID = Activities.ActivityTypeID_fk " & _
		"Where ActivityID = " & request("ID")

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
do while not obj_RecordSet.eof

	response.write "<form action='EventEdit.asp' method='post' name='Add' id='Add'>" & vbcrlf
	response.write "<input type='hidden' name='ID' id='ID' value='" & obj_RecordSet("ActivityID") & "'>"
	response.write "<table>" & vbcrlf
	
	response.write "<tr><td>Start Date/Time</td><td>" & vbcrlf
	response.write "<input type='text' name='Start' id='Start' value='" & obj_RecordSet("ActivityStart") & "'><h5>(format: mm/dd/yyy hh:mm)</h5>" & vbcrlf
	response.write "</td</tr>" & vbcrlf
	
	response.write "<tr><td>End Date/Time</td><td>" & vbcrlf
	response.write "<input type='text' name='End' id='End' value='" & obj_RecordSet("ActivityEnd") & "'><h5>(format: mm/dd/yyy hh:mm)</h5>" & vbcrlf
	response.write "</td</tr>" & vbcrlf
	
	response.write "<tr><td>Activity Type</td><td>" & vbcrlf
	response.write "<select name='ActivityType'>" & vbcrlf
	str_SQL = "Select ActivityTypeID, ActivityType from ActivityTypes where Active = 'Y' Order by ActivityType"
	set obj_SelectBox = server.createObject("ADODB.Recordset")
	obj_SelectBox.Open str_SQL, str_ConnectionString
	Do while not obj_SelectBox.eof
		if obj_SelectBox("ActivityTypeID") = obj_RecordSet("ActivityTypeID") then
			response.write "<option value='" & obj_SelectBox("ActivityTypeID") & "' SELECTED>" & obj_SelectBox("ActivityType") & "</option>" & vbcrlf
		else
			response.write "<option value='" & obj_SelectBox("ActivityTypeID") & "'>" & obj_SelectBox("ActivityType") & "</option>" & vbcrlf
		end if
		
		obj_SelectBox.movenext
	loop
	obj_SelectBox.close
	Set obj_SelectBox = nothing
	response.write "</select>" & vbcrlf
	response.write "</td></tr>" & vbcrlf
	
	response.write "<tr><td>Activity Location</td><td>" & vbcrlf
	response.write "<input type='text' name='Activity' id='Activity' size='60' maxlength='100' value='" & obj_RecordSet("Activity") & "'>" & vbcrlf
	response.write "</td></tr>" & vbcrlf
	
	response.write "<tr><td>Activity Detail</td><td>" & vbcrlf
	response.write "<textarea cols='60' rows='10' name='ActivityDetail'>" & obj_RecordSet("ActivityDetail") & "</textarea>" & vbcrlf
	response.write "</td></tr>" & vbcrlf
	
	response.write "<tr><td>Show Event</td><td>" & vbcrlf
		if ucase(obj_RecordSet("Active")) = "Y" then
		response.write "<input type='checkbox' name='Active' id='Active' value='Y' CHECKED>" & vbcrlf
	else
		response.write "<input type='checkbox' name='Active' id='Active' value='Y'>" & vbcrlf
	end if
	response.write "<h5>(no checkmark permanently removes event from list)</h5"
	response.write "</td></tr>" & vbcrlf
	
	response.write "<tr><td>Password</td><td>" & vbcrlf
	response.write "<input type='password' name='Password' id='Password' value='" & request("password") & "'><h5>(required to update events)</h5>" & vbcrlf
	response.write "</td></tr>" & vbcrlf
	
	response.write "<tr><td>&nbsp;</td><td>" & vbcrlf
	response.write "<input type='submit' name='Submit' id='Submit' value='Submit'>" & vbcrlf
	response.write "</td></tr>" & vbcrlf
	
	response.write "</table>" & vbcrlf
	response.write "</form>" & vbcrlf
	
	obj_RecordSet.movenext
Loop
	
Dim int_RecordsUpdated
If lcase(request("Password")) = str_Password then
	gls_LogPage int_PageName, request("REMOTE_HOST")
	response.write "<h4>Updating...</h4>"
	str_SQL = "Update Activities set "
	str_SQL = str_SQL & "ActivityTypeID_fk = " & request("ActivityType") & ", "
	str_SQL = str_SQL & "ActivityDetail = '" & glf_SQL_Safe3(request("ActivityDetail")) & "', "
	str_SQL = str_SQL & "Activity = '" & glf_SQL_Safe3(request("Activity")) & "', "
	if isdate(request("Start")) then 
		str_SQL = str_SQL & "ActivityStart = #" & request("Start") & "#, "
	end if
	if isdate(request("End")) then 
		str_SQL = str_SQL & "ActivityEnd = #" & request("End") & "#, "
	end if
	str_SQL = str_SQL & "Active = '" & request("Active") & "', "
	str_SQL = str_SQL & "LastChangeDate = #" & now() & "# "
	str_SQL = str_SQL & "Where ActivityID = " & request("ID")
	'response.write str_SQL
	
	set obj_Command = server.createObject("ADODB.Command")
	obj_Command.ActiveConnection = str_ConnectionString
	obj_Command.CommandText = str_SQL
	obj_Command.Execute int_RecordsUpdated
	set obj_Command = nothing
	if int_RecordsUpdated = 1 then
		response.redirect("Events.asp")
	end if
end if
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>	