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
<title>Links</title>
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
int_PageName = 36
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
RESPONSE.write "<h2>Links</h2><br><br>"
Dim str_CurrCategory
str_SQL = "SELECT LinkCategories.DisplayOrder, Links.DisplayOrder, LinkCategories.LinkCategory, Links.LinkID, Links.LinkURL, Links.Target, Links.LinkDisplay, Users.UserName, Links.AddedDate, Links.PageNameID_fk " & _
		"FROM Users INNER JOIN (LinkCategories INNER JOIN Links ON LinkCategories.LinkCategoryID = Links.LinkCategoryID_fk) ON Users.UserID = Links.UserID_fk " & _
		"WHERE Links.Active='Y' AND Links.PageNameID_fk= 37 " & _
		"ORDER BY LinkCategories.DisplayOrder, Links.DisplayOrder"

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
Do while not obj_RecordSet.eof
	
	'====================================================================================
	' Are we on the same link category that we have been on?
	'====================================================================================
	if not str_CurrCategory = obj_RecordSet("LinkCategory") then
	
		'================================================================================
		' We are on a new link category so update our category placeholder and print out
		' the new heading.
		'================================================================================
		str_CurrCategory = obj_RecordSet("LinkCategory")
		response.write "<br><strong>" & str_CurrCategory & "</strong><br>"
	end if
	
	if obj_RecordSet("AddedDate") > (now() - 7) then
		response.write "<A href='" & obj_RecordSet("LinkURL") & _
				"' title='" & obj_RecordSet("DisplayOrder") & "'" & _
				"' Target='" & obj_RecordSet("Target") & "'>" & _
				obj_RecordSet("LinkDisplay") & _
				"</a> <img src='images/new2.gif' alt='' width='28' height='14' border='0' align='bottom'>" & _
				"<BR>"
				'"<font color = '#8FA2CC' size =1> Added By " & obj_RecordSet("UserName") & "</font><BR>"
	else
		response.write "<A href='" & obj_RecordSet("LinkURL") & _
				"' title='" & obj_RecordSet("DisplayOrder") & "'" & _
				"' Target='" & obj_RecordSet("Target") & "'>" & _
				obj_RecordSet("LinkDisplay") & "</a><BR>"
	end if
	obj_RecordSet.movenext
loop
obj_RecordSet.close
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>