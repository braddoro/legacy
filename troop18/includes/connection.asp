<%
'==========================================================================================
' Global Declarations
'==========================================================================================
Dim str_SiteName
Dim str_ConnectionString
Dim str_PageTitle

Dim g_int_AccessLevel
Dim g_WebSiteID
dim g_str_LoginName
dim g_int_userID
dim str_Password
dim str_PasswordConfirm
dim str_UserName
dim str_EmailAddress
dim str_RightSide
dim str_LeftSideImage
dim int_DaysInNewsSummary

' Connection String for the Access database.
'str_ConnectionString = "DRIVER=Microsoft Access Driver (*.mdb);DBQ=D:\webdirs\Troop18\includes\troop18.mdb;"
str_ConnectionString = "troop18"
' Global site name.
str_SiteName = "Troop 18"
str_PageTitle = "BSA Troop 18"
'str_RightSide = "<img src='images/icon_flagUS.gif' alt='' width='60' height='39' border='0' align='bottom'><img src='images/yellowribbon.gif' name='ribbon' id='ribbon' width='29' height='65' border='0' align='left'>"
str_RightSide = ""
'bslgoclr.gif
str_LeftSideImage = "<img src='images/fdl.gif' alt='' border='0' align='middle'>"
str_EmailAddress = Server.UrlEncode("crucible@carolina.rr.com")
str_Password = "trustworthy"
int_DaysInNewsSummary = 15
%>
