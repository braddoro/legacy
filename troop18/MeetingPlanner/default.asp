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
<a href='http://www.bsatroop18.org'>Troop 18</a>
<%
response.redirect("meetings.asp")
%>
</BODY>
</HTML>