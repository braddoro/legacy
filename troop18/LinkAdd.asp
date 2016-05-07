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
<title>Add Link</title>
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
int_PageName = 45
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
RESPONSE.write "<h2>Add Links</h2><br><br>"

response.write "<form action='LinkAdd.asp' name='Add' id='Add'>"
response.write "<table>"

response.write "<tr><td>Link Name</td><td>"
response.write "<input type='text' name='LinkName' id='LinkName' size='80' maxlength='100'>"
response.write "</td</tr>"

response.write "<tr><td>Link URL</td><td>"
response.write "<input type='text' name='LinkURL' id='LinkURL' size='80' maxlength='100'>"
response.write "</td></tr>"

response.write "<tr><td>Link Category</td><td>"
set obj_RecordSet = server.createObject("ADODB.Recordset")
str_SQL = "Select LinkCategoryID, LinkCategory from LinkCategories Where Active = 'Y' Order by LinkCategory" 
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<select name='cboLinkCategories' size=1>"
do while not obj_RecordSet.eof
	if int(request("cboLinkCategories")) - obj_RecordSet("LinkCategoryID") = 0 then
		response.write "<option value=" & obj_RecordSet("LinkCategoryID") & " selected>" & obj_RecordSet("LinkCategory") & "</option>"
	else
		response.write "<option value=" & obj_RecordSet("LinkCategoryID") & ">" & obj_RecordSet("LinkCategory") & "</option>"
	End if
	obj_RecordSet.movenext
loop
response.write "</select>"
obj_RecordSet.close
set obj_RecordSet = nothing
response.write "</td></tr>"

response.write "<tr><td>Link Order</td><td>"
response.write "<input type='text' name='LinkOrder' id='LinkOrder' size='5' maxlength='4'>"
response.write "</td></tr>"

response.write "<tr><td>Password</td><td>"
response.write "<input type='password' name='Password' value='" & request("password") & "' id='Password'><h5>(required to add links)</h5>"
response.write "</td></tr>"

response.write "<tr><td>&nbsp;</td><td>"
response.write "<input type='submit' name='Submit' id='Submit' value='Submit'>"
response.write "</td></tr>"

response.write "</table>"
response.write "</form>"

Dim int_RecordsUpdated
Dim int_DispOrder
If lcase(request("Password")) = str_Password then

	'==========================================================================================
	' Insert the new information.
	'==========================================================================================
	If len(trim(request("LinkName"))) > 0 and _
			len(trim(request("LinkURl"))) > 0 and _
			len(trim(request("cboLinkCategories"))) > 0 and _
			len(trim(request("LinkOrder"))) > 0 then
	
		response.write "<h4>Updating...</h4>"
		int_DispOrder = int(request("DisplayOrder"))
		
		if int_DispOrder < 1 then
			int_DispOrder = 100
		end if
	
		str_SQL = "Insert into Links (LinkURL, LinkDisplay, PageNameID_fk, DisplayOrder, LinkCategoryID_fk, Target, UserID_fk) " & _
					"values('" & glf_SQL_Safe2(request("LinkURL")) & "', '" & _
					glf_SQL_Safe2(request("LinkName")) & "', " & _
					"37 ," & _
					request("LinkOrder") & ", " & _
					request("cboLinkCategories") & ", '_top', 114)"
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
			response.write "Your link, <a href='" & request("LinkURL") & "' target='_new'>" & request("LinkName") & "</a> has been added.<br>"
		end if
		set obj_Command = nothing
	end if
End IF
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>