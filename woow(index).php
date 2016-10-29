<?php 
session_start();
$_SESSION = array(); // сброс сессионных переменных

if (ini_get("session.use_cookies"))   // delete session cookies
{
	$params = session_get_cookie_params();
	setcookie(session_name(), '', time() - 42000,
		$params["path"], $params["domain"],
		$params["secure"], $params["httponly"]
	);
}

session_destroy(); // destroying session

session_cache_limiter ("private");

session_start();
	unset ($_SESSION['extra']);
	unset ($_SESSION['authentificated']);
	unset ($_SESSION['errMsg']);
	$thehost = $_SERVER['HTTP_HOST'];
	$uri = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
	$extra1 = 'docAdmin/index.php'; // forcing to code starting 
	header ('HTTP/1.1 200 OK');
	header ("Location: http://$thehost$uri/$extra1");
	exit();
?>