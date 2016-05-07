<%@ Language=VBScript %>
<%Option Explicit %>
<%Response.Buffer = True%>
<!-- #Include file="includes/connection.asp" -->
<!-- #Include file="includes/library.asp" -->
<html>
<!-- 
COPYRIGHT NOTICE. 
All rights reserved. Any rights not expressly granted are reserved.
Copyright © 2002 Crucible Systems
-->
<head>
<link rel='stylesheet' href='includes/Troop18.css'>
<title><% response.write str_SiteName %></title>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
dim int_DaystoShow
dim int_Temp
%>
<H1><% response.write str_SiteName %><br></H1>
<H2><% response.write "Site Tracking" %></H2>
<hr align="left" width="100%" size="1">
<table border='0' cellspacing='0' cellpadding='0'>
<tr>
<!--- Begin List Cell --->
<td align='left' valign='top' scope='col' bgcolor='#F6F7EB'>
<%	
int_PageName = 57
str_SQL = "SELECT LinkURL, LinkDisplay, Target FROM Links WHERE Links.Active='Y' AND " & _
		"PageNameID_fk=" & int_PageName & " or PageNameID_fk = 0 ORDER BY PageNameID_fk, Links.DisplayOrder"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
Do while not obj_RecordSet.eof
	if len(obj_RecordSet("LinkURL")) > 0 then
		response.write "<A href='" & obj_RecordSet("LinkURL") & _
					"' Target='" & obj_RecordSet("Target") & "'>" & _
					obj_RecordSet("LinkDisplay") & "</a>&nbsp;<BR>"
	else
		response.write obj_RecordSet("LinkDisplay") & "&nbsp;<BR>"
	end if
	obj_RecordSet.movenext
loop
obj_RecordSet.close
Set obj_RecordSet = nothing

gls_LogPage int_PageName, request("REMOTE_HOST")
%>
<!--- End List Cell --->
</td><td valign='top'>
<!--- Begin Body Cell --->
<%
int_DaystoShow = 15

'==========================================================================================
' Show hits by page
'==========================================================================================
response.write "<h3>Hits by Page</h3>"
str_SQL = "SELECT DateValue(CDate([PageLogs].[AddedDate])) AS [Day], PageNames.PageName AS Page, Count(PageLogs.PageNameID_fk) AS Hits " & _
		"FROM Users inner JOIN (PageNames INNER JOIN PageLogs ON PageNames.PageNameID = PageLogs.PageNameID_fk) ON Users.UserID = PageLogs.UserID_fk " & _
		"where PageLogs.AddedDate > #" & (date() - int_DaystoShow) & "# " & _ 
		"GROUP BY DateValue(CDate([PageLogs].[AddedDate])), PageNames.PageName " & _
		"ORDER BY DateValue(CDate([PageLogs].[AddedDate])) DESC , PageNames.PageName;"
		
str_SQL = "SELECT DateValue(CDate([PageLogs].[AddedDate])) AS [Day], PageNames.PageName AS Page, Count(PageLogs.PageNameID_fk) AS Hits " & _
		"FROM PageNames INNER JOIN PageLogs ON PageNames.PageNameID = PageLogs.PageNameID_fk " & _
		"WHERE (((PageLogs.AddedDate)>#" & (date() - int_DaystoShow) & "#)) " & _
		"GROUP BY DateValue(CDate([PageLogs].[AddedDate])), PageNames.PageName " & _
		"ORDER BY DateValue(CDate([PageLogs].[AddedDate])) DESC , PageNames.PageName; "

'Response.write str_SQL
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=1>"
response.write "<TR>"
for int_Temp = 0 to obj_RecordSet.Fields.Count - 1
   		response.write "<TD><B>" & obj_RecordSet(int_Temp).name & "&nbsp;</b></td>"
next 
response.write "</tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	for int_Temp = 0 to (obj_RecordSet.fields.count - 1)
		response.write "<TD>" & obj_RecordSet.fields(int_Temp) & "&nbsp;</td>"
	next 
	response.write "</tr>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close
Set obj_RecordSet = nothing
response.write "</table>"
response.write "<br>"

'==========================================================================================
' Show hits by IP
'==========================================================================================
response.write "<h3>Hits by IP</h3>"
str_SQL = "SELECT DateValue(CDate([PageLogs].[AddedDate])) AS [Day], PageLogs.IPAddress, Count(PageLogs.IPAddress) AS Hits " & _
		"FROM Users inner JOIN (PageNames INNER JOIN PageLogs ON PageNames.PageNameID = PageLogs.PageNameID_fk) ON Users.UserID = PageLogs.UserID_fk " & _
		"where PageLogs.AddedDate > #" & (date() - int_DaystoShow) & "# " & _ 
		"GROUP BY DateValue(CDate([PageLogs].[AddedDate])), PageLogs.IPAddress " & _
		"ORDER BY DateValue(CDate([PageLogs].[AddedDate])) DESC , PageLogs.IPAddress;"

str_SQL = "SELECT DateValue(CDate([PageLogs].[AddedDate])) AS [Day], PageLogs.IPAddress, Count(PageLogs.IPAddress) AS Hits " & _
		"FROM PageNames INNER JOIN PageLogs ON PageNames.PageNameID = PageLogs.PageNameID_fk " & _
		"where PageLogs.AddedDate > #" & (date() - int_DaystoShow) & "# " & _ 
		"GROUP BY DateValue(CDate([PageLogs].[AddedDate])), PageLogs.IPAddress " & _
		"ORDER BY DateValue(CDate([PageLogs].[AddedDate])) DESC , PageLogs.IPAddress;"

'Response.write str_SQL
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=1>"
response.write "<TR>"
for int_Temp = 0 to obj_RecordSet.Fields.Count - 1
   		response.write "<TD><B>" & obj_RecordSet(int_Temp).name & "&nbsp;</b></td>"
next 
response.write "</tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	for int_Temp = 0 to (obj_RecordSet.fields.count - 1)
		response.write "<TD>" & obj_RecordSet.fields(int_Temp) & "&nbsp;</td>"
	next 
	response.write "</tr>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close
Set obj_RecordSet = nothing
response.write "</table>"
response.write "<br>"

'==========================================================================================
' Show hits by day
'==========================================================================================
response.write "<h3>Hits by Day</h3>"
str_SQL = "SELECT DateValue(CDate([PageLogs].[AddedDate])) AS [Day], Count(PageLogs.AddedDate) AS Hits " & _
		"FROM PageLogs " & _
		"where PageLogs.AddedDate > #" & (date() - int_DaystoShow) & "# " & _ 
		"GROUP BY DateValue(CDate([PageLogs].[AddedDate])) " & _
		"ORDER BY DateValue(CDate([PageLogs].[AddedDate])) DESC;"
'Response.write str_SQL
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<table border=1>"
response.write "<TR>"
for int_Temp = 0 to obj_RecordSet.Fields.Count - 1
   		response.write "<TD><B>" & obj_RecordSet(int_Temp).name & "&nbsp;</b></td>"
next 
response.write "</tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	for int_Temp = 0 to (obj_RecordSet.fields.count - 1)
		response.write "<TD>" & obj_RecordSet.fields(int_Temp) & "&nbsp;</td>"
	next 
	response.write "</tr>"
	obj_RecordSet.movenext
loop
obj_RecordSet.close
Set obj_RecordSet = nothing
response.write "</table>"
response.write "<br>"

%>
<!--- End Body Cell --->
</td>
</tr>
</table>
</body>
</html>