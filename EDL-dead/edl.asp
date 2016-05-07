<%@ Language=VBScript %>
<%Option Explicit %>
<%Response.Buffer = True

'--------------------------------------------------------------------------
' Connections string to connect to the db. Change to suit.
'--------------------------------------------------------------------------
dim str_ConnectionString
str_ConnectionString = "driver={SQL Server};SERVER=bear;UID=sa;PWD=alvahugh;DATABASE=eld"

'--------------------------------------------------------------------------
' Max length of a query, this should be the same size of the db table.
'--------------------------------------------------------------------------
dim int_maxlength
int_maxlength = 4000

'--------------------------------------------------------------------------
' Password to allow anything besides selects.
'--------------------------------------------------------------------------
dim str_Password
str_Password = "alvahugh"

'--------------------------------------------------------------------------
' Default DB.
'--------------------------------------------------------------------------
dim str_DB
str_DB = "AdminDB"

'--------------------------------------------------------------------------
' This function is what I use to disable any type of command besides a 
' select statement.  I suppose there is a more elegant solution but this 
' works.
'--------------------------------------------------------------------------
function CleanCode (InString)
	dim OutString 
	OutString = InString
	if not lcase(request("override")) = str_Password then
		OutString = replace(OutString,"truncate","t------e")
		OutString = replace(OutString,"delete","d----e")
		OutString = replace(OutString,"update","u----e")
		OutString = replace(OutString,"insert","i----t")
		OutString = replace(OutString,"create","c----e")
		OutString = replace(OutString,"alter","a---r")
		OutString = replace(OutString,"exec","e--c")
		OutString = replace(OutString,"kill","k--l")
		OutString = replace(OutString,"drop","d--p")
		OutString = replace(OutString,"sp_","s-_")
		OutString = replace(OutString,"xp_","x-_")
	end if
	CleanCode = OutString
end function

'--------------------------------------------------------------------------
' Inline style to make the screen look better.  You can change this to suit
' your tastes.
'--------------------------------------------------------------------------
%>
<style>
.bigbox {
	top: 5px;
	left: 10px;
	position : absolute;
	background-color: #DCDCDC;
	padding: 5px 5px 5px 5px;
	border: thin solid Black;
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 12px;
	margin-right: 5px;
	margin-bottom: 5px;
}

.title {
	background-color: #57799a;
	color: white;
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	border: thin solid Black;
	display: block;
	
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
	color: black;	
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
SQLString = CleanCode(request("TheSQL"))

'--------------------------------------------------------------------------
' Input form.
'--------------------------------------------------------------------------
'#E7E7E7
response.write "<html>"
response.write "<head>"
response.write "<title>SQL Thing</title>"
response.write "</head>"
response.write "<body class='body' onLoad='TheSQL.focus()'>"
response.write "<div class='bigbox'>"
response.write "<span class='title'>SQL Thing</span><br>"
response.write "<form action='edl.asp' method='post' name='send' id='send'>"
response.write "<textarea cols='100' rows='20' name='TheSQL' id='TheSQL'>" & CleanCode(SQLString) & "</textarea><br>"
response.write "<input type='submit' id='submit' value='submit'>&nbsp;"
response.write "<input type='text' name='OverRide' id='OverRide' value='" & request("OverRide") & "' size='8' maxlength='10'><br>"
response.write "</form>"
if len(CleanCode(SQLString)) > 0 then
	response.write "<h5>Query Length: " & len(trim(CleanCode(SQLString))) & " characters (" & (int_maxlength-len(trim(CleanCode(SQLString)))) & " left)</h5>"
end if

if len(SQLString) > 0 then
	response.write "<span class='title'>Output</span><br>"
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
response.write "</div>"
response.write "</body>"
response.write "</html>"
%>