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
<title>Menu Edit</title>
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
int_PageName = 67
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
<h2>Menu Edit</h2><br><br>
<img src="images/swissaf.gif" alt="" width="32" height="32" border="0"><h3>This page is under construction.<img src="images/new2.gif" alt="" width="28" height="14" border="0"></h3>
<%
dim MenuDate
dim MenuID
str_SQL = "SELECT Menu.MenuID, Menu.StartDate, Menu.EndDate, Menu.MenuName, Menu.Password FROM Menu Where Menu.MenuID = " & request("menuid")
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
if not (obj_RecordSet.bof and obj_RecordSet.eof) then
MenuDate = obj_RecordSet("StartDate")
%>
<form action="MenuEdit.asp?sub=m" name="master" id="master">
<input type="hidden" name="MenuID" id="MenuID" value="<% response.write obj_RecordSet("MenuID") %>">
<table>
<tr>
<td>Menu Name</td>
<td><input type="text" name="MenuName" id="MenuName" size="50" maxlength="50" value="<% response.write obj_RecordSet("MenuName") %>"></td>
</tr>
<tr>
<td>Start Date</td>
<td><input type="text" name="StartDate" id="StartDate" size="12" maxlength="12" value="<% response.write MenuDate %>"></td>
</tr>
<tr>
<td>End Date</td>
<td><input type="text" name="EndDate" id="EndDate" size="12" maxlength="12" value="<% response.write obj_RecordSet("EndDate") %>"></td>
</tr>
<tr>
<td>Password</td>
<td><input type="password" name="Password" id="Password" size="15" maxlength="15" value="<% response.write obj_RecordSet("Password") %>"><h5>(You must remember this password to edit this menu.)</h5></td>
</tr>
<tr>
<td>&nbsp;</td>
<td><input type='submit' name='submit_master' id='submit_master' value='Submit'></td>
</tr>
</form>
<%
end if
%>
</table>
<hr width="100%" size="1">
<form action="MenuEdit.asp?sub=d" name="detail" id="detail">
<input type="hidden" name="MenuID" id="MenuID" value="<% response.write obj_RecordSet("MenuID") %>">
<%
str_SQL = "SELECT MenuDetail.MenuDetailID, MenuDetail.MenuID_fk, MenuDetail.MenuDay, MenuDetail.Breakfast, MenuDetail.Lunch, MenuDetail.Supper, MenuDetail.Snack FROM MenuDetail Where MenuDetail.MenuID_fk = " & Request("MenuID") & " ORDER BY MenuDetail.MenuDay"
'response.write str_SQL
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=0>"
response.write "</tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td><b>Day</b></td>"
	response.write "<td align='left' valign='top'>"
	response.write "<input type='text' name='MenuDay' id='MenuDay' size='2' value='" & obj_RecordSet("MenuDay") & "'> <h5>(" & MenuDate & ")</h5>"
	MenuDate = dateadd("d",1,MenuDate)
	response.write "</td>"
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td><b>Breakfast</b></td>"
	response.write "<td align='left' valign='top'>"
	response.write "<textarea cols='60' rows='5' name='Breakfast'>" & replace(obj_RecordSet("Breakfast") & vbnullstring,vbcr,"<br>") & "</textarea>"
	response.write "</td>"
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td><b>Lunch</b></td>"
	response.write "<td align='left' valign='top'>"
	response.write "<textarea cols='60' rows='5' name='Lunch'>" & replace(obj_RecordSet("Lunch") & vbnullstring,vbcr,"<br>") & "</textarea>"
	response.write "</td>"
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td><b>Supper</b></td>"
	response.write "<td align='left' valign='top'>"
	response.write "<textarea cols='60' rows='5' name='Supper'>" & replace(obj_RecordSet("Supper") & vbnullstring,vbcr,"<br>") & "</textarea>"
	response.write "</td>"
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td><b>Snack</b></td>"
	response.write "<td align='left' valign='top'>"
	response.write "<textarea cols='60' rows='5' name='Snack'>" & replace(obj_RecordSet("Snack") & vbnullstring,vbcr,"<br>") & "</textarea>"
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close
response.write "<tr>"
response.write "<td>&nbsp;</td>"
response.write "<td><input type='submit' name='submit_detail' id='submit_detail' value='Submit'></td>"
response.write "</tr>"

response.write "</table>"
%>
</form>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>