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
response.write "<a href='MenuDetail.asp?id=" & request("id") &"'>Menu Detail</a><br>"
%>
</td>
<!-- The Body cell. -->
<td>
<h2>Menu Edit</h2><br><br>
<!-- <img src="images/swissaf.gif" alt="" width="32" height="32" border="0"><h3>This page is under construction.<img src="images/new2.gif" alt="" width="28" height="14" border="0"></h3> -->
<%
if lcase(request("submit")) = "submit" then
	Dim int_RecordsUpdated
	Dim str_DBpassword
	
	str_SQL = "SELECT Menu.Password FROM Menu Where Menu.MenuID = " & request("ID")
	set obj_RecordSet = server.createObject("ADODB.Recordset")
	obj_RecordSet.Open str_SQL, str_ConnectionString
	if not (obj_RecordSet.bof and obj_RecordSet.eof) then
		str_DBpassword = lcase(obj_RecordSet("Password"))
	end if

	if str_DBpassword = lcase(trim(request("Password"))) then
	
		gls_LogPage int_PageName, request("REMOTE_HOST")
		str_SQL = "Update MenuDetail set "
		str_SQL = str_SQL & "Breakfast = '" & glf_SQL_Safe3(request("Breakfast")) & "', "
		str_SQL = str_SQL & "Lunch = '" & glf_SQL_Safe3(request("Lunch")) & "', "
		str_SQL = str_SQL & "Supper = '" & glf_SQL_Safe3(request("Supper")) & "', "
		str_SQL = str_SQL & "Snack = '" & glf_SQL_Safe3(request("Snack")) & "', "
		str_SQL = str_SQL & "UpdatedDate = #" & now() & "# "
		str_SQL = str_SQL & "Where MenuDetailID = " & request("MenuID")
		'response.write str_SQL
		
		set obj_Command = server.createObject("ADODB.Command")
		obj_Command.ActiveConnection = str_ConnectionString
		obj_Command.CommandText = str_SQL
		obj_Command.Execute int_RecordsUpdated
		set obj_Command = nothing
		if int_RecordsUpdated = 1 then
		
			str_SQL = "Update Menu set EditDate = #" & now() & "# Where menuID = " & request("ID")
			'response.write str_SQL
			set obj_Command = server.createObject("ADODB.Command")
			obj_Command.ActiveConnection = str_ConnectionString
			obj_Command.CommandText = str_SQL
			obj_Command.Execute int_RecordsUpdated
			set obj_Command = nothing
	
			'response.redirect("MenuDetail.asp?id=" & request("id"))
		end if
	else
		response.write "<h4>Invalid Password</h4>"
	end if
end if

dim MenuDate
dim MenuID
str_SQL = "SELECT Menu.MenuID, Menu.StartDate, Menu.EndDate, Menu.MenuName, Menu.Password FROM Menu Where Menu.MenuID = " & request("ID")
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
if not (obj_RecordSet.bof and obj_RecordSet.eof) then
	MenuDate = obj_RecordSet("StartDate")
end if
%>
<form action="MenuEdit.asp" name="edit" id="edit">
<input type="hidden" name="ID" id="ID" value="<% response.write request("ID") %>">
<%
str_SQL = "SELECT MenuDetail.MenuDetailID, MenuDetail.MenuID_fk, MenuDetail.MenuDay, MenuDetail.Breakfast, MenuDetail.Lunch, MenuDetail.Supper, MenuDetail.Snack FROM MenuDetail Where MenuDetail.MenuDetailID = " & Request("MenuID") & " ORDER BY MenuDetail.MenuDay"
'response.write str_SQL
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=0>"
response.write "</tr>"
Do while not obj_RecordSet.eof
	response.write "<input type='hidden' name='MenuID' id='MenuID' value='" & obj_RecordSet("MenuDetailID") & "'>"
	response.write "<tr>"
	response.write "<td><b>Day</b></td>"
	response.write "<td align='left' valign='top'>"
	'response.write "<input type='text' name='MenuDay' id='MenuDay' size='2' value='" & obj_RecordSet("MenuDay") & "'> <h5>(" & MenuDate & ")</h5>"
	response.write "<h5><b>Day: " & obj_RecordSet("MenuDay") & " - Date: " & MenuDate & "</b></h5>"
	MenuDate = dateadd("d",1,MenuDate)
	response.write "</td>"
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td><b>Breakfast</b></td>"
	response.write "<td align='left' valign='top'>"
	'response.write "<textarea cols='60' rows='5' name='Breakfast'>" & replace(obj_RecordSet("Breakfast") & vbnullstring,vbcr,"<br>") & "</textarea>"
	response.write "<textarea cols='60' rows='5' name='Breakfast'>" & obj_RecordSet("Breakfast") & "</textarea>"
	response.write "</td>"
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td><b>Lunch</b></td>"
	response.write "<td align='left' valign='top'>"
	response.write "<textarea cols='60' rows='5' name='Lunch'>" & obj_RecordSet("Lunch") & "</textarea>"
	response.write "</td>"
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td><b>Supper</b></td>"
	response.write "<td align='left' valign='top'>"
	response.write "<textarea cols='60' rows='5' name='Supper'>" & obj_RecordSet("Supper") & "</textarea>"
	response.write "</td>"
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td><b>Snack</b></td>"
	response.write "<td align='left' valign='top'>"
	response.write "<textarea cols='60' rows='5' name='Snack'>" & obj_RecordSet("Snack") & "</textarea>"
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close
response.write "<tr>"
response.write "<td><b>Password</b></td>"
response.write "<td align='left' valign='top'>"
response.write "<input type='password' name='Password' id='Password' value='" & Request("Password") & "'><h5>(Use the password you entered when you created the menu.)</h5>"
response.write "</td>"
response.write "</tr>"
response.write "<tr>"
response.write "<td>&nbsp;</td>"
response.write "<td><input type='submit' name='submit' id='submit' value='Submit'></td>"
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