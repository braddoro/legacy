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
<title>Home</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
'<img src='images/icon_flagUS.gif' alt='' width='60' height='39' border='0' align='bottom'><img src='images/yellowribbon.gif' name='ribbon' id='ribbon' width='29' height='65' border='0' align='left'>
%>
<table width='100%' border='0'>
<!-- The header row. -->
<tr>
<td colspan='2'>
<% response.write str_LeftSideImage %> <h3><% response.write str_PageTitle %></h3>
</td>
<td><% 'Response.write str_RightSide%></td>
</tr>
<tr><td colspan='3'><hr width='100%' size='1'></td></tr>
<!-- The detail row. -->
<tr>
<!-- The List cell. -->
<td width='15%' valign='top'>
<%
int_PageName = 33
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
<td valign='top'>
<br>
<%
str_SQL = "SELECT SplashText from Configuration"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
Do while not obj_RecordSet.eof
	response.write obj_RecordSet("SplashText") & "<BR>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close
str_SQL = "SELECT News.Title, News.NewsID, News.AddedDate FROM News WHERE News.AddedDate >=date()-" & int_DaysInNewsSummary & " and News.Active='Y' ORDER BY News.AddedDate DESC;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<h4>Recent News</h4>"
response.write "<table>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write "<a href='news.asp?DaysBack=90#" & obj_RecordSet("NewsID") & "'>" & obj_RecordSet("Title") & "</a>"
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>"
obj_RecordSet.close
response.write "<BR>"
str_SQL = "SELECT DateDiff('d',Now(),[ActivityStart]) AS DaysOut, ActivityTypes.ActivityType, Activities.Activity, Activities.ActivityID, ActivityTypes.Active FROM ActivityTypes INNER JOIN Activities ON ActivityTypes.ActivityTypeID = Activities.ActivityTypeID_fk WHERE (([ActivityStart]>=Date() And [ActivityStart]<=Date()+" & int_DaysInNewsSummary & ") AND ((Activities.Active)='Y')) ORDER BY ActivityStart;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<h4>Pending Events</h4>"
response.write "<table>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write "<a href='events.asp#" & obj_RecordSet("ActivityID") & "'>" & obj_RecordSet("ActivityType") & " - " & obj_RecordSet("Activity") & "</a>"
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>"
obj_RecordSet.close
response.write "<BR>"
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
<!-- #Include file="counter.asp"					-->
</body>
</html>