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
<title>ADD Counselor</title>
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
dim TotalMB
Dim Rec2
Dim Conn2
Dim SQL2
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
int_PageName = 77
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
<h2>Add Counselor</h2><br>
<%

if len(request("Member")) > 0 and len(request("MeritBadge")) > 0 and lcase(request("Password")) = str_Password then
	dim int_RecordsUpdated
	'response.write "<h5>Adding...</h5>"
	str_SQL = "Insert into Councilors (MemberID_fk, MeritBadgeID_fk) " & _
				"values(" & request("Member") & ", " & request("MeritBadge") & ")"
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
		'response.redirect("Councilors.asp")
	end if
	set obj_Command = nothing
end if
response.write "<form action='CouncilorAdd.asp' method='post' name='Add' id='Add'>"
response.write "<table>"

response.write "<tr>"
response.write "<td>Councilor</td>"
response.write "<td>"
set Conn2 = Server.CreateObject("ADODB.Connection")
Conn2.ConnectionString = str_ConnectionString
Conn2.Open  
set Rec2 = Server.CreateObject("ADODB.Recordset")
SQL2 = "SELECT Members.MemberID, Members.FirstName, Members.LastName FROM Members WHERE Members.Active = 'Y' AND Members.Adult = 'Y' ORDER BY Members.FirstName, Members.LastName"
Rec2.Open Sql2, Conn2
Response.Write "<SELECT id='Member' name='Member'>"
Response.Write "<option value='0'></option>"
Do while not Rec2.EOF
	if trim(Request("Member")) = trim(Rec2("MemberID")) then
		Response.Write "<option value='" & Rec2("MemberID") & "' SELECTED>" & Rec2("FirstName") & " " & Rec2("LastName") & "</option>" & vbcrlf
	else
		Response.Write "<option value='" & Rec2("MemberID") & "'>" & Rec2("FirstName") & " " & Rec2("LastName") & "</option>" & vbcrlf
	end if
	Rec2.MoveNext
loop
Response.Write "</select>" & vbcrlf
Rec2.Close
Conn2.close
set Rec2 = nothing
set Conn2 = nothing
response.write "</td>"
response.write "</tr>"

response.write "<tr>"
response.write "<td>MeritBadge</td>"
response.write "<td>"
set Conn2 = Server.CreateObject("ADODB.Connection")
Conn2.ConnectionString = str_ConnectionString
Conn2.Open  
set Rec2 = Server.CreateObject("ADODB.Recordset")
SQL2 = "SELECT MeritBadgeBooks.MeritBadgeBookID, MeritBadgeBooks.MeritBadgeBook FROM MeritBadgeBooks ORDER BY MeritBadgeBooks.MeritBadgeBook"
Rec2.Open Sql2, Conn2
Response.Write "<SELECT id='MeritBadge' name='MeritBadge'>"
Response.Write "<option value='0'></option>"
Do while not Rec2.EOF
	if trim(Request("MeritBadge")) = trim(Rec2("MeritBadgeBookID")) then
		Response.Write "<option value='" & Rec2("MeritBadgeBookID") & "' SELECTED>" & Rec2("MeritBadgeBook") & "</option>" & vbcrlf
	else
		Response.Write "<option value='" & Rec2("MeritBadgeBookID") & "'>" & Rec2("MeritBadgeBook") & "</option>" & vbcrlf
	end if
	Rec2.MoveNext
loop
Response.Write "</select>" & vbcrlf
Rec2.Close
Conn2.close
set Rec2 = nothing
set Conn2 = nothing
response.write "</td>"
response.write "</tr>"

response.write "<tr><td>Password</td><td>"
response.write "<input type='password' name='Password' value='' id='Password'><h5>(required to add)</h5>"
response.write "</td></tr>"

response.write "<tr>"
response.write "<td>&nbsp;</td>"
response.write "<td><input type='submit' name='Submit' id='Submit' value='Submit'></td>"
response.write "</tr>"

response.write "</table>"
response.write "</form>"
if len(request("Member")) > 0 then
	str_SQL = "SELECT CouncilorID, MeritBadgeBooks.MeritBadgeBook, Required FROM MeritBadgeBooks INNER JOIN Councilors ON MeritBadgeBooks.MeritBadgeBookID = Councilors.MeritBadgeID_fk WHERE Councilors.MemberID_fk = " & request("Member") & " ORDER BY MeritBadgeBooks.MeritBadgeBook"
	set obj_RecordSet = server.createObject("ADODB.Recordset")
	obj_RecordSet.Open str_SQL, str_ConnectionString
	response.write "<table>"
	TotalMB = 0
	Do while not obj_RecordSet.eof
		response.write "<tr>"
		response.write "<td>" & obj_RecordSet("MeritBadgeBook")
		if obj_RecordSet("Required") = "Y" then
			response.write "<img src='images/f-d-l.gif' alt='Eagle Required' width='19' height='18' border='0' align='bottom'>"
		end if
		response.write " <a href='DeleteCouncilor.asp?mid=" & request("Member") & "&id=" & obj_RecordSet("CouncilorID") & "'>[delete]</a>"
		response.write "</td>"
		response.write "</tr>"
		TotalMB = TotalMB + 1
		obj_RecordSet.movenext
	loop
	response.write "</table>"
	obj_RecordSet.close
	
	response.write "<b>Total: " & TotalMB & "</b><br>"
	response.write "<br><img src='images/f-d-l.gif' alt='Eagle Required' width='19' height='18' border='0'> Denotes Eagle Required Merit Badge"
end if
%>
<br>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>