<%@ Language=VBScript %>
<%Response.Buffer = True%>
<!-- #Include file="includes/connection.asp" -->
<!-- #Include file="includes/library.asp" -->
<HTML>
<HEAD>
<title>Browse Pictures</title>
<link rel='stylesheet' href='<% response.write g_StyleSheet %>'>
<a href='<% response.write g_startpage %>'>back to <% response.write Request.ServerVariables("SERVER_NAME") %></a>

</HEAD>
<BODY>
<%
if pthFolder = "." then
	Response.End()
end if
If Request.QueryString("fold")<>"" then 
	pthFolder=pthFolder&"/"&Request.QueryString("fold")
else
	pthFolder="/"
end if
Set fso=Server.CreateObject("Scripting.FileSystemObject")

'gls_LogPage 999, request("REMOTE_HOST"), Session("UserID")

'check if folder exists or not and exit if it does not exist.
If not fso.FolderExists(server.mappath(pthFolder)) then
	Response.Write "<br><br><h3>The specified folder either cannot be displayed or does not exist</h3>"
	Response.End()
end if
'get all required info
sParentFolder=fso.GetParentFolderName(pthFolder)
If sParentFolder="" then sParentFolder="/"
If left(sParentFolder,1)="/" or left(sParentFolder,1)="\" then sParentFolder=Mid(sParentFolder,2)
sBackURL="Picturebrowse.asp?fold="&sParentFolder
Set Folder=fso.GetFolder(Server.MapPath(pthFolder))
'get number of folders present - trash variables after use.
Set collFolder=Folder.subFolders
iFolderCount=collFolder.count
set collFolder=nothing
'get number of files present - trash variables after use.
Set collFiles=Folder.files
iFileCount=collFiles.count
set collFiles=nothing
'correct the pthFolder variable if it starts with a slash
'we will not be using the mappath method anymore, so we can discard the slash
If left(pthFolder,1)="/" or left(pthFolder,1)="\" then pthFolder=Mid(pthFolder,2)
'now, if the folder name does not end with a slash, then add a slash
If len(pthFolder)>0 and right(pthFolder,1)<>"/" and right(pthFolder,1)<>"\" then _
pthFolder=pthFolder&"/"
'okay, now show the list of files in the folder
Response.Write "<table class='border'>"
Response.Write "<tr><td colspan='8' align='center'>Files in: " & pthFolder  & "</td></tr>"
Response.Write "<tr><td colspan='8' align='center'>" & iFileCount & " files and " & iFolderCount & " folders</td></tr>"
Response.Write "<tr class='category'>"
Response.Write "<th><a href='" & sBackURL & "' title='up one level'><img src='img/back.gif' border=0></a></th>"
Response.Write "<th>File Name</th>"
Response.Write "<th>File Size<sup>*</sup></th>"
Response.Write "<th>File Type</th>"
Response.Write "<th>Date Last Modified</th>"
Response.Write "</tr>"
FolderSize=0
for each item in Folder.files
	if lcase(left(pthFolder,9)) = "pictures" then
		If item.Size>512 then
			FileSize=Clng(item.Size/1024)&" kb"
		else
			FileSize=item.Size&" bytes"
		end if
		RowNumber = RowNumber + 1
		if RowNumber MOD 2 = 0 then
			response.write "<tr class='odd'>"
		else
			response.write "<tr class='even'>"
		end if
		response.write "<td><IMG src='img/file.gif' border=0></td>"
		response.write "<td><a href='" & pthFolder & item.Name & "'>" & item.Name & "</a></td>"
		response.write "<td>" & FileSize & "</td>"
		response.write "<td>" & fit(item.Type,20) & "</td>"
		response.write "<td>" & item.DateLastModified & "</td>"
		response.write "</tr>"
		FolderSize = FolderSize + item.Size
		FilesExist = true
	end if
next

If not filesexist then 
	Response.Write("<tr class='even'><td colspan=8 align=left>No files to display</td>")
end if
'display folder information
Response.Write "<tr><td colspan=8 class=highlights align=center>Size of Folder(inc sub folders) : "&Clng(Folder.Size/1024)& " kb<br>Total size of files displayed : " & Clng(FolderSize/1024)&" kb</td></tr>"
Response.Write "<tr class='category'><th><a href="""&sBackURL& """ title=""up one level""><img src=""img/back.gif"" border=0></a></th><th colspan=3>Folders</th><th colspan=4>Date Last Modified</th></tr>"
if (pthFolder = "" or request("fold") = ".") then
	response.write "<tr class='even'>"
	response.write "<td colspan='8'><A href='picturebrowse.asp?fold=pictures'>Browse Available Files</a></td>"
	response.write "</TR>"
	foldersexist=true
else
	for each item in Folder.SubFolders
		RowNumber = RowNumber + 1
		if RowNumber MOD 2 = 0 then
			response.write "<tr class='odd'>"
		else
			response.write "<tr class='even'>"
		end if
		response.write "<td><IMG src='img/folder.gif' border=0></td>"
		response.write "<td colspan='3'><A href='picturebrowse.asp?fold=" & pthFolder & item.Name & "'>" & item.Name & "/</a></td>"
		response.write "<td colspan='4'>" & item.DateLastModified & "</td>"
		response.write "</TR>"
		foldersexist=true	
	next
end if
If not foldersexist then 
	Response.Write("<tr class='even'><td colspan=8 align=left>No folders to display</td>")
end if
Response.Write "<tr><td colspan=8 align='center'>Please note that some files contain a quote character (') in them that may cause the file link to break.  If this happens ona file you want, let me know and I'll fix it.</td>"
Response.Write "</table>"
%>

<%
function fit(text,length)
	'function to make text fit a given length, so that it does not overflow the cell width.
	If len(text)>(length-3) then
		text=left(text,(length-3))
		text=text&"..."
		fit=text
	else
		fit=text
	end if
end function
%> 
</BODY>
</HTML>