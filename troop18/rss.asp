<%@ Language=VBScript %>
<%Option Explicit %>
<%Response.Buffer = True%>
<!-- #Include file="includes/connection.asp" -->
<!-- #Include file="includes/library.asp" -->
<rss version="2.0">
<channel>
<title>BSA Troop 18</title>
<webMaster>troopeighteen@gmail.com</webMaster>
<language>en-US</language>
<link>http://bsatroop18.org/</link>
<description>BSA Troop 18 of Newell NC</description>
<%
dim str_SQL
dim obj_RecordSet
dim obj_Command
str_SQL = "SELECT NewsID, News.Title, News.News, News.AddedDate FROM News where ((News.Active)='Y') ORDER BY News.AddedDate;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
Do while not obj_RecordSet.eof
	response.write "<item>" & vbcrlf
	response.write "<title>" & server.htmlencode(obj_RecordSet("Title")) & "</title>" & vbcrlf
	response.write "<description>" & server.htmlencode(replace(obj_RecordSet("News"),"<br>",vbcrlf)) & "</description>" & vbcrlf
	'response.write "<pubDate>" & FormatDateTime(obj_RecordSet("AddedDate"),1) & " " & FormatDateTime(obj_RecordSet("AddedDate"),3) & "</pubDate>" & vbcrlf
    'response.write "<pubDate>" & FormatDateTime(obj_RecordSet("AddedDate"),0) & "</pubDate>" & vbcrlf
    response.write "<pubDate>" & obj_RecordSet("AddedDate") & "</pubDate>" & vbcrlf
	response.write "<category>News</category>" & vbcrlf
	response.write "<author>troopeighteen@gmail.com (Scoutmaster)</author>" & vbcrlf
    response.write "<guid isPermaLink='false'>" & obj_RecordSet("NewsID") & "</guid>" & vbcrlf
	response.write "</item>" & vbcrlf
	obj_RecordSet.movenext
loop
obj_RecordSet.close
Set obj_RecordSet = nothing
%>
</channel>
</rss>
