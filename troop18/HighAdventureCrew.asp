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
<html>
<head>
<title>High Adventure Crew</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
dim obj_SelectBox
Dim str_Temp
%>
<table width='100%' border='0'><% response.write vbcrlf %>
<!-- The header row. -->
<tr>
<th colspan='2'>
<% response.write str_LeftSideImage %> <h3><% response.write str_PageTitle %></h3><% response.write vbcrlf %>
</th>
<td><% Response.write str_RightSide%></td>
</tr>
<tr><td colspan='3'><hr width='100%' size='1'></td></tr>
<!-- The detail row. -->
<tr>
<!-- The List cell. -->
<td width='15%' valign='top'><% response.write vbcrlf %>
<%
int_PageName = 54
str_SQL = "SELECT LinkURL, LinkDisplay, Target FROM Links WHERE Links.Active='Y' AND " & _
		"PageNameID_fk=" & int_PageName & " or PageNameID_fk = 0 ORDER BY PageNameID_fk, Links.DisplayOrder"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
Do while not obj_RecordSet.eof
	if len(obj_RecordSet("LinkURL")) > 0 then
		response.write "<A href='" & obj_RecordSet("LinkURL") & _
					"' Target='" & obj_RecordSet("Target") & "'>" & _
					obj_RecordSet("LinkDisplay") & "</a><BR>" & vbcrlf
	else
		response.write obj_RecordSet("LinkDisplay") & "<BR>" & vbcrlf
	end if
	obj_RecordSet.movenext
loop
'response.write "<A href='EditTripDetail.asp?ID=" & Request("ID") & "' target='_top'>Edit This Trip</a><BR>" & vbcrlf

obj_RecordSet.close
Set obj_RecordSet = nothing

gls_LogPage int_PageName, request("REMOTE_HOST")
%>
</td>
<!-- The Body cell. -->
<td>
<%
response.write "<h2>The High Adventure Crew</h2><br><br>"

str_SQL = "SELECT Count([Trip Total By Member (used to calculate other things)].TripID_fk) AS Trips, Members.[FirstName] & ' ' & [LastName] AS Member, Members.Adult FROM [Trip Total By Member (used to calculate other things)] INNER JOIN Members ON [Trip Total By Member (used to calculate other things)].MemberID_fk = Members.MemberID GROUP BY Members.[FirstName] & ' ' & [LastName], Members.Adult ORDER BY Count([Trip Total By Member (used to calculate other things)].TripID_fk) DESC , Members.[FirstName] & ' ' & [LastName]"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<h4>Trips per Member</h4><br>"
response.write "<table border='0'>" 
response.write "<tr><th>Trips</th><th>Member</th></tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write obj_RecordSet("Trips")
	response.write "</td>"
	response.write "<td>"
	response.write obj_RecordSet("Member") 
	if obj_RecordSet("Adult") = "Y" then
		response.write " (adult)"
	end if
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>" & vbcrlf	
obj_RecordSet.close
Set obj_RecordSet = nothing
response.write "<br>"


str_SQL = "SELECT Sum(Trips.Milege) AS SumOfMilege, Members.Adult, Members.FirstName, Members.LastName FROM Trips INNER JOIN (Members INNER JOIN [Trip Total By Member (used to calculate other things)] ON Members.MemberID = [Trip Total By Member (used to calculate other things)].MemberID_fk) ON Trips.TripID = [Trip Total By Member (used to calculate other things)].TripID_fk GROUP BY Members.Adult, Members.FirstName, Members.LastName HAVING (((Sum(Trips.Milege))>0)) ORDER BY Sum(Trips.Milege) DESC , Members.Adult, Members.FirstName, Members.LastName;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<h4>Miles per Member</h4><br>"
response.write "<table border='0'>" 
response.write "<tr><th>Miles</th><th>Member</th></tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write obj_RecordSet("SumOfMilege")
	response.write "</td>"
	response.write "<td>"
	if not str_Temp = obj_RecordSet("FirstName") & " " & obj_RecordSet("LastName") then
		response.write obj_RecordSet("FirstName") & " " & obj_RecordSet("LastName")
		if obj_RecordSet("Adult") = "Y" then
			response.write " (adult)"
		end if
	else
		response.write "&nbsp;"
	end if
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>" & vbcrlf	
obj_RecordSet.close
Set obj_RecordSet = nothing
response.write "<br>"


str_SQL = "SELECT Members.Adult, Members.FirstName, Members.LastName, Count(HighAdventureBeads.BeadColor) AS CountOfBeadColor FROM Members INNER JOIN (TripLocations INNER JOIN (HighAdventureBeads INNER JOIN (Trips INNER JOIN TripBeadMembers ON Trips.TripID = TripBeadMembers.TripID_fk) ON HighAdventureBeads.BeadID = TripBeadMembers.BeadID_fk) ON (TripLocations.TripLocationID = Trips.TripLocationID_fk) AND (TripLocations.TripLocationID = Trips.TripLocationID_fk)) ON Members.MemberID = TripBeadMembers.MemberID_fk GROUP BY Members.Adult, Members.FirstName, Members.LastName ORDER BY Count(HighAdventureBeads.BeadColor) DESC , Members.Adult, Members.FirstName, Members.LastName;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<h4>Beads per Member</h4><br>"
response.write "<table border='0'>" 
response.write "<tr><th>Name</th><th>Beads</th></tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"

	response.write "<td>"
	response.write obj_RecordSet("CountOfBeadColor")	
	response.write "</td>"

	response.write "<td>"
	response.write obj_RecordSet("FirstName") & " " & obj_RecordSet("LastName")
	if obj_RecordSet("Adult") = "Y" then
		response.write " (adult)"
	end if
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>" & vbcrlf	
obj_RecordSet.close
Set obj_RecordSet = nothing
response.write "<br>"

'str_SQL = "SELECT TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadColor FROM Members INNER JOIN (TripLocations INNER JOIN (HighAdventureBeads INNER JOIN (Trips INNER JOIN TripBeadMembers ON Trips.TripID = TripBeadMembers.TripID_fk) ON HighAdventureBeads.BeadID = TripBeadMembers.BeadID_fk) ON (TripLocations.TripLocationID = Trips.TripLocationID_fk) AND (TripLocations.TripLocationID = Trips.TripLocationID_fk)) ON Members.MemberID = TripBeadMembers.MemberID_fk GROUP BY Trips.TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadColor ORDER BY Trips.TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadColor;"
str_SQL = "SELECT TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadDescription, HighAdventureBeads.BeadColor FROM Members INNER JOIN (TripLocations INNER JOIN (HighAdventureBeads INNER JOIN (Trips INNER JOIN TripBeadMembers ON Trips.TripID = TripBeadMembers.TripID_fk) ON HighAdventureBeads.BeadID = TripBeadMembers.BeadID_fk) ON (TripLocations.TripLocationID = Trips.TripLocationID_fk) AND (TripLocations.TripLocationID = Trips.TripLocationID_fk)) ON Members.MemberID = TripBeadMembers.MemberID_fk GROUP BY Trips.TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadColor, HighAdventureBeads.BeadDescription ORDER BY Trips.TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadColor, HighAdventureBeads.BeadDescription;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<h4>Beads Awarded per Trip</h4><br>"
response.write "<table border='0'>" 
response.write "<tr><th>Date</th><th>Location</th><th>Color</th><th>Description</th></tr>"
Do while not obj_RecordSet.eof
	response.write "<tr>"
	response.write "<td>"
	response.write obj_RecordSet("TripStartDate")
	response.write "</td>"
	response.write "<td>"
	response.write obj_RecordSet("TripLocation") 
	response.write "</td>"
	response.write "<td>"
	response.write obj_RecordSet("BeadColor")
	response.write "</td>"
	response.write "<td>"
	response.write obj_RecordSet("BeadDescription")
	response.write "</td>"
	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>" & vbcrlf	
obj_RecordSet.close
Set obj_RecordSet = nothing
response.write "<br>"

str_SQL = "SELECT Members.Adult, Members.FirstName, Members.LastName, HighAdventureBeads.BeadColor, HighAdventureBeads.BeadDescription, Count(HighAdventureBeads.BeadColor) AS CountOfBeadColor FROM Members INNER JOIN (TripLocations INNER JOIN (HighAdventureBeads INNER JOIN (Trips INNER JOIN TripBeadMembers ON Trips.TripID = TripBeadMembers.TripID_fk) ON HighAdventureBeads.BeadID = TripBeadMembers.BeadID_fk) ON (TripLocations.TripLocationID = Trips.TripLocationID_fk) AND (TripLocations.TripLocationID = Trips.TripLocationID_fk)) ON Members.MemberID = TripBeadMembers.MemberID_fk GROUP BY Members.Adult, Members.FirstName, Members.LastName, HighAdventureBeads.BeadColor, HighAdventureBeads.BeadDescription ORDER BY Members.Adult, Members.FirstName, Members.LastName, HighAdventureBeads.BeadColor, HighAdventureBeads.BeadDescription;" 
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<h4>Beads per Crew Member</h4><br>"
response.write "<table border='0'>" 
response.write "<tr><th>Crew Member</th><th>Bead</th><th>Total</th></tr>"
Do while not obj_RecordSet.eof

	response.write "<tr>"
	response.write "<td>"
	if not str_Temp = obj_RecordSet("FirstName") & " " & obj_RecordSet("LastName") then
		response.write obj_RecordSet("FirstName") & " " & obj_RecordSet("LastName")
		if obj_RecordSet("Adult") = "Y" then
			response.write " (adult)"
		end if
	else
		response.write "&nbsp;"
	end if
	response.write "</td>"
	str_Temp = obj_RecordSet("FirstName") & " " & obj_RecordSet("LastName")
	
	response.write "<td>"
	response.write obj_RecordSet("BeadColor") 
	'& "<h6>" & obj_RecordSet("BeadDescription") & "</h6>"
	response.write "</td>"

	response.write "<td>"
	response.write obj_RecordSet("CountOfBeadColor")
	response.write "</td>"

	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>" & vbcrlf	
obj_RecordSet.close
Set obj_RecordSet = nothing
response.write "<br>"

dim Curr_Date
dim Curr_Location
dim Curr_Bead

'str_SQL = "SELECT Trips.TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadColor, Members.Adult, Members.FirstName, Members.LastName FROM Members INNER JOIN (TripLocations INNER JOIN (HighAdventureBeads INNER JOIN (Trips INNER JOIN TripBeadMembers ON Trips.TripID = TripBeadMembers.TripID_fk) ON HighAdventureBeads.BeadID = TripBeadMembers.BeadID_fk) ON (TripLocations.TripLocationID = Trips.TripLocationID_fk) AND (TripLocations.TripLocationID = Trips.TripLocationID_fk)) ON Members.MemberID = TripBeadMembers.MemberID_fk GROUP BY Trips.TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadColor, Members.Adult, Members.FirstName, Members.LastName, Members.HighAdventureCrew, Members.Active HAVING (((Members.HighAdventureCrew)='Y') AND ((Members.Active)='Y')) ORDER BY Trips.TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadColor, Members.FirstName, Members.LastName;"
str_SQL = "SELECT Trips.TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadColor, HighAdventureBeads.BeadDescription, Members.Adult, Members.FirstName, Members.LastName FROM Members INNER JOIN (TripLocations INNER JOIN (HighAdventureBeads INNER JOIN (Trips INNER JOIN TripBeadMembers ON Trips.TripID = TripBeadMembers.TripID_fk) ON HighAdventureBeads.BeadID = TripBeadMembers.BeadID_fk) ON (TripLocations.TripLocationID = Trips.TripLocationID_fk) AND (TripLocations.TripLocationID = Trips.TripLocationID_fk)) ON Members.MemberID = TripBeadMembers.MemberID_fk GROUP BY Trips.TripStartDate, TripLocations.TripLocation, HighAdventureBeads.BeadColor, HighAdventureBeads.BeadDescription, Members.Adult, Members.FirstName, Members.LastName, Members.HighAdventureCrew, Members.Active HAVING (((Members.HighAdventureCrew)='Y') AND ((Members.Active)='Y')) ORDER BY Trips.TripStartDate desc, TripLocations.TripLocation, HighAdventureBeads.BeadColor, HighAdventureBeads.BeadDescription, Members.FirstName, Members.LastName;"

set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
response.write "<h4>Bead Award History</h4><br>"
response.write "<table border='0'>" 
response.write "<tr><th>Start Date</th><th>Location</th><th>Bead</th><th>Name</th></tr>"
Do while not obj_RecordSet.eof

	response.write "<tr>"
	
	response.write "<td>"
	if not Curr_Date = obj_RecordSet("TripStartDate") then
		response.write "<b>" & obj_RecordSet("TripStartDate") & "</b>"
	else
		response.write "&nbsp;"
	end if
	response.write "</td>"
	Curr_Date = obj_RecordSet("TripStartDate")
		
	response.write "<td>"
	if not Curr_Location = obj_RecordSet("TripLocation") then
		response.write "<b>" & obj_RecordSet("TripLocation")  & "</b>"
	else
		response.write "&nbsp;"
	end if
	response.write "</td>"
	Curr_Location = obj_RecordSet("TripLocation")

	response.write "<td>"
	if not Curr_Bead = obj_RecordSet("BeadColor") then
		response.write "&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td><h6>" & obj_RecordSet("BeadDescription") & "</h6></td>"
		response.write "<td><b>" & obj_RecordSet("BeadColor") & "</b>"
	else
		response.write "&nbsp;"
	end if
	Curr_Bead = obj_RecordSet("BeadColor")
	response.write "</td>"
	
	response.write "<td>"
	response.write obj_RecordSet("FirstName") & " " & obj_RecordSet("LastName")
	if obj_RecordSet("Adult") = "Y" then
		response.write " (adult)"
	end if
	response.write "</td>"

	response.write "</tr>"
	obj_RecordSet.movenext
loop
response.write "</table>" & vbcrlf	
obj_RecordSet.close
Set obj_RecordSet = nothing
response.write "<br>"

%>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>