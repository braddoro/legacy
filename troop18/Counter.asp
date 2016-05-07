<%Response.Buffer = True%>
<%
dim str_ClientIP
dim str_FileToOpen
dim int_Hits
dim FileObject
dim InStream
dim OutStream

'----------------------------------------------------------------------------------------
' Get the IP address of the connected computer.
'----------------------------------------------------------------------------------------
str_ClientIP = request.servervariables("REMOTE_HOST")

'----------------------------------------------------------------------------------------
' Get the current number of hits, add one to it, report the number and save the new 
' number back to the file.
'----------------------------------------------------------------------------------------
Set FileObject = Server.CreateObject("Scripting.FileSystemObject")
str_FileToOpen = Server.MapPath("includes") & "\counter.txt"
Set InStream = FileObject.OpenTextFile (str_FileToOpen, 1, false)
int_Hits = Trim(InStream.ReadLine) + 1
Set OutStream = FileObject.CreateTextFile (str_FileToOpen, True)
OutStream.WriteLine(int_Hits)
InStream.close
OutStream.close
Set FileObject = Nothing
Set InStream = Nothing
Set OutStream = Nothing

'----------------------------------------------------------------------------------------
' Update the log file with the latest information.
'----------------------------------------------------------------------------------------
Set FileObject = CreateObject("Scripting.FileSystemObject")
str_FileToOpen = Server.MapPath("includes") & "\ipaddr.txt"
If FileObject.FileExists(str_FileToOpen) = True Then
   Set OutStream = FileObject.OpenTextFile(str_FileToOpen,8,False,0)
Else
   Set OutStream = FileObject.CreateTextFile(str_FileToOpen,False,False)
End If
OutStream.WriteLine str_ClientIP & " - " & int_Hits & "  -  " & Now
OutStream.close
Set FileObject = Nothing
Set OutStream = Nothing

'----------------------------------------------------------------------------------------
' Output the stats.
'----------------------------------------------------------------------------------------
Response.Write "<br><H6>" & str_ClientIP & " - " & int_Hits & "</h6>"
%>