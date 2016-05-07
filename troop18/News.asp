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
<title>News</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
dim intDays
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
int_PageName = 35
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
<%
RESPONSE.write "<h2>News</h2><br>"
if int(request("DaysBack")) > 0 then
	intDays = request("DaysBack")
else
	intDays = 30
end if
%>
<form action='news.asp'>
<table>
<tr>
<td>
Days of past news to show <input type='text' name='DaysBack' id='DaysBack' value='<% response.write intDays %>' size='4' maxlength='4'>
</td>
</tr>
<tr>
<td>
<input type='submit' name='submit' id='submit' value='submit'>
</td>
</tr>
</table>
</form>
<%
'str_SQL = "SELECT News.Title, News.News, News.AddedDate, Users.UserName, EmailVisible, Users.EmailAddress, UserLevels.UserLevel " & _
'		"FROM (	UserLevels INNER JOIN Users ON UserLevels.UserLevelID = Users.UserLevelID_fk) INNER JOIN News ON Users.UserID = News.UserID_fk " & _
'		"WHERE News.Active='Y'  and News.AddedDate > #" & (date() - 30) & "# order by News.AddedDate desc"

'str_SQL = "SELECT News.Title, News.News, News.AddedDate FROM News " & _
'		"WHERE News.Active='Y' order by News.AddedDate desc"
		'"WHERE News.Active='Y' and News.AddedDate > #" & (date() - 30) & "# order by News.AddedDate desc"		

str_SQL = "SELECT NewsID, News.Title, News.News, News.AddedDate FROM News WHERE (((News.AddedDate)>#" & (date() - int(request("daysBack"))) & "#) AND ((News.Active)='Y')) ORDER BY News.AddedDate DESC;"
'response.write str_SQL

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<BR>"
response.write "<table width='100%' border='0'>" 
Do while not obj_RecordSet.eof
	
	response.write "<tr>"
	response.write "<td><h4><a name='" & obj_RecordSet("NewsID") & "'>"
	response.write obj_RecordSet("Title")
	response.write "</h4><td>"
	response.write "<td><h4>"
	response.write obj_RecordSet("AddedDate")
	if datediff("d", obj_RecordSet("AddedDate"), date()) > 0 then
		response.write " <h5>(" & datediff("d", obj_RecordSet("AddedDate"), date()) & " days ago)</h5>"
	else
		response.write " <h5>(today)</h5>"
	end if
	
	response.write "</h4></td></tr>"
	
	response.write "<tr>"
	response.write "<td colspan=3>"
	response.write replace(replace(obj_RecordSet("News"),vbcrlf,"<br>"),"`","'")
	response.write "</td>"
	response.write "</tr>"

	response.write "<tr>"
	response.write "<td colspan=3>&nbsp;"
	response.write "</td>"
	response.write "</tr>"

	response.write "<tr>"
	response.write "<td colspan=3><hr size='1px'>"
	response.write "</td>"
	response.write "</tr>"

	obj_RecordSet.movenext
loop
response.write "</table>" & vbcrlf	
obj_RecordSet.close
Set obj_RecordSet = nothing
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>