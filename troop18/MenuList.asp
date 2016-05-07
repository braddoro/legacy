<%@ Language=VBScript %>
<%Option Explicit %>
<%Response.Buffer = True%>
<!-- 
COPYRIGHT NOTICE. 
All rights reserved. Any rights not expressly granted are reserved.
Copyright © 2002 Crucible Systems
-->
<!-- #Include file="includes/connection.asp" 			-->
<!-- #Include file="includes/library.asp"				-->
<html>
<head>
<title>Menu Detail</title>
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
int_PageName = 64
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
<h2>Menu List</h2><br><br>
<%
str_SQL = "SELECT Menu.MenuID, Menu.StartDate, Menu.EndDate, Menu.MenuName, Menu.EditDate, Menu.CreateDate FROM Menu ORDER BY Menu.StartDate, Menu.MenuName"

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=0>"
response.write "<tr>"
response.write "<th>Menu Name</th>"
response.write "<th>Start Date</th>"
response.write "<th>End Date</th>"
response.write "</tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write	"<a href='MenuDetail.asp?id=" & obj_RecordSet("MenuID") & "'>" & obj_RecordSet("MenuName") & "</a>"
	response.write "</td>"
	response.write "<td>"
	response.write	obj_RecordSet("StartDate")
	response.write "</td>"
	response.write "<td>"
	response.write	obj_RecordSet("EndDate")
	response.write "</td>"
	response.write "<td>"
	if obj_RecordSet("CreateDate") > date()-3 then
		response.write " <img src='images/newred.gif' alt='created: " & obj_RecordSet("CreateDate") & "' width='30' height='10' border='0'>"
	else
		response.write "&nbsp;"
	end if
	if obj_RecordSet("EditDate") > date()-3 then
		response.write " <img src='images/icon1.gif' alt='modified: " & obj_RecordSet("EditDate") & "' width='14' height='14' border='0'>"
	else
		response.write "&nbsp;"
	end if
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close
response.write "</table>"
%>
<br>
<h5>
<b>Menu Legend</b><br>
Recently Created: <img src='images/newred.gif' width='30' height='10' border='0'><br>
Recently Modified: <img src='images/icon1.gif' width='14' height='14' border='0'><br>
</h5
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>