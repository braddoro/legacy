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
<title>Books On Loan</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
dim int_RecordsUpdated
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
int_PageName = 61
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
RESPONSE.write "<h2>Troop Members</h2>"
str_SQL = "SELECT Members.FirstName+' ' +Members.LastName as Member, Members.HighAdventureCrew, Members.Active, Members.Adult FROM Members ORDER BY Members.FirstName, Members.LastName;"
'response.write str_SQL
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=0>"
response.write "<tr>"
response.write "</tr>"
Do while not obj_RecordSet.eof

	response.write "<tr>"
	
	response.write "<td>"
	response.write obj_RecordSet("Member")
	if obj_RecordSet("Adult") = "Y" then
		response.write " (Adult)"
	end if
	response.write "</td>"

	response.write "</tr>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close
response.write "</table>"
%>

<form action='TroopMembers.asp' name='Add' id='Add'>
<h3>Add New Member</h3>
<table>
<tr><td>First Name</td><td><input type='text' name='FirstName' id='FirstName' size='15' maxlength='15' value='<% response.write request("FirstName") %>'></td></tr>
<tr><td>Last Name</td><td><input type='text' name='LastName' id='LastName' size='15' maxlength='15' value='<% response.write request("LastName") %>'></td></tr>
<tr><td>Password</td><td><input type='password' name='Password' id='Password'> <h5>(required to add)</h5></td></tr>
<tr><td>&nbsp;</td><td><input type='submit' name='submit' id='submit' value='submit'></td></tr>
</table>
</form>
<%
If lcase(request("Password")) = str_Password then
	str_SQL = "Insert into Members (FirstName, LastName) values('" & request("FirstName") & "', '" & request("LastName") & "')"
	'response.write str_SQL
	set obj_Command = server.createObject("ADODB.Command")
	obj_Command.ActiveConnection = str_ConnectionString
	obj_Command.CommandText = str_SQL
	obj_Command.Execute int_RecordsUpdated
	if not int_RecordsUpdated = 1 then
		response.write "Error: " & int_RecordsUpdated & "<BR><BR>"
		response.write str_SQL & "<BR><BR>"
		response.write request.querystring
	else
		response.write "Member Added<br>"
	end if
	set obj_Command = nothing
end if
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>