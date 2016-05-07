<?php chdir('..'); ?>
<?php include("includes/awb_init.php"); ?>
<?php include("includes/awb_header_start.php"); ?>
<link rel="stylesheet" href="../../theme/style.css" type="text/css"/>
<link rel="stylesheet" href="../theme/style.css" type="text/css"/>
<?php include("includes/awb_header_end.php"); ?>

<!-- START OF VARIABLE CONTENT -->

<div class="title"><a name="top">&nbsp;</a>consanguinity</div>
<p class="footer">
<br /><br />
<a href="../index.php#top" ><img src="../theme/h.gif" alt="Homepage" title="Homepage"/></a>
</p>
<div class="contreport">
<p class="decal"><br /><span class="gras">Description </span></p>
<p class="description">That report display how many ancestors were find, the rate cover, the implex cover and the degree of inbreeding. The rate cover is the rate between known ancestors and possible ancestors. An implex is a person appear several times in the ancestry tree. So, the implex rate is the report between the number of common ancestors and the number known ancestors. No common ancestor give 0. Example: If a individua has got 100 ancestors, but only various 80, the implex rate is (100 - 80) / 100 = 20%. The degree of inbreeding is the probability the two alleles individua is same descent. This suppose same ancestor is sharing by each individual's parent.</p>
<div class="spacer">&nbsp;</div>
</div>
<div class="contreport">
<p class="decal"><br /><span class="gras">Root individual</span></p>
<p class="column1">
<?php echo authgen() ? "<img src='../theme/m.gif' alt='Man' />" : "<img src='../theme/u.gif' alt='Unknown sex' />" ?>&nbsp;<a href='../details/personsdetails_1.php#I00001'><?php echo authgen() ? "HUGHES, Brad Scott&nbsp;(I00001)" : "..., ...&nbsp;(...)" ?></a><?php echo authgen() ? "&nbsp;(11 Sep 1962)" : "&nbsp;(...)" ?>
<br /><br />
Implex cover :&nbsp;0.0%
<br />
degree of inbreeding :&nbsp;0.0
<br /></p>
<table border="0" cellspacing="0" cellpadding="5" class="column1"><thead><tr>
<th>Generation</th>
<th>Possible </th>
<th>Known</th>
<th>% </th>
<th>Cumul </th>
<th>% </th>
<th>Different</th>
<th>Diff. Cumul </th>
<th>Implex</th>
</tr></thead>
<tbody>
<tr>
<td>1</td>
<td>1</td>
<td>1</td>
<td>100.0</td>
<td>1</td>
<td>100.0</td>
<td>1</td>
<td>1</td>
<td>0.0</td>
</tr>
<tr>
<td>2</td>
<td>2</td>
<td>2</td>
<td>100.0</td>
<td>3</td>
<td>100.0</td>
<td>2</td>
<td>3</td>
<td>0.0</td>
</tr>
</tbody></table>
<div class="spacer">&nbsp;</div></div>
<div class="contreport">
<p class="decal"><br /><span class="gras">Common ancestors list for the implex rate</span></p>
<p class="column1">
</p>
<div class="spacer">&nbsp;</div>
</div>
<div class="contreport">
<p class="decal"><br /><span class="gras">Common ancestors list for the degree of inbreeding</span></p>
</div>
<p><a name="bot"></a>&nbsp;</p>

<!-- END OF VARIABLE CONTENT -->

<?php include("includes/awb_footer.php"); ?>
