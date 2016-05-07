<br><a href='default.php'>main</a> | <a href='addissue.php'>add issue</a>
<?php if (isset($_REQUEST["ID"])) {echo " | <a href='issue.php?ID=".$_REQUEST["ID"]."'>issue detail</a>";} ?>
<?php if (isset($_REQUEST["ID"])) {echo " | <a href='addwork.php?ID=".$_REQUEST["ID"]."'>add work item</a>";} ?>

