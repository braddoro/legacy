<!--#INCLUDE FILE="clsUpload.asp"-->
<%
Dim objUpload
Dim strFileName
Dim strPath
dim str_Temp
dim str_CompareTo
dim str_OutPut
dim str_PagePath
dim X

str_PagePath = "http://www.bsatroop18.org/MMUpload.asp"

' Instantiate Upload Class
Set objUpload = New clsUpload

' Grab the file name
strFileName = objUpload.Fields("File1").FileName

if len(strFileName) > 0 then 
	str_OutPut = trim(strFileName)
	for x = len(str_OutPut) to 0 step -1
		if mid(str_OutPut,x,1) = "." then
			str_OutPut = lcase(right(str_OutPut,len(str_OutPut)-x))
			exit for
		end if
	next
	str_CompareTo = ".asax" & _
	".ascx" & _
	".ashx" & _
	".asmx" & _
	".aspx" & _
	".ade" & _
	".adp" & _
	".asa" & _
	".asp" & _
	".asx" & _
	".axd" & _
	".bas" & _
	".bat" & _
	".cfm" & _
	".cs" & _
	".cdx" & _
	".config" & _
	".csproj" & _
	".cfml" & _
	".cer" & _
	".chm" & _
	".cmd" & _
	".com" & _
	".cpl" & _
	".crt" & _
	".dbm" & _
	".dll" & _
	".exe" & _
	".hlp" & _
	".hta" & _
	".htr" & _
	".htm" & _
	".html" & _
	".idc" & _
	".inf" & _
	".ins" & _
	".isp" & _
	".js" & _
	".jse" & _
	".licx" & _
	".lnk" & _
	".mdb" & _
	".mde" & _
	".mdt" & _
	".mdw" & _
	".mdz" & _
	".msc" & _
	".msi" & _
	".msp" & _
	".mst" & _
	".pcd" & _
	".printer" & _
	".pif" & _
	".pl" & _
	".pm" & _
	".php" & _
	".reg" & _
	".red" & _
	".resx" & _
	".resources" & _
	".scf" & _
	".soap" & _
	".scr" & _
	".sct" & _
	".shb" & _
	".shtm" & _
	".shtml" & _
	".stm" & _
	".shs" & _
	".url" & _
	".vb" & _
	".vbe" & _
	".vbs" & _
	".vbproj" & _
	".vsdisco" & _
	".ws" & _
	".webinfo" & _
	".wsc" & _
	".wsf" & _
	".wsh"
	if instr(str_CompareTo,str_OutPut) > 0 then
		' bad extention
		response.redirect str_PagePath & "?id=I"
	else 
		' good extention
		strPath = Server.MapPath("..\MeetingMinutes") & "\" & strFileName
		objUpload("File1").SaveAs strPath
		Set objUpload = Nothing
		response.redirect str_PagePath & "?id=S"

	end if
end if
%>