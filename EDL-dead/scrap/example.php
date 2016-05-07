<?php 
$ini_array = parse_ini_file("inc/braddoro.ini"); 
include "_functions.php";
session_start();
header("Cache: private");

if (isset($_REQUEST["username"]) and isset($_REQUEST["password"])) {
	//-------------------------------------------------------------------------------------------------
	// Set the cookie for a month for autologin.
	//-------------------------------------------------------------------------------------------------
	setcookie("user", $_REQUEST["username"], time()+60*60*24*30);
	setcookie("pass", md5($_REQUEST["password"]), time()+60*60*24*30);
}

//-------------------------------------------------------------------------------------------------
// Handle which action this is.
//-------------------------------------------------------------------------------------------------
if (isset($_REQUEST["Action"])) {
	$Action = $_REQUEST["Action"];
} else {
	if (isset($Action)) {
	} else {
		$Action = 1;
	}
}

//-------------------------------------------------------------------------------------------------
// Do some session stuff.
//-------------------------------------------------------------------------------------------------
if (isset($_SESSION["LoggedIn"])) {
	if ($_SESSION["LoggedIn"]) {
		
	} else {
		$_SESSION["LoggedIn"] = false;
		$_SESSION["UserID"] = 1;
	}
} else {
	$_SESSION["LoggedIn"] = false;
	$_SESSION["UserID"] = 1;
}

//-------------------------------------------------------------------------------------------------
// Do auth based on cookie values.
//-------------------------------------------------------------------------------------------------
if (isset($_COOKIE["user"]) and isset($_COOKIE["pass"])) {
	if ($_SESSION["LoggedIn"] == false) {
		$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
		$sql="usp_Select_UserAuth2 '".$_COOKIE["user"]."', '".$_COOKIE["pass"]."'"; 
		$rs=odbc_exec($conn,$sql); 
		$LoginStatus = 0;
		while (odbc_fetch_row($rs)) {
			$_SESSION["LoggedIn"] = true;
			$_SESSION["UserName"] = odbc_result($rs,"UserName");
			$_SESSION["UserLevel"] = odbc_result($rs,"UserLevelID_fk");
			$_SESSION["UserID"] = odbc_result($rs,"UserID");
			$_SESSION["LastVisit"] = odbc_result($rs,"LastVisit");
			$_SESSION["TimesVisited"] = odbc_result($rs,"TimesVisited");
			$_SESSION["AddedDate"] = odbc_result($rs,"AddedDate");
			$_SESSION["style_bgcolor"] = odbc_result($rs,"style_bgcolor");
			$_SESSION["Age"] = odbc_result($rs,"Age");
			$LoginStatus = -1;
		}
		LogHistory(7,$_SESSION["UserID"],$LoginStatus);	
		odbc_close($conn);
		$Action = 1;
		$TID = 1;
	}
}

?>
<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="http://buffcon.com/rss.php" />
<html>
<link rel='stylesheet' href='<?php echo $ini_array["StyleSheet"];?>'>
<head>
<title><?php echo $ini_array["SiteName"];?></title>
<LINK REL="SHORTCUT ICON" HREF="images/target.ico">
</head>
<body class='body' bgcolor="<?php if (isset($_SESSION["style_bgcolor"])) { echo $_SESSION["style_bgcolor"]; } else { echo $ini_array["defaultback"]; } ?>">
<!--  -->
<a href='http://buffcon.com'><img src='images/braddoro.jpg' border='0'></a>


<?php
//-------------------------------------------------------------------------------------------------
// Insert a new post.
//-------------------------------------------------------------------------------------------------
if (isset($_POST["TID"]) and isset($_POST["Title"]) and isset($_POST["Post"])) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Insert_Post ".$_SESSION["UserID"].", ".$_POST["TID"].", '".SQLSafe($_POST["Title"])."', '".SQLSafe($_POST["Post"])."'";
	$rs=odbc_exec($conn,$sql); 
	if (!$rs) { 
		exit("Error in SQL");
	} else {
		LogHistory(4,$_SESSION["UserID"],$_POST["TID"]);
	} 
	odbc_close($conn);
	$TID = $_POST["TID"];
}
//-------------------------------------------------------------------------------------------------
// Insert a new reply.
//-------------------------------------------------------------------------------------------------
if (isset($_POST["Comment"])) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Insert_Reply ".$_POST["PID"].", ".$_SESSION["UserID"].", '".SQLSafe($_POST["Comment"])."'";
	$rs=odbc_exec($conn,$sql); 
	if (!$rs) { 
		exit("Error in SQL");
	} else {
		LogHistory(5,$_SESSION["UserID"],$_POST["PID"]);
	} 
	odbc_close($conn);
}
//-------------------------------------------------------------------------------------------------
// Insert a new Link.
//-------------------------------------------------------------------------------------------------
if ($Action == 19) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Insert_Link ".$_POST["PID"].", ".$_SESSION["UserID"].", '".SQLSafe($_POST["LinkDisplay"])."', '".SQLSafe($_POST["LinkURL"])."'";
	$rs=odbc_exec($conn,$sql); 
	if (!$rs) { 
		exit("Error in SQL");
	} else {
		LogHistory($Action,$_SESSION["UserID"],$_POST["PID"]);
	} 
	odbc_close($conn);
}

//-------------------------------------------------------------------------------------------------
// Auth a user.
//-------------------------------------------------------------------------------------------------
if ($Action == 7 and $_SESSION["LoggedIn"] == false) {
	$_SESSION["LoggedIn"] = false;
	$_SESSION["UserName"] = "Guest";
	$_SESSION["UserLevel"] = 1;
	$_SESSION["UserID"] = 1;
	$_SESSION["style_bgcolor"] = $ini_array["defaultback"];
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_UserAuth '".$_REQUEST["username"]."', '".md5($_REQUEST["password"])."'"; 
	$rs=odbc_exec($conn,$sql); 
	$LoginStatus = 0;
	$thesqlstring = $sql;
	while (odbc_fetch_row($rs)) {
		$_SESSION["LoggedIn"] = true;
		$_SESSION["UserName"] = odbc_result($rs,"UserName");
		$_SESSION["UserLevel"] = odbc_result($rs,"UserLevelID_fk");
		$_SESSION["UserID"] = odbc_result($rs,"UserID");
		$_SESSION["LastVisit"] = odbc_result($rs,"LastVisit");
		$_SESSION["TimesVisited"] = odbc_result($rs,"TimesVisited");
		$_SESSION["AddedDate"] = odbc_result($rs,"AddedDate");
		$_SESSION["style_bgcolor"] = odbc_result($rs,"style_bgcolor");
		$_SESSION["Age"] = odbc_result($rs,"Age");
		$LoginStatus = -1;
	}
	LogHistory($Action,$_SESSION["UserID"],$LoginStatus);
	odbc_close($conn);
	$Action = 1;
	$TID = 1;
}

//-------------------------------------------------------------------------------------------------
// Read a message
//-------------------------------------------------------------------------------------------------
if ($Action == 9) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Update_Message ".$_REQUEST["MID"];
	$rs=odbc_exec($conn,$sql); 
	LogHistory($Action,$_SESSION["UserID"],0);
	odbc_close($conn);
	$Action = 8;
}

//-------------------------------------------------------------------------------------------------
// Delete a message
//-------------------------------------------------------------------------------------------------
if ($Action == 10) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Delete_Message ".$_REQUEST["MID"];
	$rs=odbc_exec($conn,$sql); 
	LogHistory($Action,$_SESSION["UserID"],0);
	odbc_close($conn);
	$Action = 8;
}

//-------------------------------------------------------------------------------------------------
// Insert a message
//-------------------------------------------------------------------------------------------------
if ($Action == 11) {
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Insert_Message ".$_POST["ToUserID"].", ".$_SESSION["UserID"].", '".SQLSafe($_POST["Message"])."'";
	$rs=odbc_exec($conn,$sql); 
	LogHistory($Action,$_SESSION["UserID"],0);
	odbc_close($conn);
	$Action = 8;
}

if (isset( $_REQUEST["TID"])) {
	$TID = $_REQUEST["TID"];
} else {
	$TID = 1;
}
?>
<!--  -->
<div class="sidebox" id="sidebox1">
<?php

//-------------------------------------------------------------------------------------------------
// Pasword input.
//-------------------------------------------------------------------------------------------------
if ($_SESSION["LoggedIn"] != true) {
	echo "<table class='tablebox'><tr><td colspan='2' class='header'>Log In</td><tr>";
	echo "<form action='main.php' method='post' name='pass' id='pass'>";
	echo "<input type='hidden' name='Action' id='Action' value='7'>";
	echo "<tr><td class='offset'><p class='passinput'>username</p></td><td class='offset'><input type='text' class='passinput' name='username' id='username' size='10' maxlength='30'></td></tr>";
	echo "<tr><td class='offset'><p class='passinput'>password</p></td><td class='offset'><input type='password' class='passinput' name='password' id='password' size='10' maxlength='15'></td></tr>";
	echo "<tr><td class='offset'>";
	echo "&nbsp;<a href='register.php' class='tiny' title='register for a new account'>new</a>&nbsp;";
	echo "<a href='forgot.php' class='tiny' title='forgot your password'>lost</a>";
	echo "</td><td class='offset'><input type='submit' class='passinput' name='submit' id='submit' value='login'></td></tr>";
	echo "</form>";
	echo "</td></tr></table>";
	echo "<br>";
}

//-------------------------------------------------------------------------------------------------
// Show the user area.
//-------------------------------------------------------------------------------------------------
if ($_SESSION["LoggedIn"] == true) {
	echo "<table class='tablebox'>";
	echo "<tr><td class='header'>".$_SESSION["UserName"]."</td></tr>";
	echo "<tr><td class='offset'>";
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_MessageCount ".$_SESSION["UserID"]; 
	$rs=odbc_exec($conn,$sql); 
	while (odbc_fetch_row($rs)) {
		$Messages = odbc_result($rs,"Messages");
	}
	odbc_close($conn);
	echo "<a href='main.php?Action=8'>";
	if ($Messages > 0) {
		echo "<img src='".$ini_array["drilldown"]."'> ".$Messages." ";
	} else {
		echo "<img src='".$ini_array["blankpage"]."'>send a ";
	}
	echo "message";
	if ($Messages > 1) {
		echo "s";
	}
	echo "</a><br>";
	echo "</td></tr>";
	
	echo "<tr><td class='offset'>";
	echo "<a href='userinfo.php' target='_top'><img src='".$ini_array["userinfo"]."'> change your info</a>";
	echo "</td></tr>";
	
	//echo "<tr><td class='offset'>";
	//echo $_SESSION["TimesVisited"]." visits<br>";
	//echo $_SESSION["Age"]." days since last visit<br>";
	//echo "</td></tr>";
	
	echo "</table>";
	echo "<br>";
}

//-------------------------------------------------------------------------------------------------
// Show the recent visitors.
//-------------------------------------------------------------------------------------------------
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_Select_RecentVisitors"; 
$rs=odbc_exec($conn,$sql); 
echo "<table class='tablebox'>";
echo "<tr><td class='header'>Visitors</td></tr>";
while (odbc_fetch_row($rs)) {
	echo "<tr><td class='offset'>";
	echo "<img src='images/".AgeByHour(odbc_result($rs,"Age"))."' alt='".odbc_result($rs,"Age")."' width='8' height='8' border='1' align='middle'>&nbsp;";
	echo "<a href='main.php?Action=8&To=".odbc_result($rs,"UserID")."' title='".odbc_result($rs,"Age")."'>".odbc_result($rs,"UserName")."</a>";
	if (strlen(odbc_result($rs,"website")) > 0) {
		echo "&nbsp;<a href='".odbc_result($rs,"website")."'><img src='".$ini_array["WebImage"]."' alt='".odbc_result($rs,"website")."'></a>";
	}
	echo "</td>";
}
echo "</table>";
odbc_close($conn);
echo "<br>";


//-------------------------------------------------------------------------------------------------
// Show the replies.
//-------------------------------------------------------------------------------------------------
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_Select_RecentReplies"; 
$rs=odbc_exec($conn,$sql); 
echo "<table class='tablebox'>";
echo "<tr><td class='header'>Replies</td></tr>";
while (odbc_fetch_row($rs)) {
	echo "<tr><td class='offset'>";
	echo "<a href='main.php?TID=".odbc_result($rs,"TopicID_fk")."&Action=3&PID=".odbc_result($rs,"PostID")."' title='".odbc_result($rs,"FullTitle")."'>";
	echo "<img src='images/".AgeByHour(odbc_result($rs,"Age"))."' alt='".odbc_result($rs,"Age")."' width='8' height='8' border='1' align='middle'>&nbsp;";
	echo stripslashes(odbc_result($rs,"Title"))." [".odbc_result($rs,"Replies")."]";
	echo "</a></td></tr>";
}
echo "</table>";
odbc_close($conn);
echo "<br>";

//-------------------------------------------------------------------------------------------------
// Show the links.
//-------------------------------------------------------------------------------------------------
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_Select_Links ".$TID; 
$rs=odbc_exec($conn,$sql); 
$CurrCat = "Foo";

echo "<table class='tablebox'><tr><td class='header'>Links</td><tr><td class='offset'>";
while (odbc_fetch_row($rs)) {
	echo"<a href='".odbc_result($rs,"LinkURL")."' target='_new' title='".stripslashes(odbc_result($rs,"Title"))."'>".odbc_result($rs,"LinkDisplay")."</a><br>";
}
echo "<a href='rss.php'><img src='images/xml.gif' alt='rss' width='36' height='14' border='0'> rss feed</a><br>";
echo "</td></tr></table>";
odbc_close($conn);
echo "<br>";

//-------------------------------------------------------------------------------------------------
// Show the topics.
//-------------------------------------------------------------------------------------------------
$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
$sql="usp_Select_TopicList"; 
$rs=odbc_exec($conn,$sql); 
echo "<table class='tablebox'>";
echo "<tr><td class='header'>Posts</td></tr>";
while (odbc_fetch_row($rs)) {
	echo "<tr><td class='offset'>";
	echo "<a href='main.php?Action=2&TID=".odbc_result($rs,"TopicID")."'>";
	echo "<img src='images/".AgeByDay(odbc_result($rs,"Age"))."' alt='".odbc_result($rs,"Age")."' width='8' height='8' border='1' align='middle'>&nbsp;";	
	echo odbc_result($rs,"Topic")." [".odbc_result($rs,"Posts")."]</a></td></tr>";
}
echo "</table>";
odbc_close($conn);
echo "<br>";

//-------------------------------------------------------------------------------------------------
// Show the counter.
//-------------------------------------------------------------------------------------------------
/*
$counter_file = 'inc/counter.txt';
clearstatcache();
// prevent refresh from aborting file operations and hosing file
ignore_user_abort(true);    
if (file_exists($counter_file)) {
	$fh = fopen($counter_file, 'r+');
   	while(1) {
		if (flock($fh, LOCK_EX)) {
	        // $buffer = chop(fgets($fh, 2));
	        $buffer = chop(fread($fh, filesize($counter_file)));
			if (substr($_SERVER['REMOTE_ADDR'],0,10) != "192.168.1.") {
        		$buffer++;
        		rewind($fh);
        		fwrite($fh, $buffer);
        		fflush($fh);
        		ftruncate($fh, ftell($fh));
        		flock($fh, LOCK_UN);
			}
			break;
		}
	}
} else {
   $fh = fopen($counter_file, 'w+');
   fwrite($fh, "1");
   $buffer="1";
}
fclose($fh);

echo "<p class=''>$buffer"."</p>";
*/
echo "Your IP: ".$_SERVER['REMOTE_ADDR'];
?>
<a href='http://php.net' target='_blank'><img src="<?php echo $ini_array["phpimage"] ?>" alt="" width="88" height="31" border="0"></a>

</div>
<div class="bigbox" id="bigbox1">
<?php
//-------------------------------------------------------------------------------------------------
// Show the default page.
//-------------------------------------------------------------------------------------------------
if ($Action == 1) {
	//-------------------------------------------------------------------------------------------------
	// Show site comment.
	//-------------------------------------------------------------------------------------------------
	echo "<table class='table'>";
	echo "<tr>";
	echo "<td class='data'>";
	echo $ini_array["SiteQuote"];
	echo "</td>";
	echo "</tr>";
	echo "</table><br>";
	LogHistory($Action,$_SESSION["UserID"],$TID);
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_RecentPosts ".$ini_array["DaysBackForRecent"];
	$rs=odbc_exec($conn,$sql); 
	$CurrDay = "";
	while (odbc_fetch_row($rs)) {
		echo "<table class='table'>";
		if ($CurrDay != odbc_result($rs,"DOW")) {
			echo "<tr><td class='banner2'>";
			if (odbc_result($rs,"PostDate") == date("m/d/Y")) {
				echo "Today";
			} else {
				echo odbc_result($rs,"DOW");
			}
			echo "</td></tr>";
		}
		echo "</table>";
		$CurrDay = odbc_result($rs,"DOW");
		echo "<table class='tablebox'>";
		//echo "<tr><td class='header' colspan='2'>".odbc_result($rs,"PostDate")." :: <a href='main.php?Action=2&TID=".odbc_result($rs,"TopicID")."#".odbc_result($rs,"PostID")."'>".odbc_result($rs,"Topic")."</a> ".odbc_result($rs,"Title")."</td></tr>";
		echo "<tr><td class='header' colspan='2'>".odbc_result($rs,"PostDate")." :: <b>".stripslashes(odbc_result($rs,"Topic"))."</b> :: ".stripslashes(odbc_result($rs,"Title"))."</td></tr>";
		//html_entity_decode
		echo "<tr><td class='offset' colspan='2'>".stripslashes(nl2br((odbc_result($rs,"Post"))));
		if (strlen(odbc_result($rs,"Post")) == 250) {
			echo "...&nbsp;<a href='http://buffcon.com/main.php?Action=3&TID=".odbc_result($rs,"TopicID")."&PID=".odbc_result($rs,"PostID")."'>read more <img src='".$ini_array["editicon"]."' alt='edit this item' border='0'></a>";
		}
		echo "</td></tr>";
		echo "<tr><td class='offset'>";
		if ($_SESSION["LoggedIn"] == true) {
			echo "<a href='main.php?Action=8&To=".odbc_result($rs,"UserID")."'><b>".odbc_result($rs,"UserName")."</b></a>";
		} else {
			echo "<b>".odbc_result($rs,"UserName")."</b>";
		}
		if (strlen(odbc_result($rs,"website")) > 0) {
			echo "&nbsp;<a href='".odbc_result($rs,"website")."'><img src='".$ini_array["WebImage"]."' alt='".odbc_result($rs,"website")."'></a>";
		}
		echo "</td><td align='right' class='offset'>";
		echo "<a href='main.php?TID=".odbc_result($rs,"TopicID")."&Action=3&PID=".odbc_result($rs,"PostID")."'>";
		if (odbc_result($rs,"Links") > 0) {
			echo " ".odbc_result($rs,"Links")." Link";
			if (odbc_result($rs,"Links") > 1) {
				echo "s";
			}
			echo "&nbsp;::&nbsp;";
		}
		if (strlen(odbc_result($rs,"NewestDate")) > 0) {
			echo odbc_result($rs,"Replies");
			if (odbc_result($rs,"Replies") > 1) {
				echo" replies ";
			} else {
				echo" reply ";
			}
			echo "&nbsp;<img src='".$ini_array["replynow"]."' alt='edit this item' border='0'></td></tr>";
		} else {
			echo "reply now&nbsp;<img src='".$ini_array["replynow"]."' alt='edit this item' border='0'></a></td></tr>";
		}
		echo "</table><br>";
	}
	odbc_close($conn);
	
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_PostSummary ".($ini_array["DaysBackForRecent"]*4);
	$rs=odbc_exec($conn,$sql); 
	echo "<p class='banner2'>Last 30 Days</p>";
	echo "<table class='tablebox'>";
	echo "<tr><th align='left' class='header'>Topic</th><th align='left' class='header'>Date</th><th align='left' class='header'>Title</th></tr>";
	while (odbc_fetch_row($rs)) {
		echo "<tr>";
		echo "<td nowrap class='offset'><a class='null' name='".odbc_result($rs,"PostID")."'>";
		echo "<a href='main.php?Action=2&TID=".odbc_result($rs,"TopicID")."#".odbc_result($rs,"PostID")."'>";
		echo "<img src='images/".AgeByDay(odbc_result($rs,"Age"))."' alt='".odbc_result($rs,"Age")."' width='8' height='8' border='1' align='middle'>&nbsp;";
		echo stripslashes(odbc_result($rs,"Topic"))."</a></td>";
		echo "<td class='offset'>".odbc_result($rs,"AddedDate")."</td>";
		echo "<td class='offset'><a href='main.php?Action=3&TID=".odbc_result($rs,"TopicID")."&PID=".odbc_result($rs,"PostID")."'>";
		echo stripslashes(odbc_result($rs,"Title"))."&nbsp;[replies ".odbc_result($rs,"Replies")."]</a>&nbsp;";
		echo odbc_result($rs,"UserName");
		if (strlen(odbc_result($rs,"website")) > 0) {
			echo "&nbsp;<a href='".odbc_result($rs,"website")."'><img src='".$ini_array["WebImage"]."' alt='".odbc_result($rs,"website")."'></a>";
		}
		if ($_SESSION["LoggedIn"]) {
			if (odbc_result($rs,"AddedDate") > $_SESSION["LastVisit"] ) {
				echo "&nbsp;<img src='".$ini_array["newimage"]."' alt='new' width='34' height='15' border='0' align='middle'>";
			}
		}
		echo "</td>";
		echo "</tr>";
	}
	odbc_close($conn);
	echo "</table><br>";
	/*
	*/
	
}
//-------------------------------------------------------------------------------------------------
// Show the posts for this topic.
//-------------------------------------------------------------------------------------------------
if ($Action == 2) {

	if (isset($_REQUEST["All"])) {
		$ShowAll = "Y";
	} else {
		$ShowAll = "N";
	}
	LogHistory($Action,$_SESSION["UserID"],$TID);
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_PostsByTopic ".$TID.",'".$ShowAll."'";
	$rs=odbc_exec($conn,$sql); 
	$CurrTopic = stripslashes(odbc_result($rs, "Topic"));
	$Description = odbc_result($rs, "Description");
	echo "<p class='banner2'>".$CurrTopic."</p>";
	if (strlen($Description)) {
		echo " <span class='text2'>".$Description."</span><br><br>";
	}
	odbc_close($conn);
	$rs=odbc_exec($conn,$sql); 
	while (odbc_fetch_row($rs)) {
		echo "<table class='tablebox'>";
		echo "<tr><td class='header' colspan='2'>".odbc_result($rs,"PostDate");
		if (odbc_result($rs,"Age") < 3) {
			echo " at ".odbc_result($rs,"PostTime");
		}
		
		echo " :: ".stripslashes(odbc_result($rs,"Title"))."</td></tr>";
//		html_entity_decode
		echo "<tr><td class='offset' colspan='2'>".substr(stripslashes(nl2br((odbc_result($rs,"Post")))),0,250);
		if (strlen(odbc_result($rs,"Post")) > 250) {
			echo "...&nbsp;<a href='http://buffcon.com/main.php?Action=3&TID=".odbc_result($rs,"TopicID")."&PID=".odbc_result($rs,"PostID")."'>read more <img src='".$ini_array["editicon"]."' alt='edit this item' border='0'></a>";
		}
		echo "</td></tr>";
		echo "<tr>";
		echo "<td class='offset'><b>";
		if ($_SESSION["LoggedIn"] == true) {
			echo "<a href='main.php?Action=8&To=".odbc_result($rs,"UserID")."'><b>".odbc_result($rs,"UserName")."</b></a>";
		} else {
			echo "<b>".odbc_result($rs,"UserName")."</b>";
		}
		if (strlen(odbc_result($rs,"website")) > 0) {
			echo "&nbsp;<a href='".odbc_result($rs,"website")."'><img src='".$ini_array["WebImage"]."' alt='".odbc_result($rs,"website")."'></a>";
		}
		echo "</td><td align='right' class='offset'><a href='main.php?TID=".$TID."&Action=3&PID=".odbc_result($rs,"PostID")."'>";
		if (odbc_result($rs,"Links") > 0) {
			echo " ".odbc_result($rs,"Links")." Link";
			if (odbc_result($rs,"Links") > 1) {
				echo "s";
			}
			echo "&nbsp;::&nbsp;";
		}
		if (strlen(odbc_result($rs,"NewestDate")) > 0) {
			echo odbc_result($rs,"Replies");
			if (odbc_result($rs,"Replies") > 1) {
				echo" replies ";
			} else {
				echo" reply ";
			}
		echo "&nbsp;<img src='".$ini_array["replynow"]."' alt='edit this item' border='0'></td></tr>";
		} else {
			echo "reply now&nbsp;<img src='".$ini_array["replynow"]."' alt='edit this item' border='0'></a></td></tr>";
		}
		echo "</table><br>";
	}
	//-------------------------------------------------------------------------------------------------
	// Show the archive
	//-------------------------------------------------------------------------------------------------
	/*
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_PostArchive ".$TID; 
	$rs=odbc_exec($conn,$sql); 
	echo "<table class='tabletight'>";
	echo "<tr>";
	echo "<td colspan='3' class='header'>Topic Archive</td>";
	echo "</tr>";
	while (odbc_fetch_row($rs)) {
		echo "<tr>";
		echo "<td class='offset'><a href=''>".odbc_result($rs,"Year")." ".odbc_result($rs,"Month")." [".odbc_result($rs,"Posts")."]</a></td>";
		echo "</tr>";
	}
	echo "</table>";
	odbc_close($conn);
	*/
	echo "<a href='http://buffcon.com/main.php?Action=2&TID=".$TID."&All=Y'>Show All Posts for this Topic</a></td>";
} 
if (($Action == 1 or $Action == 2) and $_SESSION["LoggedIn"] == true) {
	if (isset($CurrTopic)) {
	} else {
		$CurrTopic = 0;
	}
	odbc_close($conn);
	//-------------------------------------------------------------------------------------------------
	// Add a new post input.
	//-------------------------------------------------------------------------------------------------
	echo "<form action='main.php' method='post' name='Add' id='Add'>";
	echo "<input type='hidden' name='Action' id='Action' value='2'>";
	echo "<table class='tablebox'>";
	echo "<tr><th class='header' colspan='2'>Add Post</th></tr>";
	echo "<tr>
	<td class='offset'>Topic</td><td class='offset'><select name='TID' id='TID'>";
	echo "<option value='0'></option>";
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_Topics"; 
	$rs=odbc_exec($conn,$sql); 
	while (odbc_fetch_row($rs)) {
		echo "<option value='".odbc_result($rs,"TopicID")."' ";
		if ($TID == odbc_result($rs,"TopicID")) { 
			echo " SELECTED";
		}
		echo ">".odbc_result($rs,"Topic")."</option>";
	}
	odbc_close($conn);
	echo "</select>";
	echo "</td></tr>";
	echo "<tr><td class='offset'>Title</td><td class='offset'><input type='text' name='Title' id='Title' size='75' maxlength='200'></td></tr>";
	echo "<tr><td class='offset'>Post</td><td class='offset'><textarea cols='30' rows='10' name='Post' id='Post' class='table'></textarea></td></tr>";
	echo "<tr><td class='offset'>";
	echo "</td><td class='offset'><input type='submit' name='Submit' id='Submit' value='Submit'></td></tr>";
	echo "</table>";
	echo "</form>";
}
//-------------------------------------------------------------------------------------------------
// Show the original post and the replies for this post.
//-------------------------------------------------------------------------------------------------
if ($Action == 3 or $Action == 19) {
	echo "<p align='center' class='banner2'>Original Post</p>";
	if (isset($_REQUEST["PID"])) {
		$PID = $_REQUEST["PID"];
	} else {
		$PID = 0;
	}
	LogHistory($Action,$_SESSION["UserID"],$PID);
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_Post ".$PID;
	$rs=odbc_exec($conn,$sql); 
	while (odbc_fetch_row($rs)) {
		echo "<table class='tablebox'>";
		echo "<tr><td class='header' colspan='2'>".odbc_result($rs,"PostDate")." :: ".odbc_result($rs,"Topic")." :: ".stripslashes(odbc_result($rs,"Title"))."</td></tr>";
		echo "<tr><td class='offset' colspan='2'>".(stripslashes(nl2br(html_entity_decode(odbc_result($rs,"Post")))))."</td></tr>";
		echo "<tr><td class='offset'><b>";
		if ($_SESSION["LoggedIn"] == true) {
			echo "<a href='main.php?Action=8&To=".odbc_result($rs,"UserID")."'><b>".odbc_result($rs,"UserName")."</b></a>";
		} else {
			echo "<b>".odbc_result($rs,"UserName")."</b>";
		}
		
		if (strlen(odbc_result($rs,"website")) > 0) {
			echo "&nbsp;<a href='".odbc_result($rs,"website")."'><img src='".$ini_array["WebImage"]."' alt='".odbc_result($rs,"website")."'></a>";
		}
		if ($_SESSION["UserID"] == 12) {
			echo "&nbsp;<a href='edits.php?PID=".odbc_result($rs,"PostID")."&TID=".odbc_result($rs,"TopicID")."'><img src='".$ini_array["editicon"]."' alt='edit this item' border='0'></a>&nbsp;";
		}
		echo "</td><td align='right' class='offset'> Views: ".odbc_result($rs,"Views")."</td>";
		echo "</table><br>";
	} 
	odbc_close($conn); 
	//
	//-------------------------------------------------------------------------------------------------
	// Show the related posts.
	//-------------------------------------------------------------------------------------------------
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_ReferencePosts ".$PID;
	$rs=odbc_exec($conn,$sql); 
	$FirstTime = true;
	while (odbc_fetch_row($rs)) {
		if ($FirstTime) {
			echo "<p align='center' class='banner2'>Related Posts</p>";
			$FirstTime = false;
		}
		echo "<table class='table'><tr>";
		echo "<td class='offset'><a href='main.php?TID=".$TID."&Action=3&PID=".odbc_result($rs,"Prior_PostID_fk")."'>".odbc_result($rs,"Topic")." - ".stripslashes(odbc_result($rs,"Title"))."</a></td>";
		echo "</tr></table>";
	}
	odbc_close($conn); 
	echo "<br>";
	
	//-------------------------------------------------------------------------------------------------
	// Show the related Links.
	//-------------------------------------------------------------------------------------------------
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_ReferenceLinks ".$PID;
	$rs=odbc_exec($conn,$sql); 
	$FirstTime = true;
	$Order = 1;
	while (odbc_fetch_row($rs)) {
		if ($FirstTime) {
			$FirstTime = false;
			echo "<p align='center' class='banner2'>Related Links</p>";
			echo "<table class='tabletight'>";
		}
		echo "<tr>";
		echo "<td align='left' class='offset'><b>".$Order."</b>&nbsp;";
		echo odbc_result($rs,"AddedDate");
		echo "&nbsp;&nbsp;";
		echo odbc_result($rs,"UserName");
		echo "&nbsp;&nbsp;";
		echo "<a href='".odbc_result($rs,"LinkURL")."'>".odbc_result($rs,"LinkDisplay")."</a>";
		echo "</tr>";
		$Order++;
	}
	echo "</table><br>";
	odbc_close($conn); 
	
	//-------------------------------------------------------------------------------------------------
	// Show the related replies.
	//-------------------------------------------------------------------------------------------------
	echo "<p align='center' class='banner2'>Replies</p>";
	if (isset($_REQUEST["PID"])) {
		$PID = $_REQUEST["PID"];
	} else {
		$PID = 0;
	}
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_Replies ".$PID;
	$rs=odbc_exec($conn,$sql); 
	while (odbc_fetch_row($rs)) {
		echo "<table class='tablebox'>";
		echo "<tr><td class='header'><a class='null' name='".odbc_result($rs,"ReplyID")."'>".odbc_result($rs,"ReplyDate");
		if (odbc_result($rs,"Age") < 24) {
			echo " :: Posted ".odbc_result($rs,"Age")." hours ago</td></tr>";
		}
		echo "<tr><td class='offset' colspan='2'>".stripslashes(nl2br(odbc_result($rs,"Reply")))."</td></tr>";
		echo "<tr><td class='offset'><b>";
		if ($_SESSION["LoggedIn"] == true) {
			echo "<a href='main.php?Action=8&To=".odbc_result($rs,"UserID")."'><b>".odbc_result($rs,"UserName")."</b></a>";
		} else {
			echo "<b>".odbc_result($rs,"UserName")."</b>";
		}
		if (strlen(odbc_result($rs,"website")) > 0) {
			echo "&nbsp;<a href='".odbc_result($rs,"website")."'><img src='".$ini_array["WebImage"]."' alt='".odbc_result($rs,"website")."'></a>";
		}
		if ($_SESSION["UserID"] == 12) {
			echo "&nbsp;<a href='edits.php?RID=".odbc_result($rs,"ReplyID")."'><img src='".$ini_array["editicon"]."' alt='edit this item' border='0'></a>&nbsp;";
		}
		echo "</td></tr>";
		echo "</table><br>";
	}
	odbc_close($conn); 
	echo "<form action='main.php' method='post' name='Add' id='Add'>";
	echo "<input type='hidden' name='TID' id='TID' value='".$_REQUEST["TID"]."'>";
	echo "<input type='hidden' name='PID' id='PID' value='".$_REQUEST["PID"]."'>";
	echo "<input type='hidden' name='Action' id='Action' value='3'>";
	echo "<table class='tablebox'>";
	echo "<tr><th class='header'>Add Reply</th></tr>";
	echo "<tr><td class='offset'>";
	echo "<textarea cols='30' rows='10' name='Comment' id='Comment' class='table'></textarea>";
	echo "</td></tr>";
	echo "<tr><td class='offset'>";
	echo "<input type='submit' name='Submit' id='Submit' value='Submit'>";
	echo "</td></tr>";
	echo "</table>";
	echo "</form>";

	echo "<br>";
	echo "<form action='main.php' method='post' name='AddLink' id='AddLink'>";
	echo "<input type='hidden' name='TID' id='TID' value='".$_REQUEST["TID"]."'>";
	echo "<input type='hidden' name='PID' id='PID' value='".$_REQUEST["PID"]."'>";
	echo "<input type='hidden' name='Action' id='Action' value='19'>";
	echo "<table class='tablebox'>";
	echo "<tr><th colspan='2' class='header'>Add Link</th></tr>";
	echo "<tr><td class='offset'>Link Display</td><td class='offset'>";
	echo "<input type='text' name='LinkDisplay' id='LinkDisplay' size='100' maxlength='200'>";
	echo "</td></tr>";
	echo "<tr><td class='offset'>Link URL</td><td class='offset'>";
	echo "<input type='text' name='LinkURL' id='LinkURL' size='100' maxlength='200'>";
	echo "</td></tr>";
	echo "<tr><td class='offset'></td><td class='offset'>";
	echo "<input type='submit' name='Submit' id='Submit' value='Submit'>";
	echo "</td></tr>";
	echo "</table>";
	echo "</form>";
}

//-------------------------------------------------------------------------------------------------
// Show the webcam.
//-------------------------------------------------------------------------------------------------
if ($Action == 6) {
	LogHistory($Action,$_SESSION["UserID"],0);
	echo "<meta http-equiv='Refresh' content='15'>";
	echo "<img src='http://buffcon.com:81' alt='webcam'><br>";
}

//-------------------------------------------------------------------------------------------------
// Show the messages.
//-------------------------------------------------------------------------------------------------
if ($Action == 8 or $Action == 9 or $Action == 10 or $Action == 11) {
	echo "<form action='main.php' method='post' name='message' id='message'>";
	echo "<input type='hidden' name='Action' id='Action' value='11'>";
	echo "<input type='hidden' name='TID' id='TID' value='0'>";	
	echo "<table class='tablebox'>";
	echo "<tr><td class='header'>New Message</td></tr>";
	echo "<tr><td class='offset'><select name='ToUserID' id='ToUserID'>";
	echo "<option value='0'></option>";
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]);
	$sql="usp_Select_UserNames";
	$rs=odbc_exec($conn,$sql); 
	if (isset($_REQUEST["To"])) {
		$ToID = $_REQUEST["To"];
	} else {
		$ToID = 0;
	}
	while (odbc_fetch_row($rs)) {
		echo "<option value='".odbc_result($rs,"UserID")."'";
		if ($ToID == odbc_result($rs,"UserID")) {
			echo " SELECTED";
		}
		echo ">".odbc_result($rs,"UserName")."</option>";
	}
	odbc_close($conn); 
	echo "</select></td></tr>";
	echo "<tr><td class='offset'><textarea cols='30' rows='5' name='Message' id='Message' class='table'></textarea></td></tr>";
	echo "<tr><td class='offset'><input type='submit' name='Submit' id='Submit' value='Submit'></td></tr>";
	echo "</table>";
	echo "</form><br>";
	
	LogHistory($Action,$_SESSION["UserID"],$TID);
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_Messages ".$_SESSION["UserID"];
	$rs=odbc_exec($conn,$sql); 
	echo "<p class='banner2'>Messages</p>";
	while (odbc_fetch_row($rs)) {
		echo "<table class='tablebox'>";
		echo "<tr><td class='header'>";
		if (odbc_result($rs,"FromUserID_fk") == $_SESSION["UserID"]) {
			echo "To: ".odbc_result($rs,"To");
		} else {
			echo "From: <a href='main.php?Action=8&To=".odbc_result($rs,"FromUserID_fk")."'>".odbc_result($rs,"From")."</a>";
		}
		echo " :: Sent ".odbc_result($rs,"Age")." days ago";
		echo "</td><tr>";
		echo "<tr><td class='offset'>".stripslashes(nl2br(odbc_result($rs,"Message")))."</td><tr>";
		echo "<tr><td class='offset'>";
		if (odbc_result($rs,"ReadDate") == NULL) {
			if (odbc_result($rs,"FromUserID_fk") != $_SESSION["UserID"]) {
				echo "<a href='main.php?Action=9&MID=".odbc_result($rs,"MessageID")."' title='mark as read'><img src='".$ini_array["readmessage"]."' alt='mark as read' width='16' height='16' border='0'>mark as read</a>";
			}
		} else {
			echo "<b>Read ".odbc_result($rs,"ReadDate")." days ago</b>";
		}
		echo "&nbsp;";
		echo "<a href='main.php?Action=10&MID=".odbc_result($rs,"MessageID")."' title='delete'><img src='".$ini_array["deletemessage"]."' alt='delete message' name='delete' id='delete' width='20' height='20' border='0'>delete message</a>";
		echo "</td><tr>";
		echo "</table><br>";
	}
} 

//-------------------------------------------------------------------------------------------------
// Log file
//-------------------------------------------------------------------------------------------------
if ($Action == 12) {
	LogHistory($Action,$_SESSION["UserID"],0);
/*	
	echo "<p class='banner2'>Posting Activity</p>";
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_Activity"; 
	$rs=odbc_exec($conn,$sql); 
	echo "<table class='table'>";
	echo "<tr>
	<td class='header'>Day</td>
	<td class='header'>Name</td>
	<td class='header'>Action</td>
	<td class='header'>IP Address</td>
	<td class='header'>Total</td>
	</tr>";
	while (odbc_fetch_row($rs)) {
		echo "<tr>";
		echo "<td class='offset'>".odbc_result($rs,"Day")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"UserName")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"Object")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"IPAddress")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"Total")."</td>";
		echo "</tr>";
	}
	echo "</table>";
	odbc_close($conn);
	echo "<br>";

	echo "<p class='banner2'>Referrers</p>";
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_Referrers"; 
	$rs=odbc_exec($conn,$sql); 
	echo "<table class='table'>";
	echo "<tr>
	<td class='header'>Date</td>
	<td class='header'>IP Address</td>
	<td class='header'>Referrer</td>
	<td class='header'>Browser</td>
	</tr>";
	while (odbc_fetch_row($rs)) {
		echo "<tr>";
		echo "<td class='offset'>".odbc_result($rs,"AddedDate")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"REMOTE_ADDR")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"HTTP_REFERER")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"HTTP_USER_AGENT")."</td>";
		echo "</tr>";
	}
	echo "</table>";
	odbc_close($conn);
	echo "<br>";
*/	
	echo "<p class='banner2'>Log File</p>";
	$conn=odbc_connect($ini_array["DSN"],$ini_array["UN"],$ini_array["PWD"]); 
	$sql="usp_Select_History 1"; 
	$rs=odbc_exec($conn,$sql); 
	echo "<table class='table'>";
	echo "<tr>
	<td class='header'>Date</td>
	<td class='header'>User</td>
	<td class='header'>Action</td>
	<td class='header'>Topic</td>
	<td class='header'>IP Address</td>
	</tr>";
	while (odbc_fetch_row($rs)) {
		echo "<tr>";
		echo "<td class='offset'>".odbc_result($rs,"AddedDate")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"UserName")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"Object")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"Theme")."</td>";
		echo "<td class='offset'>".odbc_result($rs,"IPAddress")."</td>";
		echo "</tr>";
	}
	echo "</table>";
	odbc_close($conn);
	echo "<br>";
} 

if ($Action == 13) {
	echo "<p class='banner2'>File Upload</p>";
	if ($_SESSION["LoggedIn"] == false) {
		echo "<p class='text2'>You must be logged in to use the file upload.</p>";
	} else {
		if (isset($_POST["FileUp"])) {
			$FileUp=$_POST["FileUp"];
		} else {
			$FileUp="";
		}
		if (isset($_POST["Location"])) {
			$UploadDir = $_POST["Location"];
		} else {
			$UploadDir = "";
		}
		echo "<table class='tabletight'>";
		echo "<tr>";
		echo "<td class='offset'>";
		echo "<form action='main.php' method='post' enctype='multipart/form-data' name='upload' id='upload'>";
		echo "<input type='hidden' name='Action' id='Action' value='13'>";
		echo "<input type='hidden' name='MAX_FILE_SIZE' id='MAX_FILE_SIZE' value='2000000000'>";
		echo "<p class='text1'>Choose a location to upload the file</p><br>";
		echo "<input type='radio' name='Location' value='news/'>posts<br>";
		echo "<input type='radio' name='Location' value='private/'>private<br>";
		echo "<br><p class='text1'>Choose a file name</p><br>";
		echo "<input type='file' name='FileUp' id='FileUp' size='50'><br>";
		echo "<input type='submit' name='Submit' id='Submit' value='submit'>";
		echo "</form>";
		if (isset($_FILES["FileUp"]["name"])) {
			$CompareTo = ".asax.ascx.ashx.asmx.aspx.ade.adp.asa.asp.asx.axd.bas.bat.cfm.cs.cdx.config.csproj.cfml.cer.chm.cmd.com.cpl.crt.dbm.dll.exe.hlp.hta.htr.htm.html.idc.inf.ins.isp.js.jse.licx.lnk.mdb.mde.mdt.mdw.mdz.msc.msi.msp.mst.pcd.printer.pif.pl.pm.php.reg.red.resx.resources.scf.soap.scr.sct.shb.shtm.shtml.stm.shs.url.vb.vbe.vbs.vbproj.vsdisco.ws.webinfo.wsc.wsf.wsh";
			//$CompareTo = "foo";
			$Spot = strpos(strrev($_FILES["FileUp"]["name"]),".");
			$Extention = substr($_FILES["FileUp"]["name"],strlen($_FILES["FileUp"]["name"])-$Spot, $Spot);
			if (strpos($CompareTo, $Extention)) {
				echo "<span class='text1'><b>Rejected:</b> Files with an extention of ".$Extention." are not allowed.</span><br>";
			} else {
				if (move_uploaded_file($_FILES["FileUp"]["tmp_name"], $UploadDir.$_FILES["FileUp"]["name"])) {
					echo "File uploaded to: <a href='".$UploadDir.$_FILES["FileUp"]["name"]."'>".$UploadDir.$_FILES["FileUp"]["name"]."</a><br>";
					echo "The file size was: ".$_FILES["FileUp"]["size"]."<br>";
					LogHistory(17,$_SESSION["UserID"],0);
				} else {
					LogHistory(18,$_SESSION["UserID"],0);
					switch (true) {
				    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_NO_FILE):
				    case empty($file_data):
				        echo "Select a file to upload.<br>";
				        break;
				    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_INI_SIZE):
				        echo "The uploaded file exceeds the max filesize.<br>";
				        break;
				    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_FORM_SIZE):   
				        echo "The file you have attempted to upload is too large<br>";
				        break;
				    case ($_FILES['FileUp']['error'] == UPLOAD_ERR_PARTIAL):   
				        echo "An error occured while trying to recieve the file. Please try again.<br>";
				        break;
					}
				}
			}
		}
		echo "The maximum file size is somewhere around 5 megs.";
		echo "</td>";
		echo "</tr>";
		echo "</table>";
	}
}
?>
</div>
</body>
</html>