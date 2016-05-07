<!--METADATA Type="TypeLib" NAME="Microsoft ActiveX Data Objects 2.0 Library" UUID="{00000200-0000-0010-8000-00AA006D2EA4}" VERSION="2.0"-->
<%
'======================================================================================
' SQL Preperations are used to prepare v
'     ariables for SQL Queries. If
' invalid data is passed to these routin
'     es, NULL values or Default Data
' is returned to keep your SQL Queries f
'     rom breaking from users breaking
' datatype rules.
'======================================================================================	
Function SQLPrep_s(ByVal asExpression, ByRef anMaxLength)
    	' if maximum length is defined
    	if anMaxLength > 0 Then
    		' Trim expression To maximum length
    		asExpression = Left(asExpression, anMaxLength)
    	End if ' anMaxLength > 0
    	' Double quote SQL quote characters
    	asExpression = Replace(asExpression, "'", "''")
    	' if Expression is Empty
    	if asExpression = "" Then
    		' Return a NULL value
    		SQLPrep_s = "NULL"
    	' Else expression is Not empty
    	Else
    		' Return quoted expression
    		SQLPrep_s = "'" & asExpression & "'"
    	End if ' asExpression
End function ' SQLPrep_s

Function SQLPrep_n(ByVal anExpression)
    	' if expression numeric
    	if IsNumeric(anExpression) And Not anExpression = "" Then
    		' Return number
    		SQLPrep_n = anExpression
    	' Else expression Not numeric
    	Else
    		' Return NULL
    		SQLPrep_n = "NULL"
    	End if ' IsNumeric(anExpression) And Not anExpression = ""
End function ' SQLPrep_n

Function SQLPrep_b(ByVal abExpression, ByRef abDefault)
    	' Declare Database Constants
    	Const lbTRUE = -1 '1 = SQL, -1 = Access
    	Const lbFALSE = 0
    	Dim lbResult ' Result To be passed back
    	' Prepare For any errors that may occur
    	On Error Resume Next
    	' if expression Not provided
    	if abExpression = "" Then
    		' Set expression To default value
    		abExpression = abDefault
    	End if ' abExpression = ""
    	' Attempt To convert expression
    	lbResult = CBool(abExpression)
    	' if Err Occured
    	if Err Then
    		' Clear the Error
    		Err.Clear
    		' Determine action based on Expression
    		Select Case LCase(abExpression)
    			' True expressions
    			Case "yes", "on", "true", "-1", "1"
    				lbResult = True
    			' False expressions
    			Case "no", "off", "false", "0"
    				lbResult = False
    			' Unknown expression
    			Case Else
    				lbResult = abDefault
    		End Select ' LCase(abExpression)
    	End if ' Err
    	' if result is True
    	if lbResult Then
    		' Return True
    		SQLPrep_b = lbTRUE
    	' Else Result is False
    	Else
    		' Return False
    		SQLPrep_b = lbFALSE
    	End if ' lbResult
End function ' SQLPrep_b

Function SQLPrep_d(ByRef adExpression)
    	' if Expression valid Date
    	if IsDate(adExpression) Then
    		' Return Date
    		'SQLPrep_d = "'" & adExpression & "'" ' SQL Database
    		SQLPrep_d = "#" & adExpression & "#" ' Access Database
    	' Else Expression Not valid Date
    	Else
    		' Return NULL
    		SQLPrep_d = "NULL"
    	End if ' IsDate(adExpression)
End function ' SQLPrep_d

Function SQLPrep_c(ByVal acExpression)
    	' if Empty Expression
    	if acExpression = "" Then
    		' Return Null
    		SQLPrep_c = "NULL"
    	' Else expression has content
    	Else
    		' Prepare For Errors
    		On Error Resume Next
    		' Attempt To convert expression to Currency
    		SQLPRep_c = CCur(acExpression)
    		' if Error occured
    		if Err Then
    			' Clear Error
    			Err.Clear
    			SQLPrep_c = "NULL"
    		End if ' Err
    	End if ' acExpression = ""
End function ' SQLPrep_c

Function glf_FilterText(strData) 
    strData = Trim(strData)
    strData = Replace(strData, Chr(34), "`")
    strData = Replace(strData, "'", "`")
    strData = Replace(strData, "(", "")
    strData = Replace(strData, ")", "")
    strData = Replace(strData, "_", "")
    strData = Replace(strData, "$", "")
    strData = Replace(strData, "%", "")
    strData = Replace(strData, ",", "")
    strData = Replace(strData, "-", "")
    'strData = Replace(strData, "  ", " ")
	glf_FilterText = strData
End Function

Function glf_SQL_Safe(strData) 
	glf_SQL_Safe = replace(strData,"'","`")
End Function

Function glf_SQL_Safe2(strData) 
	dim str_Input
	str_Input = replace(strData,chr(34),"`")
	str_Input = replace(str_Input,"'","'''")
	glf_SQL_Safe2 = str_Input
End Function

Function glf_SQL_Safe3(strData) 
	dim str_Input
	str_Input = replace(strData,chr(34),"''")
	str_Input = replace(str_Input,"'","''")
	glf_SQL_Safe3 = str_Input
End Function

Function glf_SQL_KillBadWords(strData) 
	' strData = replace(strData,"insert","Error ")
	' strData = replace(strData,"update","Error ")
	strData = replace(strData,"delete","Error ")
	strData = replace(strData,"drop","Error ")	
	strData = replace(strData,"truncate","Error ")
	glf_SQL_KillBadWords = strData
End Function

function glf_IsExplorer
	Set check = server.createObject("MSWC.BrowserType")
    if check.browser="IE" and check.version >= "4.0" Then
    	glf_IsExplorer = true
	Else
		glf_IsExplorer = false
    End if
End function
  
Sub glf_DisplayQueryString
dim Item
dim arr_QueryValues
dim int_ItemCount

'int_ItemCount = 0

'for each item in request.QueryString
'	redim Preserve arr_QueryValues(int_ItemCount + 1)
'	arr_QueryValues(int_ItemCount) = request.QueryString(item)
'	int_ItemCount = int_ItemCount + 1
'next
	'response.write request.servervariables("QUERY_STRING") & "<BR>" & vbcrlf
	'Response.Write Request.ServerVariables("QUERY_STRING")
	'Response.Write 	request.QueryString
	
		response.write item & "<BR><BR><B>QueryString</b><BR>" & vbcrlf
    	for each item in request.form
    		execute(item & "=""" & Replace(request.form(item), Chr(34), Chr(34) & Chr(34)) & """")
					response.write item & "<BR>" & vbcrlf
    	next
    	for each item in request.QueryString
    		execute(item & "=""" & Replace(request.QueryString(item), Chr(34), Chr(34) & Chr(34)) & """")
'			response.write item & "<BR>" & vbcrlf
    	next
    end sub

sub gls_LogPage (Page, IP)
	dim str_SQL
	dim obj_Command
	str_SQL = "INSERT INTO PageLogs ( PageNameID_fk, IPAddress ) values(" & page & ", '" & IP & "')"
	set obj_Command = server.createObject("ADODB.Command")
	obj_Command.ActiveConnection = str_ConnectionString
	obj_Command.CommandText = str_SQL
	obj_Command.Execute
	set obj_Command = nothing
end sub
%>