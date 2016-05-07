<%@ Language=VBScript %>
<% Option Explicit %>
<% Response.Buffer = True %>
<!-- 
COPYRIGHT NOTICE. 
All rights reserved. Any rights not expressly granted are reserved.
Copyright © 2002 Crucible Systems
-->
<html>
<head>
</head>
<body>
<!-- #Include file="counter.asp"					-->
gls_LogPage 49, request("REMOTE_HOST")
<% response.redirect("home.asp") %>
</body>
</html>
