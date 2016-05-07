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
<title>Add News</title>
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
int_PageName = 43
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
RESPONSE.write "<h2>Add News</h2><br><br>"

response.write "<form action='NewsAdd.asp' method='post' name='Add' id='Add'>"
response.write "<table>"

response.write "<tr><td>Title</td><td>"
response.write "<input type='text' name='Title' id='Title' size='80' maxlength='100'>"
response.write "</td</tr>"

response.write "<tr><td>News</td><td>"
response.write "<textarea cols='60' rows='25' name='News' id='News'></textarea>"
response.write "</td></tr>"

response.write "<tr><td>Password</td><td>"
response.write "<input type='password' name='Password' id='Password'><h5>(required to add news)</h5>"
response.write "</td></tr>"

response.write "<tr><td>&nbsp;</td><td>"
response.write "<input type='submit' name='Submit' id='Submit' value='Submit'>"
response.write "</td></tr>"

response.write "</table>"
response.write "</form>"

Dim int_RecordsUpdated
If lcase(request("Password")) = str_Password then
	gls_LogPage int_PageName, request("REMOTE_HOST")
	response.write "<h4>Updating...</h4>"
	str_SQL = "Insert into News (title, news) values('" & _
			glf_SQL_Safe3(request("Title")) & _
			"', '" & glf_SQL_Safe3(request("News")) & "')"
	'response.write str_SQL
	set obj_Command = server.createObject("ADODB.Command")
	obj_Command.ActiveConnection = str_ConnectionString
	obj_Command.CommandText = str_SQL
	obj_Command.Execute int_RecordsUpdated
	set obj_Command = nothing
	if int_RecordsUpdated = 1 then
		response.redirect("News.asp")
	end if
end if
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>