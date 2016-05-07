<%@ Language=VBScript %>
<%option explicit%>
<%Response.Buffer = True %>
<!--#include file="adovbs.inc"-->
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
		Response.Write "<th>" & objRS.Fields(x).Name & "</th>"
	Next 
	response.write "</tr>"

	'----------------------------------------------------------------------
	' Write the detail for this queue.
	'----------------------------------------------------------------------
	Do While Not objRS.EOF
		response.write "<tr>"
		For x = 0 to (objRS.Fields.count - 1)
			Response.Write "<td>" & objRS.Fields(x) & "</td>"
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