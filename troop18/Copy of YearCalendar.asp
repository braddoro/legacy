<%
Option Explicit
%>
<!-- #Include file="includes/connection.asp"	-->
<!-- #Include file="includes/library.asp"		-->
<style type='text/css'>
a:link       {
	color: black;
	text-decoration: none;
} 
a:visited  {
	color: black;
	text-decoration: none;
}   
a:active   {
	text-decoration: none;
                text-decoration: underline;
}    
a:hover    {
	text-decoration: underline;
	color: black;
	font-weight : bold;
}
</style>
<%
const rowHeight=50     ' minimum cell height for each calendar day
const ItemMonthColor="beige"         ' color of days with an entry in them
const nonRangeMonthColor="#eeeeee"   ' color of days not within the begin and end range
const RangeMonthColorEven="#aaaaaa"  ' color of days with an entry in them
const RangeMonthColorOdd="#cccccc"   ' color of days with an entry in them

dim beginDate
dim endDate
dim calendarStarted
dim lastDate

dim rangeFirstDay
dim calBeginDate
dim calEndDate

lastDate=cDate("1/1/1980")
calendarStarted=false

sub DrawDay (useDate, useText, ID)
	dim DateCounter
	dim MonthColor

	'use only the date portion
	useDate=cDate(month(useDate) & "/" & day(useDate) & "/" & year(useDate))
	if not (useDate>calEndDate) then
		if not calendarStarted then
			'Start the Calendar Table
			response.write("<font face=verdana, arial>" & chr(13))
   			response.write("<table width=""100%"" border=1>" & chr(13))
   			response.write(" <tr bgcolor=""#aaaaaa"">" & chr(13))
   			response.write("  <td width=""14%"" align=center><font color='gold' face=verdana, arial size=2>Sun</font></td>" & chr(13))
   			response.write("  <td width=""14%"" align=center><font color='gold' face=verdana, arial size=2>Mon</font></td>" & chr(13))
   			response.write("  <td width=""14%"" align=center><font color='gold' face=verdana, arial size=2>Tue</font></td>" & chr(13))
   			response.write("  <td width=""14%"" align=center><font color='gold' face=verdana, arial size=2>Wed</font></td>" & chr(13))
   			response.write("  <td width=""14%"" align=center><font color='gold' face=verdana, arial size=2>Thu</font></td>" & chr(13))
   			response.write("  <td width=""14%"" align=center><font color='gold' face=verdana, arial size=2>Fri</font></td>" & chr(13))
   			response.write("  <td width=""14%"" align=center><font color='gold' face=verdana, arial size=2>Sat</font></td>" & chr(13))
   			response.write(" </tr>" & chr(13))
   			calendarStarted=true
  		end if
  		
		if useDate>lastDate then
   			' Not the same date as the last entry, so close open date cell,
   			' add blank days, and start new date cell.
   			if lastDate=cDate("1/1/1980") then
    			lastDate=dateAdd("d",-1,calBeginDate)
   			else
    			response.write("  </font></td>" & chr(13))
    			if weekday(lastDate)=7 then response.write(" </tr>" & chr(13))
   				end if
   				
				for dateCounter = dateadd("d",1,lastDate) to dateadd("d",-1,useDate)
    				if (weekday(dateCounter)=1) then response.write(" <tr height=" & rowHeight & " vAlign=""top"">" & chr(13))
    				
					' Alternate background colors of different months for visual clarity.
    				if month(dateCounter) mod 2=0 then
     					monthColor=RangeMonthColorEven
    				else
     					monthColor=RangeMonthColorOdd
    				end if
    				if (dateCounter<cDate(beginDate)) or (dateCounter>cDate(endDate)) then monthColor=NonRangeMonthColor
    					response.write("  <td bgcolor=""" & monthColor & """ align=right><font size=2 color=""#222222"">")
    					' If it's the first day of the month or it's the first day on the calendar,
    					' add the month and year
    				if (day(dateCounter)=1) or (dateCounter=calBeginDate) then
     					response.write "<b>" & monthName(month(dateCounter),true) & " " & day(dateCounter) & ", " & year(dateCounter) & "</b>"
    				else
     					response.write(day(dateCounter))
    				end if
    				response.write("</font></td>" & chr(13))
    				if weekday(dateCounter)=7 then response.write(" </tr>" & chr(13))
   				next
   	
	' If the day is saturday, start a new row
   	if (weekday(dateCounter)=1) then response.write(" <tr height=" & rowHeight & " vAlign=""top"">" & chr(13))
   		monthColor=ItemMonthColor
   		if (dateCounter<cDate(beginDate)) or (dateCounter>cDate(endDate)) then monthColor=NonRangeMonthColor
   			response.write("  <td bgcolor=""" & monthColor & """ align=right><font size=2 color=""#222222"">")

   			' If it's the first day of the month add the month and year
		   if day(dateCounter)=1 then
		   		response.write "<b>" & monthName(month(dateCounter),true) & " " & day(dateCounter) & ", " & year(dateCounter) & "</b>"
		   else
				response.write day(dateCounter)
		   end if
   			response.write("</font><br><font size=1, color=""#000000"">" & chr(13))
  		end if
  		
		' This calendar was made to take entries in consecutive date order. If
  		' the "useDate" is before the "lastDate", then report an error.
  		if useDate<lastDate then
   			response.write("Error: the date " & useDate & " is prior to the last date entered:" & lastDate & "<br>" & chr(13))
   			response.end
  		end if

  		' the CloseCalendar sub will call DrawDay with a useText of ""
  		if useText<>"" then response.write("   <a href='eventdetail.asp?id=" & ID & "'>" & useText & "</a><br>" & chr(13))
  		LastDate=useDate
	end if
end sub

sub CloseCalendar
 DrawDay CalEndDate, "", 0
 response.write("</table>" & chr(13))
end sub

'----------------------------------------------------------------------------------------
' Print the header
'----------------------------------------------------------------------------------------
response.write "<font face=arial color='gold'><h1>Troop 18 Calendar</h1></font>"
RESPONSE.write "<font face=arial color='black'><h5> as of " & now() & "</h5></font><br>"

'----------------------------------------------------------------------------------------
' Define the starting and ending dates for the calendar.
'----------------------------------------------------------------------------------------
 beginDate=date()
 endDate=date()+365

'----------------------------------------------------------------------------------------
 'Check date validity. Non-Dates may cause infinite loops.
'----------------------------------------------------------------------------------------
if not isDate(beginDate) then
	response.write("Error: the begin date is not a valid date<br>" & chr(13))
	response.end
end if
if not isDate(endDate) then
	response.write("Error: the End date is not a valid date<br>" & chr(13))
	response.end
end if

'----------------------------------------------------------------------------------------
'Make sure both dates are in the same format.
'----------------------------------------------------------------------------------------
beginDate=month(beginDate) & "/" & day(beginDate) & "/" & year(beginDate)
endDate=month(endDate) & "/" & day(endDate) & "/" & year(endDate)

'----------------------------------------------------------------------------------------
'Make sure the dates are in the right order.
'----------------------------------------------------------------------------------------
if beginDate>endDate then
	response.write("Error: The End date must be after the begin date.<br>" & chr(13))
	response.end

 	'dim tempDate
	'tempDate=beginDate
	'beginDate=endDate
	'endDate=tempDate
end if

'----------------------------------------------------------------------------------------
'Calculate the first day of the month for the first month in the range
'----------------------------------------------------------------------------------------
rangeFirstDay=cDate(month(beginDate) & "/1/" & year(beginDate))

'----------------------------------------------------------------------------------------
'the first calendar cell - usually the ending days of the month prior to the range
'----------------------------------------------------------------------------------------
calBeginDate=dateadd("d",1-weekday(rangeFirstDay),rangeFirstDay)

'----------------------------------------------------------------------------------------
'the last day of the Date Range
'----------------------------------------------------------------------------------------
calEndDate=dateadd("d",-1,dateAdd("m",1,month(endDate) & "/1/" & year(endDate)))

'----------------------------------------------------------------------------------------
'If the last day of the Last month in the Date Range is not Saturday,
'increment the calendar Ending date to the next saturday to get the date of the
'last cell in the calendar
'----------------------------------------------------------------------------------------
if weekday(calEndDate)<>7 then
	calEndDate=dateadd("d",7-weekday(calEndDate),calEndDate)
end if

Dim str_SQL
Dim obj_RecordSet

'----------------------------------------------------------------------------------------
' Open the database and get the data.
'----------------------------------------------------------------------------------------
str_SQL = "SELECT ActivityID, ActivityStart, ActivityType, " & _
		"Activity FROM ActivityTypes INNER JOIN Activities ON " & _
		"ActivityTypes.ActivityTypeID = Activities.ActivityTypeID_fk WHERE " & _
		"ActivityStart>Date() and ActivityStart<Date()+365 ORDER BY Activities.ActivityStart;"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString

'----------------------------------------------------------------------------------------
' Write the data to the calendar.
'----------------------------------------------------------------------------------------
Do while not obj_RecordSet.eof
	DrawDay obj_RecordSet("ActivityStart"), obj_RecordSet("ActivityType") & " - " & _
			obj_RecordSet("Activity"), obj_RecordSet("ActivityID")
	obj_RecordSet.movenext
loop
obj_RecordSet.close
Set obj_RecordSet = nothing

' Close up the open cell, row, and table
CloseCalendar
%>