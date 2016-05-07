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

Dim Conn
Dim Cmd
Dim Redirect

if request("MID") > 0 then
	set Conn = Server.CreateObject("ADODB.Connection")
	Conn.ConnectionString = g_ConnectionString
	Conn.Open  
	set Cmd = Server.CreateObject("ADODB.Command")
	with Cmd
		.ActiveConnection = g_ConnectionString
		.CommandText = "usp_Delete_Meeting"
		.CommandType = adCmdStoredProc
		.Prepared = true
		.CommandTimeout = 30
		.Parameters.append Cmd.CreateParameter("SegmentID",adInteger,adParamInput)
	end with
	Cmd("SegmentID") = Request("MID")
	Cmd.execute
	set Cmd = nothing
	Redirect = "Meetings.asp"
	Response.Redirect(Redirect)
end if
%>
</form>
</BODY>
</HTML>