<%@ Language=VBScript %>
<%Option Explicit %>
<%Response.Buffer = True%>
<!-- 
COPYRIGHT NOTICE. 
All rights reserved. Any rights not expressly granted are reserved.
Copyright © 2002 Crucible Systems
-->
<!-- #Include file="includes/connection.asp" 			-->
<!-- #Include file="includes/library.asp"				-->
<html>
<head>
<title>Committee Meeting Minutes</title>
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
int_PageName = 68
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
<h2>Picture Upload</h2><br><br>
<FORM method="post" encType="multipart/form-data" action="\upload\ToFileSystem2.asp">
<table>
<tr>
<td>File Name</td>
<td><input type="file" name="File1" size="50"></td>
</tr>
<tr>
<td>&nbsp;</td>
<td><INPUT type="Submit" value="Upload"></td>
</tr>
</table>
</FORM>
<%
if request("id") = "I" then
	gls_LogPage int_PageName, request("REMOTE_HOST")
	response.write "<h3>Invalid File Type</h3>"
end if
if request("id") = "S" then
	gls_LogPage int_PageName, request("REMOTE_HOST")
	response.write "<h3>File Uploaded</h3>"
end if
dim objFSO
dim objFile
dim objFolder
dim sMapPath
Set objFSO = CreateObject("Scripting.FileSystemObject")
sMapPath = "c:\webdirs\Troop18\Pictures\"
Set objFolder = objFSO.GetFolder(sMapPath)
response.write"<table>"	
response.write"<tr><th>File Name</th><th>File Date</th><th>File Size</th></tr>"
For Each objFile in objFolder.Files
	response.write"<tr>"	
	response.Write "<td><a href='Pictures/" & objFile.Name & "'>" & objFile.Name & "</a></td>"
	response.write "<td>" & objFile.DateLastModified & "</td>"
	response.write "<td>"
  	If objFile.Size < 1024 Then
  		Response.Write objFile.Size & " bytes"
  	ElseIF objFile.Size < 1048576 Then
  		Response.Write Round(objFile.Size / 1024.1) & " kb"
 	Else
		Response.Write Round((objFile.Size/1024)/1024.1) & " mb"
	End If
	response.write "</td>"
Next
response.write"</table>"
%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>