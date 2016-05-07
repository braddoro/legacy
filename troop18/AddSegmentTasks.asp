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

'response.write Request.querystring

if request("Submit") = "Submit" then
	set Conn = Server.CreateObject("ADODB.Connection")
	Conn.ConnectionString = g_ConnectionString
	Conn.Open  
	set Cmd = Server.CreateObject("ADODB.Command")
	with Cmd
		.ActiveConnection = g_ConnectionString
		.CommandText = "usp_Insert_SegmentTask"
		.CommandType = adCmdStoredProc
		.Prepared = true
		.CommandTimeout = 30
		.Parameters.append Cmd.CreateParameter("MeetingSegmentID",adInteger,adParamInput)
		.Parameters.append Cmd.CreateParameter("TaskOrder",adInteger,adParamInput)
		.Parameters.append Cmd.CreateParameter("Leader",adVarChar,adParamInput,30)
		.Parameters.append Cmd.CreateParameter("EstimatedTime",adInteger,adParamInput)
		.Parameters.append Cmd.CreateParameter("SegmentTask",adVarChar,adParamInput,50)
		.Parameters.append Cmd.CreateParameter("TaskDescription",adVarChar,adParamInput,100)
	end with
	Cmd("MeetingSegmentID") = int(request("MeetingSegmentID_fk"))
	Cmd("TaskOrder") = int(request("TaskOrder"))
	Cmd("Leader") = Request("Leader")
	Cmd("EstimatedTime") = int(Request("EstimatedTime"))
	Cmd("SegmentTask") = Request("SegmentTask")
	Cmd("TaskDescription") = Request("TaskDescription")
	Cmd.execute
	set Cmd = nothing
	Redirect = "AddSegmentTasks.asp?SID=" & request("MeetingSegmentID_fk")
	Response.Redirect(Redirect)
end if
%>
<tr><th></th>
<td></td>
</tr>
<%
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
sSql="usp_Select_SegmentTasks " & request("SID")
'Response.write sSql
objRS.Open sSql, objConn

Response.Write "<form action='AddSegmentTasks.asp' method='post' name='Add' id='Add'>"
Response.Write "<input type='hidden' name='SID' id='SID' value='" & Request("SID") & "'>"
Response.Write "<table>"

For x = 0 to (objRS.Fields.count - 1)
	if ((objRS.Fields(x).Name = "AddedDate") or (right(objRS.Fields(x).Name,2) = "ID") or (right(objRS.Fields(x).Name,5) = "ID_fk")) then
		response.write "<input type='hidden' name='" & objRS.Fields(x).Name & "' id='" & objRS.Fields(x).Name & "' value='" & objRS.Fields(x) & "'>" & vbcrlf
	else
		Response.Write "<tr><th>" & objRS.Fields(x).Name & "</th><td><input type='text' name='" & objRS.Fields(x).Name & "' id='" & objRS.Fields(x).Name & "' value='' size='" & objRS.Fields(x).DefinedSize & "' maxlength='" & objRS.Fields(x).DefinedSize & "'></td></tr>"
	end if
Next 
response.write "<tr>"
response.write "<td>&nbsp;</td>"
response.write "<td><input type='submit' name='Submit' id='Submit' value='Submit'></td>"
response.write "</tr>"
Response.Write "</table>"
Response.Write "</form>"

'----------------------------------------------------------------------
' Write the detail for this queue.
'----------------------------------------------------------------------
Do Until objRS Is Nothing
	response.write "<table border='0'>"
	response.write "<tr>"
		
	'----------------------------------------------------------------------
	' Write the headings.
	'----------------------------------------------------------------------
	For x = 0 to (objRS.Fields.count - 1)
		if not ((right(objRS.Fields(x).Name,2) = "ID") or (right(objRS.Fields(x).Name,5) = "ID_fk")) then
			Response.Write "<th>" & objRS.Fields(x).Name & "</th>"
		end if
	Next 
	response.write "</tr>"

	'----------------------------------------------------------------------
	' Write the detail for this queue.
	'----------------------------------------------------------------------
	Do While Not objRS.EOF
		response.write "<tr>"
		For x = 0 to (objRS.Fields.count - 1)
			if objRS.Fields(x).Name = "SegmentTask" then
				if isnull(objRS.Fields(x)) then
					response.write "<td><a href='SegmentTasks.asp?TID=" & objRS.Fields("SegmentTaskID") & "'>*</a></td>"
				else
					response.write "<td><a href='SegmentTasks.asp?TID=" & objRS.Fields("SegmentTaskID") & "'>" & objRS.Fields(x) & "</a></td>"
				end if
			else
				if not ((right(objRS.Fields(x).Name,2) = "ID") or (right(objRS.Fields(x).Name,5) = "ID_fk")) then
					Response.Write "<td>" & objRS.Fields(x) & "</td>"
				end if
			end if
		Next 
		response.write "<td><a href='DeleteTask.asp?TID=" & objRS.Fields("SegmentTaskID") & "&SID=" & request("SID") & "'>[delete]</a></td>"
		response.write "</tr>"
		objRS.MoveNext
	Loop
	response.write "</table>"

	'----------------------------------------------------------------------
	' Write the summary info.
	'----------------------------------------------------------------------
	response.write "<br>"
	Set objRS = objRS.NextRecordset
Loop
Set objRS = Nothing
Set objConn = Nothing

%>
</form>
</BODY>
</HTML>