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
<title></title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
dim Authorized
dim str_SQL
dim obj_RecordSet
dim int_PageName

int_PageName = 74
gls_LogPage int_PageName, request("REMOTE_HOST")

Authorized = false
session("PatrolName") = ""
if request("PID") > 0 then
	if len(request("pwd")) > 0 then
		str_SQL = "SELECT Patrols.PatrolName FROM Patrols WHERE Patrols.PatrolPassword='" & request("pwd") & "' AND Patrols.PatrolID=" & request("PID") & " AND Patrols.Active='Y'"
		set obj_RecordSet = server.createObject("ADODB.Recordset")
		obj_RecordSet.Open str_SQL, str_ConnectionString
		Do while not obj_RecordSet.eof
			session("PatrolName") = obj_RecordSet("PatrolName")
			Authorized = true
			obj_RecordSet.movenext
		loop
		obj_RecordSet.close
		
		if Authorized then
			response.redirect("patrol.asp?id=" & request("PID") & "")
		'else 
			'response.redirect("password.asp")
		end if
	end if
'	else
		response.write "<a href='patrolpages.asp'>back to the patrol page</a><br>"
		response.write "<form action='password.asp' method='post' name='password' id='password'>"
		response.write "<input type='hidden' name='PID' id='PID' value='" & request("PID") & "'>"
		response.write "Enter your patrols password:<br>"
		response.write "<input type='text' name='pwd' id='pwd' value='" & request("pwd") & "' size='15' maxlength='15'> <img src='/images/folder_lock.gif' alt='private' border='0'><br>"
		response.write "<input type='submit' name='Submit' id='Submit' value='Submit'>"
		response.write "</form>"
'	end if
end if
%>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>