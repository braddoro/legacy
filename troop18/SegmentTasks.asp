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

<!--#include file="constants.asp"-->
<HTML>
<HEAD>
<link rel='stylesheet' href='<% response.write g_StyleSheet %>'>
</HEAD>
<BODY>
<p class='subhead'>Meetings</p>
<a href='MeetingSegments.asp?MID=<% response.write session("MeetingID") %>'>Meeting Segments</a>
<% 

Dim objConn
Dim objRS
Dim lint_Temp
Dim sSQL
Dim x 

Dim Conn
Dim Cmd
Dim Redirect

if request("Submit") = "Submit" then
	set Conn = Server.CreateObject("ADODB.Connection")
	Conn.ConnectionString = g_ConnectionString
	Conn.Open  
	set Cmd = Server.CreateObject("ADODB.Command")
	with Cmd
		.ActiveConnection = g_ConnectionString
		.CommandText = "usp_Update_SegmentTask"
		.CommandType = adCmdStoredProc
		.Prepared = true
		.CommandTimeout = 30
		.Parameters.append Cmd.CreateParameter("SegmentTaskID",adInteger,adParamInput)
		.Parameters.append Cmd.CreateParameter("TaskOrder",adInteger,adParamInput)
		.Parameters.append Cmd.CreateParameter("Leader",adVarChar,adParamInput,30)
		.Parameters.append Cmd.CreateParameter("EstimatedTime",adInteger,adParamInput)
		.Parameters.append Cmd.CreateParameter("SegmentTask",adVarChar,adParamInput,50)
		.Parameters.append Cmd.CreateParameter("TaskDescription",adVarChar,adParamInput,100)
	end with
	Cmd("SegmentTaskID") = int(request("SegmentTaskID"))
	Cmd("TaskOrder") = int(request("TaskOrder"))
	Cmd("Leader") = Request("Leader")
	Cmd("EstimatedTime") = int(Request("EstimatedTime"))
	Cmd("SegmentTask") = Request("SegmentTask")
	Cmd("TaskDescription") = Request("TaskDescription")
	Cmd.execute
	set Cmd = nothing
	Redirect = "SegmentTasks.asp?TID=" & request("SegmentTaskID")
	Response.Redirect(Redirect)
end if

'--------------------------------------------------------------------------
' Open the data acccess objects.
'--------------------------------------------------------------------------
Set objConn = Server.CreateObject("ADODB.Connection")
objConn.ConnectionString = g_ConnectionString
Server.ScriptTimeout = 240
objConn.ConnectionTimeout = 30
objConn.CommandTimeout = 240
objConn.Open
Set objRS=Server.CreateObject("ADODB.Recordset")
sSql="usp_Select_SegmentTask " & request("TID")
'Response.write sSql
objRS.Open sSql, objConn

'----------------------------------------------------------------------
' Write the detail for this queue.
'----------------------------------------------------------------------
response.write "<form action='SegmentTasks.asp' method='post' name='Edit' id='Edit'>" & vbcrlf
response.write "<table>"
Do While Not objRS.EOF
	For x = 0 to (objRS.Fields.count - 1)
		if ((objRS.Fields(x).Name = "AddedDate") or (right(objRS.Fields(x).Name,2) = "ID") or (right(objRS.Fields(x).Name,5) = "ID_fk")) then
			response.write "<input type='hidden' name='" & objRS.Fields(x).Name & "' id='" & objRS.Fields(x).Name & "' value='" & objRS.Fields(x) & "'>" & vbcrlf
		else
			response.write "<tr>"
			response.write "<th>" & objRS.Fields(x).Name & "</th>"
			response.write "<td><input type='text' name='" & objRS.Fields(x).Name & "' id='" & objRS.Fields(x).Name & "' value='" & objRS.Fields(x) & "' size='" & objRS.Fields(x).DefinedSize & "' maxlength='" & objRS.Fields(x).DefinedSize & "'></td>"
			response.write "</tr>" & vbcrlf
		end if
	Next
	objRS.MoveNext
Loop
response.write "<tr>"
response.write "<td>&nbsp;</td>"
response.write "<td><input type='submit' name='Submit' id='Submit' value='Submit'></td>"
response.write "</tr>"
response.write "</table>"
response.write "</form>"
Set objRS = Nothing
Set objConn = Nothing
%>
</form>
</BODY>
</HTML>