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
<title>Menu Add</title>
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
int_PageName = 66
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
<h2>Menu Add</h2><br><br>
<form>
<table>
<tr>
<td>Menu Name</td>
<td><input type="text" name="MenuName" id="MenuName" size="50" maxlength="50"></td>
</tr>
<tr>
<td>Start Date</td>
<td><input type="text" name="StartDate" id="StartDate" size="12" maxlength="12"></td>
</tr>
<tr>
<td>End Date</td>
<td><input type="text" name="EndDate" id="EndDate" size="12" maxlength="12"></td>
</tr>
<tr>
<td>Password</td>
<td><input type="text" name="Password" id="Password" size="15" maxlength="15"><h5>(You must remember this password to edit this menu.)</h5></td>
</tr>
<tr>
<td>&nbsp;</td>
<td><input type="submit" name="submit" id="submit" value="Submit"></td>
</tr>
</table>
</form>

<%
Dim int_RecordsUpdated
Dim int_MenuDays
Dim X
Dim MenuID

If len(request("MenuName")) > 0 and _
isdate(request("StartDate")) and _
isdate(request("EndDate")) and _
len(request("Password")) > 0 then
	response.write "<h4>Updating...</h4>"
	str_SQL = "Insert into Menu (MenuName, StartDate, EndDate, Password) values('"
	str_SQL = str_SQL & glf_SQL_Safe3(request("MenuName")) & "', "
	str_SQL = str_SQL & "#" & glf_SQL_Safe3(request("StartDate")) & "#, "
	str_SQL = str_SQL & "#" & glf_SQL_Safe3(request("EndDate")) & "#, "
	str_SQL = str_SQL & "'" & glf_SQL_Safe3(request("Password")) & "')"
	'response.write str_SQL
	set obj_Command = server.createObject("ADODB.Command")
	obj_Command.ActiveConnection = str_ConnectionString
	obj_Command.CommandText = str_SQL
	obj_Command.Execute int_RecordsUpdated
	set obj_Command = nothing
	
	
	if int_RecordsUpdated = 1 then
	
		str_SQL = "Select MenuID from Menu Where MenuName = '" & glf_SQL_Safe3(request("MenuName")) & "'"
		set obj_RecordSet = server.createObject("ADODB.Recordset")
		obj_RecordSet.Open str_SQL, str_ConnectionString
		Do while not obj_RecordSet.eof
			MenuID = obj_RecordSet("MenuID")
			obj_RecordSet.movenext
		loop
		obj_RecordSet.close
		Set obj_RecordSet = nothing
		
		int_MenuDays = datediff("d", request("StartDate"), request("EndDate"))
		for x = 1 to (int_MenuDays + 1)
			str_SQL = "Insert into MenuDetail (MenuID_fk, MenuDay) values(" & MenuID & ", " & x & ")"
			set obj_Command = server.createObject("ADODB.Command")
			obj_Command.ActiveConnection = str_ConnectionString
			obj_Command.CommandText = str_SQL
			obj_Command.Execute
			set obj_Command = nothing
		next
		response.redirect("MenuDetail.asp?id=" & MenuID)
	end if
end if
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>