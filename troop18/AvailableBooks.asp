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
<title>Available Books</title>
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
int_PageName = 55
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
RESPONSE.write "<h2>Available Merit Badge Books</h2><br><br>"
response.write "<h5>Click on the merit badge book name to request that book.</h5>"
str_SQL = "SELECT MeritBadgeBooks.MeritBadgeBookID, MeritBadgeBooks.MeritBadgeBook, MeritBadgeBooks.Quantity AS TotalBooks, Sum(IIf(IsNull([Amount]),0,[amount])) AS CheckedOut FROM MeritBadgeBooks LEFT JOIN BooksOnLoan ON MeritBadgeBooks.MeritBadgeBookID = BooksOnLoan.MeritBadgeID_fk GROUP BY MeritBadgeBooks.MeritBadgeBookID, MeritBadgeBooks.MeritBadgeBook, MeritBadgeBooks.Quantity HAVING (((MeritBadgeBooks.Quantity)>0)) ORDER BY MeritBadgeBooks.MeritBadgeBook;"
'response.write str_SQL
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=1>"
response.write "<tr>"
response.write "<th>"
response.write "Merit Badge Books"
response.write "</th>"
response.write "<th>"
response.write "Total Books"
response.write "</th>"
response.write "<th>"
response.write "Available"
response.write "</th>"
response.write "<th>"
response.write "Checked Out"
response.write "</th>"
response.write "</tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"

	response.write "<td>"
	if (obj_RecordSet("TotalBooks")-obj_RecordSet("CheckedOut")) > 0 then
		response.write "<a href='MeritBadgeCheckOut.asp?ID=" & obj_RecordSet("MeritBadgeBookID") & "'>" & obj_RecordSet("MeritBadgeBook") & "</a>"
	else
		response.write obj_RecordSet("MeritBadgeBook")
	end if
	response.write "</td>"
	
	response.write "<td align='center'>"
	response.write obj_RecordSet("TotalBooks") & "&nbsp;"
	response.write "</td>"

	response.write "<td align='center'>"
	if (obj_RecordSet("TotalBooks")-obj_RecordSet("CheckedOut")) > 0 then
		'response.write "<a href='MeritBadgeCheckOut.asp?ID=" & obj_RecordSet("MeritBadgeBookID") & "'>" & (obj_RecordSet("TotalBooks")-obj_RecordSet("CheckedOut")) & "&nbsp;" & "</a>"
		response.write (obj_RecordSet("TotalBooks")-obj_RecordSet("CheckedOut")) & "&nbsp;" 
	else
		response.write "&nbsp;"
	end if
	response.write "</td>"

	response.write "<td align='center'>"
	if obj_RecordSet("CheckedOut") > 0 then
		response.write "<a href='MeritBadgeDetail.asp?ID=" & obj_RecordSet("MeritBadgeBookID") & "'>" & obj_RecordSet("CheckedOut") & "&nbsp;" & "</a>"
	else
		response.write "&nbsp;"
	end if
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