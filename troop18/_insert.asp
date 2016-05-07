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
<title>Event Add</title>
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

'str_SQL = "Insert into ActivityTypes  (ActivityType) values ('New Scout Advancement')"
'str_SQL = "delete from Activities where ActivityID = 372"
'response.write str_SQL
'set obj_Command = server.createObject("ADODB.Command")
'obj_Command.ActiveConnection = str_ConnectionString
'obj_Command.CommandText = str_SQL
'obj_Command.Execute int_RecordsUpdated
'set obj_Command = nothing
'if int_RecordsUpdated = 1 then
'	response.write "Succcess"
'end if
%>
</body>
</html>