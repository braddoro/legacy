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
<title>Add News</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
gls_LogPage 47, request("REMOTE_HOST")
%>
<table width='100%' border='0'>
<!-- The header row. -->
<tr>
<th colspan='2'>
<% response.write str_LeftSideImage %> <h3><% response.write str_PageTitle %></h3>
</td>
</tr>
<tr><td colspan='3'><hr width='100%' size='1'></td></tr>
<!-- The detail row. -->
<tr>
<!-- The List cell. -->
<td width='15%' valign='top'>
<%
int_PageName = 47
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
<h2>HTML Help</h2><br><br>
<h4>Text entered like this:</h4><br><br>
<img src='images/html example code.jpg' alt='' width='508' height='412' border='0'><br>
<br><h4>Will look like this:</h4><br><br>
This example shows how to add HTML formatted text.
<br><br>
This sentence will be seperated from the prior sentence due to the use of two break tags.<br>  The break tag can also be use at the end of a sentence in order to force the start of text on a new line like this.
<br><br>
<B>This line will be bold due to the use of the strong tag.</B>
<br><br>
<U>This line will be underlined due to the use of the underline tag.</U>
<br><br>
<I>This line will be underlined due to the use of the italic tag.</I>
<br><br>
Anchor tags can be used in text to refer to external links like this link <a href='http://www.google.com'>google</a> or to add an email link like this one <a href='mailto:braddoro@yahoo.com'>email me</a>.
<br><br>
The <font color='red'>font</font> tag can be used to change colors.
<hr size='1px'>
<br><h4>This is not the limit of the things that you can do but only a brief primer to get you started. 
You can use tables, images, and practically any HTML tag when entering text.
Refer to a book on html or to an online reference for more details.</h4>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>