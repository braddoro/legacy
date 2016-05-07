<%@ Language=VBScript %>
<%Option Explicit %>
<%Response.Buffer = True%>
<!-- #Include file="includes/connection.asp" 			-->
<!-- #Include file="includes/library.asp"				-->
<!-- 
COPYRIGHT NOTICE. 
All rights reserved. Any rights not expressly granted are reserved.
Copyright � 2002 Crucible Systems
-->
<html>
<head>
<title>Counselors</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
dim CurrMB
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
int_PageName = 76
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
<h2>Merit Badge Councilors</h2><br>
<%
str_SQL = "SELECT MeritBadgeBooks.MeritBadgeBook, Required, Members.FirstName, Members.LastName FROM Members INNER JOIN (MeritBadgeBooks INNER JOIN Councilors ON MeritBadgeBooks.MeritBadgeBookID = Councilors.MeritBadgeID_fk) ON Members.MemberID = Councilors.MemberID_fk ORDER BY MeritBadgeBooks.MeritBadgeBook, Members.FirstName, Members.LastName;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	if CurrMB = obj_RecordSet("MeritBadgeBook") then
		response.write "<td>&nbsp;</td>"
	else
		response.write "<td><b>" & obj_RecordSet("MeritBadgeBook") & "</b>"
		if obj_RecordSet("Required") = "Y" then
			response.write "<img src='images/f-d-l.gif' alt='Eagle Required' width='19' height='18' border='0'>"
		end if
		response.write "</td>"
	end if
	
	response.write "<td>" & obj_RecordSet("FirstName") & " " & obj_RecordSet("LastName")& "</td>"
	response.write "</tr>"
	CurrMB = obj_RecordSet("MeritBadgeBook")
	obj_RecordSet.movenext
loop
response.write "</table>"
response.write "<br><img src='images/f-d-l.gif' alt='Eagle Required' width='19' height='18' border='0'> Denotes Eagle Required Merit Badge"
obj_RecordSet.close
%>
<br>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>