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
<title>Books On Loan</title>
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
int_PageName = 60
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
RESPONSE.write "<h2>Books On Loan</h2><br><br>"
str_SQL = "SELECT Members.FirstName+' ' +Members.LastName as Member, MemberID_fk, BookStatuses.BookStatus, BooksOnLoan.LastDate, BooksOnLoan.BooksOnLoanID, MeritBadgeBooks.MeritBadgeBook, BooksOnLoan.Amount FROM Members INNER JOIN (BookStatuses INNER JOIN (MeritBadgeBooks INNER JOIN BooksOnLoan ON MeritBadgeBooks.MeritBadgeBookID = BooksOnLoan.MeritBadgeID_fk) ON BookStatuses.BookStatusID = BooksOnLoan.BookStatusID_fk) ON Members.MemberID = BooksOnLoan.MemberID_fk ORDER BY BookStatuses.DisplayOrder, BooksOnLoan.LastDate, Members.FirstName, Members.LastName"
'response.write str_SQL
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=0>"
response.write "<tr>"
response.write "<th>"
response.write "Member"
response.write "</th>"
response.write "<th>"
response.write "Book"
response.write "</th>"
response.write "<th>"
response.write "Date"
response.write "</th>"
response.write "<th>"
response.write "Books Loaned"
response.write "</th>"
response.write "</tr>"
dim CurrStatus
Do while not obj_RecordSet.eof
	
	if not CurrStatus = obj_RecordSet("BookStatus") then
		response.write "<tr><td><h3>"
		response.write obj_RecordSet("BookStatus")
		response.write "</h3></td></tr>"
	end if
	CurrStatus = obj_RecordSet("BookStatus")

	response.write "<tr>"

	response.write "<td>"
	response.write	"<a href='MemberBookDetail.asp?ID=" & obj_RecordSet("MemberID_fk") & "'>" & obj_RecordSet("Member") & "</a>"
	response.write "</td>"

	response.write "<td>"
	response.write "<a href='ChangeBookStatus.asp?BOLID=" & obj_RecordSet("BooksOnLoanID") & "'>" & obj_RecordSet("MeritBadgeBook") & "</a>"
	response.write "</td>"

	response.write "<td>"
	if (date-obj_RecordSet("LastDate")) > 60 then
		response.write obj_RecordSet("LastDate") & " <h5><font color=red><b>(" & date-obj_RecordSet("LastDate") & " days)</b></font></h5>"
	else
		response.write obj_RecordSet("LastDate") & " <h5>(" & date-obj_RecordSet("LastDate") & " days)</h5>"
	end if
	
	response.write "</td>"

	response.write "<td align='center'>"
	response.write obj_RecordSet("Amount")
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