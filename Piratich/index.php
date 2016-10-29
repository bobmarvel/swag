<?php
session_cache_limiter("private");
session_start();
$thePostAction='index.php';
//ini_set('display_errors', 1);
//error_reporting(E_ALL);
include ('connectToMySql.php');
include ('EducAdminHeader.php');
$adminLogin='';
$adminPsw='';
if (!($res = $mysqli->query("SELECT isAdminExist() as _adminflag")))
{
	echo "isAdminExist error: (" . $mysqli->errno . ") " . $mysqli->error;
}
$row = $res-> fetch_assoc();
$adminflag = $row['_adminflag'];
// printf("Existence at least one admin: %s\n", $adminflag);
if ($adminflag==0)
{
	//there's no admin - initial block
}
else 
{
	// printf("admin-user exist.\n");
}
echo <<<_PROJECTDOC
<div class="thinDivider></div>
<article class="mainArticle">
	<header class="headerArticle">Sign in</header>
		<table class="adminLoginTable">
		<tr>
			<td>Login:</td>
			<td width="50%"> <input type="text" name="adminLogin" /> </td>
		</tr>
		<tr>
			<td>Password:</td>
			<td width="50%"><input type="password" name="adminPsw" /> </td>
		</tr>
		<tr>
			<td> </td>
			<td> <input type="image" src="/images/illum.jpg" width="140" height="24" alt="Login" ALIGN=ABSMIDDLE> </td>
		</tr>
_PROJECTDOC;
if (isset($_SESSION['errMsg']))
	{
		$errMsg = $_SESSION['errMsg'];
echo <<<_PROJECTDOC
		<tr>
		<td colspan="2">$errMsg</td>
		</tr>
_PROJECTDOC;
	}
echo <<<_PROJECTDOC
		</table>
	</article>
	</body>
	</html>
_PROJECTDOC;


 ?>