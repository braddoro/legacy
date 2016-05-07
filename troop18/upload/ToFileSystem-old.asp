<!--#INCLUDE FILE="clsUpload.asp"-->
<%
Dim objUpload
Dim strFileName
Dim strPath
dim str_Temp
dim str_Password

'str_Password = trim(lcase(request("Password")))

' Instantiate Upload Class
Set objUpload = New clsUpload

' Grab the file name
strFileName = objUpload.Fields("File1").FileName

if len(strFileName) > 0 then 
	str_Temp = lcase(right(trim(strFileName),3))
	if (str_Temp = "ade" or _
		str_Temp = "adp" or _
		str_Temp = "asp" or _
		str_Temp = "asx" or _
		str_Temp = "bas" or _
		str_Temp = "bat" or _
		str_Temp = "cfm" or _
		str_Temp = "cfml" or _
		str_Temp = "chm" or _
		str_Temp = "cmd" or _
		str_Temp = "com" or _
		str_Temp = "cpl" or _
		str_Temp = "crt" or _
		str_Temp = "dll" or _
		str_Temp = "exe" or _
		str_Temp = "hlp" or _
		str_Temp = "hta" or _
		str_Temp = "htm" or _
		str_Temp = "html" or _
		str_Temp = "inf" or _
		str_Temp = "ins" or _
		str_Temp = "isp" or _
		str_Temp = "js" or _
		str_Temp = "jse" or _
		str_Temp = "lnk" or _
		str_Temp = "mdb" or _
		str_Temp = "mde" or _
		str_Temp = "mdt" or _
		str_Temp = "mdw" or _
		str_Temp = "mdz" or _
		str_Temp = "msc" or _
		str_Temp = "msi" or _
		str_Temp = "msp" or _
		str_Temp = "mst" or _
		str_Temp = "pcd" or _
		str_Temp = "pif" or _
		str_Temp = "pl" or _
		str_Temp = "pm" or _
		str_Temp = "reg" or _
		str_Temp = "scf" or _
		str_Temp = "scr" or _
		str_Temp = "sct" or _
		str_Temp = "shb" or _
		str_Temp = "shs" or _
		str_Temp = "url" or _
		str_Temp = "vb" or _
		str_Temp = "vbe" or _
		str_Temp = "vbs" or _
		str_Temp = "ws" or _
		str_Temp = "wsc" or _
		str_Temp = "wsf" or _
		str_Temp = "wsh" _
		) then
		response.redirect "http://www.bsatroop18.org/upload.asp?id=I"
	else
		'if str_Password = "a" then
			strPath = Server.MapPath("..\MeetingMinutes") & "\" & strFileName
			objUpload("File1").SaveAs strPath
			Set objUpload = Nothing
			response.redirect "http://www.bsatroop18.org/mmupload.asp?id=S"
		'else
		'	response.redirect "http://www.bsatroop18.org/mmupload.asp?id=F"
		'end if
	end if
end if
%>