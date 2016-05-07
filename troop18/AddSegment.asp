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
<a href='MeetingSegments.asp?MID=<% response.write session("MeetingID") %>'>Meeting Segments</a>
<%

Dim objConn
Dim objRS
Dim lint_Temp
Dim sSQL
Dim x 

Dim Rec2
Dim Conn2
Dim SQL2

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
		.CommandText = "usp_Insert_MeetingSegment"
		.CommandType = adCmdStoredProc
		.Prepared = true
		.CommandTimeout = 30
		.Parameters.append Cmd.CreateParameter("MeetingID",adInteger,adParamInput)
		.Parameters.append Cmd.CreateParameter("SegmentID",adInteger,adParamInput)
		.Parameters.append Cmd.CreateParameter("SegmentOrder",adInteger,adParamInput)
	end with
	Cmd("MeetingID") = session("MeetingID")
	Cmd("SegmentID") = Request("SegmentType")
	Cmd("SegmentOrder") = Request("SegmentOrder")
	Cmd.execute
	set Cmd = nothing
	Redirect = "AddSegment.asp?MID=" & session("MeetingID")
	Response.Redirect(Redirect)
end if

response.write "<form action='AddSegment.asp' method='post' name='Add' id='Add'>"
response.write "<table>"
response.write "<tr>"
response.write "<td>Segment Type</td>"
response.write "<td>"
set Conn2 = Server.CreateObject("ADODB.Connection")
Conn2.ConnectionString = g_ConnectionString
Conn2.Open  
set Rec2 = Server.CreateObject("ADODB.Recordset")
SQL2 = "usp_Select_SegmentTypes"
Rec2.Open Sql2, Conn2
Response.Write "<SELECT id='SegmentType' name='SegmentType'>"
Response.Write "<option value='0'></option>"
Do while not Rec2.EOF
	if trim(Request("SegmentType")) = trim(Rec2("SegmentTypeID")) then
		Response.Write "<option value='" & Rec2("SegmentTypeID") & "' SELECTED>" & Rec2("SegmentType") & "</option>" & vbcrlf
	else
		Response.Write "<option value='" & Rec2("SegmentTypeID") & "'>" & Rec2("SegmentType") & "</option>" & vbcrlf
	end if
	Rec2.MoveNext
loop
Response.Write "</select>" & vbcrlf
Rec2.Close
Conn2.close
set Rec2 = nothing
set Conn2 = nothing
response.write "</td>"
response.write "</tr>"

response.write "<tr>"
response.write "<td>Segment Order</td>"
response.write "<td><input type='text' name='SegmentOrder' id='SegmentOrder' value='" & Request("SegmentOrder") & "' size='2' maxlength='2'></td>"
response.write "</tr>"

response.write "<tr>"
response.write "<td>&nbsp;</td>"
response.write "<td><input type='submit' name='Submit' id='Submit' value='Submit'></td>"
response.write "</tr>"

response.write "</table>"
response.write "</form>"

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
sSql="usp_Select_Segments " & session("MeetingID")
'Response.write sSql
objRS.Open sSql, objConn

'--------------------------------------------------------------------------
' Cycle through the queue recordsets.
'--------------------------------------------------------------------------
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
			if objRS.Fields(x).Name = "SegmentType" then
				response.write "<td>" & objRS.Fields(x) & " <a href='DeleteSegment.asp?SID=" & objRS.Fields("MeetingSegmentID") & "'>[delete]</a></td>"
			else
				if not ((right(objRS.Fields(x).Name,2) = "ID") or (right(objRS.Fields(x).Name,5) = "ID_fk")) then
					Response.Write "<td>" & objRS.Fields(x) & "</td>"
				end if
			end if
		Next 
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