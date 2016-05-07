<%@ Language=VBScript %>
<%Option Explicit %>
<%Response.Buffer = True%>
<!-- #Include file="..../includes/library.asp"				-->

<html>
<head>
<title>Myrtle Beach Jan 03</title>
<link href="..../includes/style.css" rel="stylesheet">
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
dim objFSO
dim objFile
dim objFolder
dim sMapPath
dim str_directory

str_directory = "pictures\Shining Rock 2003\thumb"
response.write "<h2>Shining Rock 2003</h2>"	

'----------------------------------------------------------------------------------------
' Get The path for the current dir.
'----------------------------------------------------------------------------------------
Set objFSO = CreateObject("Scripting.FileSystemObject")
sMapPath = server.mappath("\" & str_directory)
Set objFolder = objFSO.GetFolder(sMapPath)

response.write "<table border=1>" & vbcrlf
For Each objFile in objFolder.Files
	
	'------------------------------------------------------------------------------------
	' Skip over this file but diaplay all others.
	'------------------------------------------------------------------------------------
	if not objFile.Name = "curdir.asp" Then
		response.write "<tr>" & vbcrlf
		response.write "<td>"
		'if left(objFile.Name,3) = "tn_" then
			response.Write "<a href='" & "" & str_directory & "/" & right(objFile.Name, (len(objFile.Name)-3)) & "'>" & "<IMG SRC='" & objFile.Name & "' ALT='" & objFile.Name & "' border='0'>" & "</a>"
		'else
			'response.Write "<a href='" & objFile.Name & "'>" & objFile.Name & "</a>"
		'end if
		response.write "</td>" & vbcrlf
		response.write "<td>"	
		response.Write objFile.DateLastModified
		response.write "</td>" & vbcrlf
		response.write "<td>"
		
			'----------------------------------------------------------------------------
			' Properly format the file size.
			'----------------------------------------------------------------------------
			If objFile.Size <1024 Then
				Response.Write objFile.Size & " Bytes"
			ElseIF objFile.Size < 1048576 Then
				Response.Write Round(objFile.Size / 1024.1) & " KB"
			Else
				Response.Write Round((objFile.Size/1024)/1024.1) & " MB"
			End If
		response.write "</TD>" & vbcrlf
		response.write "</tr>" & vbcrlf
	End if
Next
response.write "</table>" & vbcrlf
%>
</body>
</html>