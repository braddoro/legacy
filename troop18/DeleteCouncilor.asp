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

<HTML>
<HEAD>
<link rel='stylesheet' href='/includes/troop18.css'>
</HEAD>
<BODY>
<%

Dim Conn
Dim Cmd
Dim Redirect

if request("ID") > 0 then
	set Conn = Server.CreateObject("ADODB.Connection")
	Conn.ConnectionString = str_ConnectionString
	Conn.Open  
	set Cmd = Server.CreateObject("ADODB.Command")
	with Cmd
		.ActiveConnection = str_ConnectionString
		.CommandText = "Delete from Councilors where CouncilorID = " & request("ID")
		.CommandType = adCmdText
		.Prepared = true
		.CommandTimeout = 30
		.Parameters.append Cmd.CreateParameter("ID",adInteger,adParamInput)
	end with
	Cmd("ID") = Request("ID")
	Cmd.execute
	set Cmd = nothing
	Redirect = "CouncilorAdd.asp?member=" & request("MID")
	Response.Redirect(Redirect)
end if
%>
</form>
</BODY>
</HTML>