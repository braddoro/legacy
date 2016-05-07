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
<title>Join</title>
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
int_PageName = 39
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
<h2>Join Us!</h2><br><br>
We meet at:<BR>
Newell Presbyterian Church <BR>
1500 Rocky River Rd W <BR>
Charlotte, NC  28213<BR><BR>
(704) 596-2329
We are part of the Mecklenburg council, Tatanka district. 
We are sponsord by Newell Presbyterian church.
We are dedicated to the boy scout oath and promise and the scout motto, "be prepared".
<BR><BR>
If you would like to come visit call the for directions to our scout hut.<br>
<%
response.write "<table>"
str_SQL = "SELECT Year([ActivityStart]) AS [Year], ActivityTypes.ActivityType, Count(Activities.ActivityID) AS Activities FROM ActivityTypes INNER JOIN Activities ON ActivityTypes.ActivityTypeID = Activities.ActivityTypeID_fk GROUP BY Year([ActivityStart]), ActivityTypes.ActivityType, ActivityTypes.ActivityTypeID, ActivityTypes.UseInSummary HAVING ((Year([ActivityStart])<=Year(Date())) AND ((ActivityTypes.UseInSummary)='Y')) ORDER BY Year([ActivityStart]) DESC , ActivityTypes.ActivityType;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=0>"
response.write "<th colspan='3'>"
response.write "We are an active Troop.  Here is a summary of a few of things we have done recently."
response.write "</th>"
response.write "<tr>"
response.write "<th>"
response.write "Year"
response.write "</th>"
response.write "<th>"
response.write "Activity Type"
response.write "</th>"
response.write "<th>"
response.write "Total"
response.write "</th>"
response.write "</tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write	obj_RecordSet("Year")
	response.write "</td>"
	response.write "<td>"
	response.write	obj_RecordSet("ActivityType")
	response.write "</td>"
	response.write "<td>"
	response.write	obj_RecordSet("Activities")
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