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
<title>Maps</title>
<link rel='stylesheet' href='/includes/troop18.css'>
</head>
<body>
<%
' Variable declarations
dim str_SQL
dim obj_RecordSet
dim obj_Command
Dim int_PageName
%>
<table width='100%' border='0'>
<!-- The header row. -->
<tr>
<td colspan='2'>
<% response.write str_LeftSideImage %> <h3><% response.write str_PageTitle %></h3>
</td>
<td><% Response.write str_RightSide%></td>
</tr>
<tr><td colspan='3'><hr width='100%' size='1'></td></tr>
<!-- The detail row. -->
<tr>
<!-- The List cell. -->
<td width='15%' valign='top'>
<%
int_PageName = 40
str_SQL = "SELECT LinkURL, LinkDisplay, Target FROM Links WHERE Links.Active='Y' AND " & _
		"PageNameID_fk=" & int_PageName & " or PageNameID_fk = 0 ORDER BY PageNameID_fk, Links.DisplayOrder"
set obj_RecordSet = server.createObject("ADODB.Recordset")
obj_RecordSet.Open str_SQL, str_ConnectionString
Do while not obj_RecordSet.eof
	if len(obj_RecordSet("LinkURL")) > 0 then
		response.write "<A href='" & obj_RecordSet("LinkURL") & _
					"' Target='" & obj_RecordSet("Target") & "'>" & _
					obj_RecordSet("LinkDisplay") & "</a><BR>"
	else
		response.write obj_RecordSet("LinkDisplay") & "<BR>"
	end if
	obj_RecordSet.movenext
loop
obj_RecordSet.close
Set obj_RecordSet = nothing
%>
</td>
<!-- The Body cell. -->
<td>
<b>You Might Be A Scouter If:</b><br>
you keep a bucket of water by your side while cooking dinner. <br>
you carry your own toilet paper wherever you go. <br>
you horde tent stakes. <br>
you're always counting how many matches you have left. <br>
you roast a mini-marshmallow on a paper clip over a candle; then put it on a golden graham with one square of chocolate, just to get the flavor. <br>
you always cook enough food for twelve. <br>
you have something on your shoe and you're sure it's only mud. <br>
you eat ants on a log and like it. <br>
you know 365 one pot meals. <br>
your "microwave" is a box wrapped in foil. <br>
when opening large gifts, you survey the box wondering if you have a piece of foil large enough to cover it. <br>
you buy your shampoo in little tiny bottles. <br>
you tie your shoe and check the handbook to see if it can go toward earning a badge. <br>
you see a pile of rocks and immediately put them in a circle. <br>
you find yourself discussing the relative merits of internal- versus external-frame packs on a date. <br>
the trash collector has ever requested that you not hang your bags between the trees in the driveway. <br>
most of your wardrobe is olive drab or khaki. <br>
you have holes in the pockets of your jeans from carrying a pocket knife. <br>
you begin to think half frozen french fries don't taste all that bad. <br>
you spontaneously break into strange songs in public. <br>
you can stare at a spider web for an hour, and not notice the time passing. <br>
you always read by a flashlight. <br>
your radio is always tuned to the weather station. <br>
you wear 2 pairs of socks to bed. <br>
you keep a lantern hanging outside your bathroom door. <br>
you sleep under a trash bag. <br>
you cannot walk by a piece of trash without picking it up. <br>
you carry a dufflebag size first-aid kit in your car. <br>
you always have hat hair. <br>
you continue to wear it until it stands on it's own. <br>
you tie up your little brother, and he can't get loose. <br>
you know all the words to "Little Bunny Foo-Foo", but can't remember your address. <br>
you see paint samples in a store and immediately want to name things in nature with the same colors. <br>
your pots and pans are all black. <br>
all your clothes smell like pickles (from the bucket). <br>
pie iron pizzas is the best meal you've had all week. <br>
you always have a cup hooked to your belt. <br>
all your dishes have little pieces of egg stuck on them. <br>
you own little bits of every color felt. <br>
you open letters with a pocket knife. <br>
you wear bread bags on your feet. <br>
you order pizzas 14 at a time. <br>
you have the urge to help little old ladies whether they want it or not. <br>
everything in your cupboard says "Instant, just add water". <br>
your neighbors hide when they see you going door to door with "that order form" again. <br>
you have to go to the restroom and you start looking for a buddy. <br>
you really do use those emergency sewing kits. <br>
you go to someone's house for dinner, don't like the food, and ask if they have peanut butter and jelly. <br>
you know 100 uses for a bandana. <br>
all your shirts have pin holes in them. <br>
you wear thongs in the shower. <br>
you actually own the book, "How to Sh*t in the Woods". <br>
you have a collection of used candles and dryer lint. <br>
someone asks for a volunteer and you find your hand is already in the air. <br>
your favorite cologne is "Deep Woods Off!". <br>
you can't remember which hand to shake with in the office on Monday morning. <br>
you miss the "floaties" and "sinkers" in the office coffee. <br>
your computer password is "TLH FCK OCT BCR." <br>
you miss "cargo pockets." <br>
you REALLY LOVE your self-inflating sleep pad. <br>
you have the end of every rope at home backspliced or whipped. <br>
you correct someone who says "Gee, I used to be an Eagle Scout", and then get him to volunteer in your Troop. <br>
you always have a boy registration and adult leader application in your red bag. And you have to keep replacing them. <br>
you deeply understand the potential of a group working together. <br>
you camp for a week in the summer with about a dozen old guys; about 40 between 18 and 30; hundreds between 11 and 18; and the whole thing works! <br>
you know you have brothers all over the world. <br>
you have seen the spiritual power the outdoors can have on men and boys. <br>
you have helped raise each other's children. You are proud of the mentors your sons have found. <br>
You know who in your patrol can really cook and whose talent lies in dishwashing. And, you think a pan of warm water feels pretty good after dinner. <br>
you catch yourself singing "God Bless My Underwear" when it's time to sing "God Bless America". <br>
you say "signs up" in a business meeting to quiet everyone down. <br>
you turn down a raspberry almond torte for a spoonful of Dutch Oven peach cobbler. <br>
you hear someone refer to 'S&M', and you chime in with, 'no, the acronym is SM.'<br>
your closets are full and they don't contain clothes, but craft stuff. <br>
you have a special weaved belt loop cup holder. <br>
you know more than two ways to light a fire. <br>
your gourmet meal consists of cornbread, "Spam," and bug-juice. <br>
your idea of a burned-out light bulb is a broken mantle.<br> 
your front door has a zipper instead of a deadbolt. <br>
your last birthday cake was prepared and served in a Dutch Oven. <br>
you're the only one on your block with a fire pit in your back yard.<br> 
you've ever been mistaken for a park ranger or a State Trooper. <br>
your "family vacation" includes 30 kids your wife/husband doesn't know. <br>
you've ever heard the phrase, "Trust me, it's only an hour a week!!"<br>
</td>
</tr>
</table>
<img src="images/sq-rope.gif" alt="" width="580" height="25" border="0"><br><h6><a href='mailto:<% response.write str_EmailAddress %>'>contact webmaster</a></h6><% response.write "<br><p class='invisible'>" & int_PageName & "</p>" %>
</body>
</html>