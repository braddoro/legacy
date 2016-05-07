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
<title>Merit Badge Check Out</title>
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
int_PageName = 56
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
str_SQL = "SELECT MeritBadgeBooks.MeritBadgeBookID, MeritBadgeBooks.MeritBadgeBook, MeritBadgeBooks.Quantity AS TotalBooks, Sum([Quantity]-(IIf(IsNull([Amount]),0,[Amount]))) AS AvailableBooks FROM MeritBadgeBooks LEFT JOIN BooksOnLoan ON MeritBadgeBooks.MeritBadgeBookID = BooksOnLoan.MeritBadgeID_fk GROUP BY MeritBadgeBooks.MeritBadgeBookID, MeritBadgeBooks.MeritBadgeBook, MeritBadgeBooks.Quantity HAVING (((MeritBadgeBooks.MeritBadgeBookID)=" & Request("ID") & ")) ORDER BY MeritBadgeBooks.MeritBadgeBook;"

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString

RESPONSE.write "<h2>Request Book: " & obj_RecordSet("MeritBadgeBook") & "</h2><br><br>"
response.write "<h5>Fill out the form to request the book.</h5>"
response.write "<table border=0>"
Do while not obj_RecordSet.eof
	'response.write "<tr>"
	'response.write "<td>"
	'response.write "Total Books: " & obj_RecordSet("TotalBooks")  & "&nbsp;"
	'response.write "</td>"
	'response.write "</tr>"
	'response.write "<tr>"
	'response.write "<td>"
	'response.write "Available Books: " & obj_RecordSet("AvailableBooks")  & "&nbsp;"
	'response.write "</td>"
	'response.write "</tr>"
	response.write "<form action='MeritBadgeCheckOut.asp' name='Add' id='Add'>"
	response.write "<input type='hidden' name='Available' id='Available' value='" & obj_RecordSet("AvailableBooks") & "'>"
	response.write "<input type='hidden' name='ID' id='ID' value='" & obj_RecordSet("MeritBadgeBookID") & "'>"
	response.write "<tr>"
	response.write "<td>Books Requested</td><td><input type='text' name='Copies' id='Copies' size='2' maxlength='2'> <h5>(max " & obj_RecordSet("AvailableBooks")  & ")</h5></td>"
	response.write "</tr>"
	response.write "<tr>"
	response.write "<td>Requested By</td><td>"
	response.write "<select name='RequestedBy'>" & vbcrlf
	str_SQL = "Select MemberID, [FirstName]+' '+[LastName] AS Member from Members where Active = 'Y' Order by [FirstName]+' '+[LastName]"
	set obj_SelectBox = server.createObject("ADODB.Recordset")
	obj_SelectBox.Open str_SQL, str_ConnectionString
	response.write "<option value='0'></option>" & vbcrlf
	Do while not obj_SelectBox.eof
		response.write "<option value='" & obj_SelectBox("MemberID") & "'>" & obj_SelectBox("Member") & "</option>" & vbcrlf
		obj_SelectBox.movenext
	loop
	obj_SelectBox.close
	Set obj_SelectBox = nothing
	response.write "</select>" & vbcrlf
	
	'response.write "<tr><td>Password</td><td>"
	'response.write "<input type='password' name='Password' value='" & request("password") & "' id='Password'> <h5>(required to check out)</h5>"
	'response.write "</td></tr>"
	
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
<%
' and lcase(request("Password")) = str_Password
If request("Copies") > 0 and request("RequestedBy") > 0 then
		str_SQL = "Insert into BooksOnLoan (MeritBadgeID_fk, MemberID_fk, LastDate, Amount, BookStatusID_fk) " & _
					"values("& request("ID") & ", " & _
					request("RequestedBy") & ", #" & _
					date & "#, " & _
					request("Copies") & ", 1)"
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
			response.redirect "availablebooks.asp"
			response.write "<br>"
		end if
		set obj_Command = nothing
end if
%>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>
<script Language="VBscript" type="text/VBscript">
sub Copies_OnBlur()
	if not isnumeric(document.Add.Copies.value) and len(trim(document.Add.Copies.value)) > 0 then
		document.Add.Copies.focus
		window.alert "Number of copies must be a number."
		exit sub
	end if
	if document.Add.Copies.value > trim(document.Add.Available.value) then
		document.Add.Copies.value = trim(document.Add.Available.value)
		document.Add.Copies.focus
		window.alert "You can not check out more books than there are available.  The maximum amount of books you can check out are: " & document.Add.Available.value
		exit sub
	end if
end sub
</script>