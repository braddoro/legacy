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
<title>Patrol</title>
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
int_PageName = 72
gls_LogPage int_PageName, request("REMOTE_HOST")
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
%>
</td>
<!-- The Body cell. -->
<td>
<%
Dim str_PatrolName
dim str_PatrolPassword
dim str_PatrolImage
dim str_PatrolLeader
dim str_PatrolEmail
dim str_PatrolDate
str_SQL = "Select PatrolDate, PatrolName, PatrolImage, PatrolLeaderEmail, PatrolLeader, PatrolPassword from Patrols where PatrolID = " & request("ID")
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
Do while not obj_RecordSet.eof
	str_PatrolName = obj_RecordSet("PatrolName")
	str_PatrolPassword = obj_RecordSet("PatrolPassword")
	str_PatrolImage = obj_RecordSet("PatrolImage")
	str_PatrolLeader = obj_RecordSet("PatrolLeader")
	str_PatrolEmail = obj_RecordSet("PatrolLeaderEmail")
	str_PatrolDate = obj_RecordSet("PatrolDate")
	obj_RecordSet.movenext
loop

if not session("PatrolName") = str_PatrolName then
	response.write "You are not authorized to access this page."
	response.end
end if
obj_RecordSet.close
response.write "<center>"
response.write "<img src='" & str_PatrolImage & "' alt='' width='150' height='150' border='0'>" & "<br>"
response.write "<h2>" & str_PatrolName & " Patrol</h2><br>"
if len(str_PatrolEmail) > 0 then
	response.write "<h4>Patrol Leader: <a href='mailto:" & str_PatrolEmail & "'>" & str_PatrolLeader & "</a></h4><br>"
else
	response.write "<h4>Patrol Leader: " & str_PatrolLeader & "</a></h4><br>"
end if
response.write "<h6>Patrol active since: " & formatdatetime(str_PatrolDate,2) & "</h6><br>"

response.write "</center>"
response.write "<br>"
If request("Submit") = "Submit" then
	'if lcase(request("Password")) = lcase(str_PatrolPassword) then
		if len(request("AddMessage")) > 0 then
			Dim int_RecordsUpdated
			str_SQL = "Insert into Messages (PatrolID_fk, Sender, Message) values(" & _
					request("ID") & ",'" & request("From") & "','" & glf_SQL_Safe3(request("AddMessage")) & "')"
			'response.write str_SQL
			set obj_Command = server.createObject("ADODB.Command")
			obj_Command.ActiveConnection = str_ConnectionString
			obj_Command.CommandText = str_SQL
			obj_Command.Execute int_RecordsUpdated
			set obj_Command = nothing
			if int_RecordsUpdated = 1 then
				gls_LogPage 75, request("REMOTE_HOST")
				response.redirect("patrol.asp?ID=" & request("ID"))
			else
				response.write str_SQL
			end if
		else
			response.write "<br><h4>Enter a new message before chosing submit.</h4><br>"
		end if
	'else
	'	response.write "<br><h4>Incorrect Password</h4><br>"
	'end if
end if
response.write "<h2>Messages</h2><br>"
str_SQL = "Select * from Messages where PatrolID_fk = " & request("ID") & " and SentDate > now()-30 Order by SentDate desc"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border='0'>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<th>"
	response.write obj_RecordSet("SentDate")
	if len(obj_RecordSet("Sender")) > 0 then
		response.write " :: <b>From: " & obj_RecordSet("Sender") & "</b>"
	end if
	response.write "</th>"

	response.write "<tr>"
	response.write "<td>"
	response.write replace(obj_RecordSet("Message"),vbcrlf, "<br>")
	response.write "</td>"

	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>"
obj_RecordSet.close
%>
<hr width="100%" size="1">
<form action='Patrol.asp' method='post' name='AddNews' id='AddNews'>
<input type='hidden' name='ID' id='ID' value='<% response.write request("ID") %>'>
<table bgcolor="#C0C0C0">
<tr><th><b>From</b> <input type='text' name='From' id='From' value='' size='15' maxlength='30'></th></tr>
<tr><th><b>New Message</b></th></tr>
<tr><th><textarea cols='60' rows='8' name='AddMessage' id='AddMessage'></textarea></th></tr>
<!-- <tr><th><b>Password</b> <input type='password' name='Password' id='Password' size='15' maxlength='15'></th></tr> -->
<tr><th><input type='submit' name='Submit' id='Submit' value='Submit'></th></tr>
</table>
</form>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>