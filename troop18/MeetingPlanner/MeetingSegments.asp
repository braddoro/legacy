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

Dim objConn
Dim objRS
Dim lint_Temp
Dim sSQL
Dim x 

session("MeetingID") = request("MID") 
response.write "MeetingID" & session("MeetingID") & "|<br>"

response.write "<a href='Meetings.asp'>Meetings</a>|<a href='AddSegment.asp?mid=" & session("MeetingID") & "'>Add Segment</a><br>"
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
sSql="usp_Select_MeetingPlan " & session("MeetingID")
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
			if (objRS.Fields(x).Name = "SegmentTask" or objRS.Fields(x).Name = "SegmentType") then
			
				if objRS.Fields(x).Name = "SegmentTask" then
					if isnull(objRS.Fields(x)) then
						response.write "<td><a href='SegmentTasks.asp?TID=" & objRS.Fields("SegmentTaskID") & "'>*</a></td>"
					else
						response.write "<td><a href='SegmentTasks.asp?TID=" & objRS.Fields("SegmentTaskID") & "'>" & objRS.Fields(x) & "</a></td>"
					end if
				end if
				
				if objRS.Fields(x).Name = "SegmentType" then
					response.write "<td><a href='AddSegmentTasks.asp?SID=" & objRS.Fields("MeetingSegmentID") & "'>" & objRS.Fields(x) & "</a></td>"
				end if
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