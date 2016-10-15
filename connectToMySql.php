<?php //connection to mysql
include ('class_iniFile.php');
$ini = new iniFile('doc2016.ini'); //create ini
$iniArray = $ini->read();   //massive have been read
$MySqlServer = $iniArray['MySQL_params']['MySqlServer'];
echo $MySqlServer; 
echo "<br>"
$MySqlDatabase = $iniArray['MySQL_params']['MySqlDatabase'];
$MySqlUser = $iniArray['MySQL_params']['MySqlUser'];
$MySqlPsw = $iniArray['MySQL_params']['MySqlPsw'];

$mysqli = mysqli_connect($MySqlServer, $MySqlUser, $MySqlPsw, $MySqlDatabase);
if (mysqli_connect_errno()) {
	printf("Unable to connect to MySQL: %s\%n", mysqli_connect_error());
	exit();
}
$mysqli->set_charset('utf-8');
?>
