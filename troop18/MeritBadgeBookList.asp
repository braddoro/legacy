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
<title>Merit Badge Book List</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
Dim int_RecordsUpdated
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
int_PageName = 62
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
if lcase(request("Submit")) = "change" then
	if request("MBID") > 0 and request("MeritBadgeBookID") >= 0 then
		str_SQL = "Update MeritBadgeBooks set Quantity = " & request("Quantity") & " where MeritBadgeBookID = " & request("MBID")
		'response.write str_SQL  & vbCRLF
		If lcase(request("Password")) = str_Password then
			set obj_Command = server.createObject("ADODB.Command")
			obj_Command.ActiveConnection = str_ConnectionString
			obj_Command.CommandText = str_SQL
			obj_Command.Execute int_RecordsUpdated
			set obj_Command = nothing
			if int_RecordsUpdated = 1 then
				response.redirect("MeritbadgeBookList.asp")
			end if
		end if
	end if
end if

str_SQL = "SELECT MeritBadgeBookID, MeritBadgeBook, Quantity from MeritBadgeBooks order by MeritBadgeBook"

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString

if not (obj_RecordSet.bof and obj_RecordSet.eof) then
	RESPONSE.write "<h2>Merit Badge Book List</h2><br><br>" & vbCRLF
end if
response.write "<table border=0>"
response.write "<tr>"
response.write "<th>"
response.write "Book"
response.write "</th>"
response.write "<th>"
response.write "Quantity"
response.write "</th>"
response.write "<th>"
response.write "Password"
response.write "</th>"
response.write "<td>"
response.write "&nbsp;"
response.write "</td>"
response.write "</tr>" & vbCRLF
Do while not obj_RecordSet.eof
	response.write "<form action='MeritbadgeBookList.asp#MIB"& obj_RecordSet("MeritBadgeBookID") & "' name='MeritbadgeBookList' id='MeritbadgeBookList'>"
	response.write "<input type='hidden' name='MBID' id='MBID' value='" & obj_RecordSet("MeritBadgeBookID") & "'>"
	response.write "<tr>"
	response.write "<td>"
	response.write "<p ID='MIB" & obj_RecordSet("MeritBadgeBookID") & "'>" & obj_RecordSet("MeritBadgeBook") & "</p>"
	'response.write "<a name='MIB" & obj_RecordSet("MeritBadgeBookID") & "'>" & obj_RecordSet("MeritBadgeBook") & "</a>"
	response.write "</td>"
	response.write "<td align='center'>"
	response.write "<input type='text' name='Quantity' id='Quantity' value='" & obj_RecordSet("Quantity") & "' size='3' maxlength='3'></td>"
	response.write "<td align='center'>"
	response.write "<input type='password' name='Password' id='Password' value='' size='15'></td>"
	response.write "<td align='center'>"
	response.write "<input type='submit' name='Submit' id='Submit' value='Change'>"
	response.write "</td>"
	response.write "</tr>"
	response.write "</form>"  & vbCRLF
	obj_RecordSet.movenext
loop
obj_RecordSet.close
response.write "</table>" & vbCRLF
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>