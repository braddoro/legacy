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
<title>Pictures</title>
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
int_PageName = 46
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
	RESPONSE.write "<h2>Downloads</h2><br><br>"
    	'File System Object
    	dim objFSO
    	'File Object
    	dim objFile
    	'Folder Object
    	dim objFolder
    	'String To Store The Real Path
    	dim sMapPath
    	'Create File System Object to get list of files
    	Set objFSO = CreateObject("Scripting.FileSystemObject")
    	'Get The path for the web page and its dir.
    	'change this setting to view different directories
		sMapPath = "c:\webdirs\Troop18\Downloads"
    	'Set the object folder to the mapped path
    	Set objFolder = objFSO.GetFolder(sMapPath)
    	'For Each file in the folder
		response.write"<table>"	
    	For Each objFile in objFolder.Files
				response.write"<tr><td>"	
				response.Write "<a href='downloads/" & objFile.Name & "'>" & objFile.Name & "</a>" & " - " & objFile.DateLastModified & " - " & objFile.Size
				response.write "</td></tr>"

				'response.write "</a></font></TD><TD><font size='2' face='Verdana, Arial, Helvetica, sans-serif' color='#000000'>"
    			'We will format the file size so it looks pretty
    			'If objFile.Size <1024 Then
    			'	Response.Write objFile.Size & " Bytes"
    			'ElseIF objFile.Size < 1048576 Then
    			'	Response.Write Round(objFile.Size / 1024.1) & " KB"
    			'Else
    			'	Response.Write Round((objFile.Size/1024)/1024.1) & " MB"
    			'End If
				'response.write "</font></TD><TD><font size='2' face='Verdana, Arial, Helvetica, sans-serif' color='#000000'>"
				'the files date 
    			'Response.Write objFile.DateLastModified
    			'response.write "</font></TD></font></td></Tr>"
    	Next
		response.write"</table>"	
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>