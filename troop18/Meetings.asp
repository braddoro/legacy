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
<%

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
		.CommandText = "usp_Insert_Meeting"
		.CommandType = adCmdStoredProc
		.Prepared = true
		.CommandTimeout = 30
		.Parameters.append Cmd.CreateParameter("MeetingType",adInteger,adParamInput)
		.Parameters.append Cmd.CreateParameter("MeetingTime",adVarChar,adParamInput,20)
		.Parameters.append Cmd.CreateParameter("Theme",adVarChar,adParamInput,50)
	end with
	Cmd("MeetingType") = int(request("MeetingType"))
	Cmd("MeetingTime") = request("MeetingTime")
	Cmd("Theme") = Request("Theme")
	Cmd.execute
	set Cmd = nothing
	Redirect = "Meetings.asp"
	Response.Redirect(Redirect)
end if
%>

<form action='Meetings.asp' method='post' name='Add' id='Add'>
<table>

<tr>
<th>Meeting Time</th>
<td><input type='text' name='MeetingTime' id='MeetingTime' size='20' maxlength='20'></td>
</tr>

<tr>
<th>Meeting Type</th>
<td>
<%
Dim Rec2
Dim Conn2
Dim SQL2
set Conn2 = Server.CreateObject("ADODB.Connection")
Conn2.ConnectionString = g_ConnectionString
Conn2.Open  
set Rec2 = Server.CreateObject("ADODB.Recordset")
SQL2 = "usp_Select_MeetingTypes"
Rec2.Open Sql2, Conn2
Response.Write "<SELECT id='MeetingType' name='MeetingType'>"
Response.Write "<option value='0'></option>"
Do while not Rec2.EOF
	if trim(Request("MeetingType")) = trim(Rec2("MeetingTypeID")) then
		Response.Write "<option value='" & Rec2("MeetingTypeID") & "' SELECTED>" & Rec2("MeetingType") & "</option>" & vbcrlf
	else
		Response.Write "<option value='" & Rec2("MeetingTypeID") & "'>" & Rec2("MeetingType") & "</option>" & vbcrlf
	end if
	Rec2.MoveNext
loop
Response.Write "</select>" & vbcrlf
Rec2.Close
Conn2.close
set Rec2 = nothing
set Conn2 = nothing
%>
</td>
</tr>

<tr>
<th>Theme</th>
<td><input type='text' name='Theme' id='theme' size='30' maxlength='30'></td>
</tr>

<tr>
<td>&nbsp;</td>
<td><input type='submit' name='Submit' id='Submit' value='Submit'></td>
</tr>

</table>
</form>
<% 
Dim objConn
Dim objRS
Dim lint_Temp
Dim sSQL
Dim x 

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
sSql="usp_Select_Meetings"
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
			if objRS.Fields(x).Name = "MeetingDate" then
				response.write "<td><a href='MeetingSegments.asp?MID=" & objRS.Fields("MeetingID") & "'>" & objRS.Fields(x) & "</a></td>"
			else
				if not ((right(objRS.Fields(x).Name,2) = "ID") or (right(objRS.Fields(x).Name,5) = "ID_fk")) then
					Response.Write "<td>" & objRS.Fields(x) & "</td>"
				end if
			end if
			
		Next 
		response.write "<td><a href='DeleteMeeting.asp?MID=" & objRS.Fields("MeetingID") & "'>[delete]</a></td>"
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