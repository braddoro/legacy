<%@ language = "vbscript" %>
<%option explicit%>
<!-- #Include file="../includes/connection.asp" -->
<!-- #Include file="../includes/library.asp" -->
<HTML>
<HEAD><TITLE>Server Variables</TITLE>
<%
response.write "<link rel='stylesheet' href='../stylesheets/default.css'>"
 %>
</HEAD>
<BODY>
<%
response.write "<div>"  & vbcrlf
response.write "<p class='subhead'>Server Variables</p>"  & vbcrlf
response.write "</div>"  & vbcrlf
response.write "<a href='" & request("HTTP_REFERER")& "'>Back</a><hr>"
 %>
<table width='100%' border='1'>
<TR><TD><B>Variable</B></TD><TD><B>Value</B></TD></TR>
<% 
Dim key
Dim str_SQL
Dim obj_Command
For Each key In Request.ServerVariables %>
<TR><TD><% = key %></TD><TD>
<%
	If Request.ServerVariables(key) = "" Then
    	If GetAttribute(key) = "" Then
			' To force border around table cell
    		Response.Write "-" 
    	Else
    		Response.Write GetAttribute(key)
    	End if
    Else		
    	Response.Write Request.ServerVariables(key)
	End if
	Response.Write "</TD>"
%>
</TR>
<% Next %>
</TABLE>

<%
 function GetAttribute(AttrName)
    Dim AllAttrs
    Dim RealAttrName
    Dim Location
    Dim Result
    AllAttrs = Request.ServerVariables("ALL_HTTP")
    RealAttrName = AttrName
    Location = instr(AllAttrs, RealAttrName & ":")
    if Location <= 0 Then
    GetAttribute = ""
    Exit function
    End if
    Result = mid(AllAttrs, Location + Len(RealAttrName) + 1)
    Location = instr(Result, chr(10))
    if Location <= 0 Then Location = len(Result) + 1
    GetAttribute = left(Result, Location - 1)
End function 
%>
