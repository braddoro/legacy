<%@ Language=VBScript %>
<%Option Explicit %>
<%Response.Buffer = True

'--------------------------------------------------------------------------
' Connections string to connect to the db. Change to suit.
'--------------------------------------------------------------------------
dim str_ConnectionString
'str_ConnectionString = "driver={SQL Server};SERVER=bear;UID=sa;PWD=alvahugh;DATABASE=blog"
str_ConnectionString = "Driver={Microsoft Access Driver (*.mdb)};Dbq=C:\webdirs\troop18\includes\troop18.mdb;"

'--------------------------------------------------------------------------
' Max length of a query, this should be the same size of the db table.
'--------------------------------------------------------------------------
dim int_maxlength
int_maxlength = 4000

'--------------------------------------------------------------------------
' Inline style to make the screen look better.
'--------------------------------------------------------------------------
%>
<style>
.title {
	color: White;
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold
}
.even {
	background: #FAFAD2;
	color: Black;
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.odd {
	background: #CECECE;
	color: black;
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.head {
	background: #7C7C7C;
	color: white;
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold
}
.foot {
	background: #7C7C7C;
	color: white;
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 10px;
}	
.body {
	background: #466587;
	color: White;	
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.table {
	background: #E1E1E1;
	color: Black;
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 10px;
	padding: 0px;
	border-collapse: collapse;
	border: thin solid;
}
</style>
<%
response.write "<html>"
response.write "<head>"
response.write "<title>SQL Thing</title>"
response.write "<span class='title'>SQL Thing</span>"
response.write "</head>"
response.write "<body class='body'>"
response.write "<h4>Query</h4>"
Dim objConn
Dim objRS
Dim x 
Dim Total
Dim SQL
Dim Cols
Dim SQLString
Dim SQLDescription
Set objConn = Server.CreateObject("ADODB.Connection")
objConn.ConnectionString = str_ConnectionString
Server.ScriptTimeout = 240
objConn.ConnectionTimeout = 30
objConn.CommandTimeout = 240
objConn.Open

SQLString = request("TheSQL")
'--------------------------------------------------------------------------
' Input form.
'--------------------------------------------------------------------------
response.write "<form action='sql-access.asp' method='post' name='send' id='send'>"
response.write "<textarea cols='100' rows='20' name='TheSQL' id='TheSQL'>" & SQLString & "</textarea><br>"
response.write "<input type='submit' id='submit' value='submit'> "
response.write "</form>"

if len(SQLString) > 0 then
	response.write "<h4>Output</h4>"
	Set objRS=Server.CreateObject("ADODB.Recordset")
	objRS.Open SQLString, objConn
	
	'--------------------------------------------------------------------------
	' Cycle through the queue recordsets.
	'--------------------------------------------------------------------------
	Do Until objRS Is Nothing
		response.write "<table class='table'>"
		response.write "<tr>"
		
		'----------------------------------------------------------------------
		' Write the headings.
		'----------------------------------------------------------------------
		Cols = 0
		For x = 0 to (objRS.Fields.count - 1)
			Cols = Cols + 1
			Response.Write "<td class='head'>" & objRS.Fields(x).Name & "</td>"
		Next 
		response.write "</tr>"
		Total = 0
		
		'----------------------------------------------------------------------
		' Write the detail for this queue.
		'----------------------------------------------------------------------
		Do While Not objRS.EOF
			response.write "<tr>"
			
			if Total MOD 2 = 0 then
				response.write "<tr class='odd'>"
			else
				response.write "<tr class='even'>"
			end if
			
			For x = 0 to (objRS.Fields.count - 1)
				Response.Write "<TD>" & objRS.Fields(x) & "</TD>"
			Next 
			response.write "</tr>"
			Total = Total + 1
			objRS.MoveNext
		Loop
		response.write "<tr><td colspan='" & Cols & "' class='foot'>Rows: " & Total & "</td></tr>"
		response.write "</table>"
		response.write "<BR>"
		Set objRS = objRS.NextRecordset
	Loop
	Set objRS = Nothing
	Set objConn = Nothing
end if
response.write "</body>"
response.write "</html>"
%>