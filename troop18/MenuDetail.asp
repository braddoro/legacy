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
int_PageName = 65
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
<h2>Menu Detail</h2><br><br>
<%
dim MenuDate
dim MenuID
str_SQL = "SELECT MenuDetail.MenuDetailID, Menu.MenuID, Menu.MenuName, Menu.Password, Menu.StartDate, Menu.EndDate, Menu.CreateDate, MenuDetail.MenuDetailID, MenuDetail.MenuDay, MenuDetail.Breakfast, MenuDetail.Lunch, MenuDetail.Supper, MenuDetail.Snack FROM Menu INNER JOIN MenuDetail ON Menu.MenuID = MenuDetail.MenuID_fk Where Menu.MenuID = " & Request("ID") & " ORDER BY Menu.StartDate, Menu.MenuName, MenuDetail.MenuDay"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=0>"
if not (obj_RecordSet.bof and obj_RecordSet.eof) then
	response.write "<tr>"
	response.write "<td><h3>" & obj_RecordSet("MenuName") & "</h3></td>" 
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td>Start Date: " & obj_RecordSet("StartDate") & "</td>"
	MenuDate = obj_RecordSet("StartDate")	
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td>End Date: " & obj_RecordSet("EndDate") & "</td>"
	response.write "</tr>"
	response.write "</table>"
	response.write "<br>"
	response.write "<table border=0>"
	response.write "<tr>"
	response.write "<th>Date</th>" 
	MenuID = obj_RecordSet("MenuID")
	response.write "<th>Breakfast</th>"
	response.write "<th>Lunch</th>"
	response.write "<th>Supper</th>"
	response.write "<th>Snack</th>"
	response.write "</tr>"
end if
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td align='left' valign='top'><b>"
	response.write "<a href='MenuEdit.asp?id=" & obj_RecordSet("MenuID") & "&Menuid=" & obj_RecordSet("MenuDetailID") & "'><h5>" & MenuDate & "</h5></a>"
	MenuDate = dateadd("d",1,MenuDate)
	response.write "</b></td>"
	response.write "<td align='left' valign='top'>"
	response.write replace(obj_RecordSet("Breakfast") & vbnullstring,vbcr,"<br>")
	response.write "</td>"
	response.write "<td align='left' valign='top'>"
	response.write replace(obj_RecordSet("Lunch") & vbnullstring,vbcr,"<br>")
	response.write "</td>"
	response.write "<td align='left' valign='top'>"
	response.write replace(obj_RecordSet("Supper") & vbnullstring,vbcr,"<br>")
	response.write "</td>"
	response.write "<td align='left' valign='top'>"
	response.write replace(obj_RecordSet("Snack") & vbnullstring,vbcr,"<br>")
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close
response.write "</table>"
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>