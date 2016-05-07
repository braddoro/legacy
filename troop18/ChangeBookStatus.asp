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
<title>Change Book Status</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
dim obj_SelectBox
dim int_RecordsUpdated
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
int_PageName = 58
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
str_SQL = "SELECT BooksOnLoan.BooksOnLoanID, Amount, BooksOnLoan.BookStatusID_fk, MeritBadgeBooks.MeritBadgeBook, [FirstName]+' '+[LastName] AS Member FROM MeritBadgeBooks INNER JOIN (Members INNER JOIN BooksOnLoan ON Members.MemberID = BooksOnLoan.MemberID_fk) ON MeritBadgeBooks.MeritBadgeBookID = BooksOnLoan.MeritBadgeID_fk WHERE BooksOnLoan.BooksOnLoanID = " & Request("BOLID")

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
if not (obj_RecordSet.bof and obj_RecordSet.eof) then
	RESPONSE.write "<h2>Change Book Status: " & obj_RecordSet("MeritBadgeBook") & "</h2><br><br>"
else
	RESPONSE.write "<h2>Change Book Status: " & "</h2><br><br>"
end if

response.write "<table border=0>"
Do while not obj_RecordSet.eof
	response.write "<form>"
	response.write "<tr>"
	response.write "<td>"
	response.write "Status"
	response.write "</td>"
	response.write "<td>"
	response.write "<select name='BookStatus'>" & vbcrlf
	str_SQL = "Select BookStatusID, BookStatus from BookStatuses where Active = 'Y' Order by DisplayOrder"
	set obj_SelectBox = server.createObject("ADODB.Recordset")
	obj_SelectBox.Open str_SQL, str_ConnectionString
	Do while not obj_SelectBox.eof
		if obj_SelectBox("BookStatusID") = obj_RecordSet("BookStatusID_fk") then
			response.write "<option value='" & obj_SelectBox("BookStatusID") & "' SELECTED>" & obj_SelectBox("BookStatus") & "</option>" & vbcrlf
		else
			response.write "<option value='" & obj_SelectBox("BookStatusID") & "'>" & obj_SelectBox("BookStatus") & "</option>" & vbcrlf
		end if
		obj_SelectBox.movenext
	loop
	obj_SelectBox.close
	Set obj_SelectBox = nothing
	response.write "</select>" & vbcrlf
	response.write "</td>"
	response.write "</tr>"
	
	response.write "<tr>"
	response.write "<td>"
	response.write "Books" 
	response.write "</td>"
	response.write "<td><input type='text' name='Amount' id='Amount' value='" & obj_RecordSet("Amount") & "' size='3' maxlength='3'></td>"
	response.write "</tr>"

	response.write "<input type='hidden' name='ID' id='ID' value='" & Request("ID") & "'>"
	response.write "<input type='hidden' name='BOLID' id='BOLID' value='" & obj_RecordSet("BooksOnLoanID") & "'>"
	response.write "<tr>"

	response.write "<tr>"
	response.write "<td>"
	response.write "Book Returned" 
	response.write "</td>"
	response.write "<td><input type='checkbox' name='Returned' id='Returned' value='Yes'> <h5>(delete)</h5></td>"
	response.write "</tr>"
	
	response.write "<tr><td>Password</td><td>"
	response.write "<input type='password' name='Password' value='" & request("password") & "' id='Password'> <h5>(required to update)</h5>"
	response.write "</td></tr>"
	
	response.write "</td>"
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td>&nbsp;</td><td><input type='submit' name='submit' id='submit' value='submit'></td>"
	response.write "</tr>"
	response.write "</form>"
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
<%
If lcase(request("Password")) = str_Password then
	if request("Returned") = "Yes" then
		str_SQL = "delete from BooksOnLoan where BooksOnLoanID = " & Request("BOLID")
	else
		str_SQL = "Update BooksOnLoan set Amount = " & Request("Amount") & ", BookStatusID_fk = " & Request("BookStatus") & ", LastDate = #" & date & "# where BooksOnLoanID = " & Request("BOLID")
	end if
		response.write str_SQL
		set obj_Command = server.createObject("ADODB.Command")
		obj_Command.ActiveConnection = str_ConnectionString
		obj_Command.CommandText = str_SQL
		obj_Command.Execute int_RecordsUpdated
		if not int_RecordsUpdated = 1 then
			response.write "Error: " & int_RecordsUpdated & "<BR><BR>"
			response.write str_SQL & "<BR><BR>"
			response.write request.querystring
		else
			response.write "Book Updated<br>"
			Response.redirect "BooksOnLoan.asp"
		end if
		set obj_Command = nothing
end if
%>