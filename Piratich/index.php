<?php	// Сайт "Документация"
session_cache_limiter("private");
ini_set('display_errors',1);
error_reporting(E_ALL);
session_start();
include ('connectToMySql.php');
$thePostAction='index.php';


$adminLogin='';
$adminPsw='';

if (!($res = $mysqli->query("SELECT isAdminExist() as _adminflag")))
		{
			echo "isAdminExist error: (" . $mysqli->errno . ") " . $mysqli->error;
		}
		$row = $res->fetch_assoc();
		$adminflag = $row['_adminflag'];
		if ($adminflag==0)
		{

			// В системе нет ни одного администратора - блок начальной инициализации

	printf("No Admin-users. We will create one: %s\n", $adminflag);
	// В начале создаем роль АДМИНИСТРАТОРА - DocAdminRole
	if (!($res = $mysqli->query("SELECT RoleCreateNewRole('DocAdminRole','Администратор') as _idAdminRole")))
	{
    echo "RoleCreateNewRole error: (" . $mysqli->errno . ") " . $mysqli->error;
	}
	else
	{ //Создание роли Администратора = Данные получены
		$row = $res->fetch_assoc();
		$idAdminRole = $row['_idAdminRole'];
	//	printf("RoleCreateNewRole result : %s\n", $idAdminRole);
		if ($idAdminRole==-32)
			{//  Создание роли: Нельзя создать роль. Роль с таким наименованием уже существует.
			 // Тогда просто получим ID этой роли
				if (!($res = $mysqli->query("SELECT RoleGetIdRoleUsingRoleName('DocAdminRole') as _getIdRole")))
				{
				echo "RoleGetIdRoleUsingRoleName error: (" . $mysqli->errno . ") " . $mysqli->error;
				}
				else
				{ // Получены данные для IdRole
					$row = $res->fetch_assoc();
					$idAdminRole = $row['_getIdRole'];
				//	printf("RoleGetIdRoleUsingRoleName result : %s\n", $idAdminRole); // Получено IdRole
				} // Получены данные для IdRole
			} //  Создание роли: Нельзя создать роль. Роль с таким наименованием уже существует.

	} //Создание роли Администратора = Данные получены

	/*
	// Проверка SALT
	if (!($res = $mysqli->query("SELECT createSalt() as _salt")))
		{
			echo "Получить данные не удалось: (" . $mysqli->errno . ") " . $mysqli->error;
		}
		$row = $res->fetch_assoc();
		$salt = (String)$row['_salt'];
		printf("SALT: %s\n", $salt);
	*/

	// Роль администратора либо создана, либо получена. Её ID - в $idAdminRole

	// Создаем пользователя - администратора
	if (!($res = $mysqli->query("SELECT UserCreate('DocAdmin','111','admin@admin.ru',
                                'Администратор',NULL,NULL,NULL,NULL) as _idAdminUser")))
		{
			echo "UserCreate error: (" . $mysqli->errno . ") " . $mysqli->error;
		}
		else
		{ // Либо user-админ создан, либо уже существовал
			$row = $res->fetch_assoc();
			$idAdminUser = $row['_idAdminUser'];
		//	printf("Result UserCreate : %s\n", $idAdminUser);

			if ($idAdminUser < 0)
			{ // user-админ НЕ СОЗДАН
		      printf("Doc Admin exist. Get DocAdminID \n");
				if ($idAdminUser == -121) // не создан, потому что уже существует ?
				{ // ДА
					if (!($res = $mysqli->query("SELECT UserGetIdUsingLogin('DocAdmin') as _idAdminUser")))
						{
						echo "UserGetIdUsingLogin error: (" . $mysqli->errno . ") " . $mysqli->error;
						}
					else
						{ // Получили  idAdminUser
							$row = $res->fetch_assoc();
							$idAdminUser = $row['_idAdminUser'];
						//	printf("UserGetIdUsingLogin result : %s\n", $idAdminUser);
						}
				} // Да, не создан, потому что уже существует
			} // user-админ НЕ СОЗДАН
		} // Либо user-админ создан, либо уже существовал

	// printf("BEFORE MAP: Id DocAdmin : %s ID Admin Role : %s \n", $idAdminUser,$idAdminRole);
	if (( $idAdminUser >0) and ($idAdminRole>0))
	{ // Админ - пользователь и Админ-роль существуют. Создать связь

		if (!($res = $mysqli->query("SELECT mapIdUserToIdRole($idAdminUser,$idAdminRole) as _mapResult")))
		{
			echo "mapIdUserToIdRole error: (" . $mysqli->errno . ") " . $mysqli->error;
		}
		else
		{ // Либо user-админ создан, либо уже существовал
			$row = $res->fetch_assoc();
			$mapResult = $row['_mapResult'];
		//	printf("Admin user to Admin role map result : %s\n", $mapResult);
		if ($mapResult == 0)
                    {
                    printf("Admin-user, Admin-role and MAP Admin-user -> Admin-role created.\n");
                    }
                }

	}
		}// В системе нет ни одного администратора - блок начальной инициализации
		else
		{
			//	 printf("Admin-user exist.\n");
		}
		// Предполагаем, что аутентификация не выполнена.
 // (Блок сброса в исходное состояния переменных, связанных с аутентификацией )

 $adminflag=null;
 $idAdminRole =null;
 $idAdminUser=null;
 $row=null;
 $mapResult=null;
 // =======================================================================
 // Получение имени пользователя и пароля, если таковые предоставлены
 $adminLogin='';
if (isset($_POST['adminLogin']))
{
$adminLogin= $_POST['adminLogin'];
unset ($_POST['adminLogin']);
}
 $adminPsw='';
if (isset($_POST['adminPsw']))
{
	$adminPsw= $_POST['adminPsw'];
	unset ($_POST['adminPsw']);
}

/*
CREATE DEFINER=`doc2016ProcExec`@`localhost` procedure `UserAuth`(
IN pUserLogin varchar (20), -- Login пользователя
IN pUserPassword varchar (255), -- Пароль пользователя
OUT pUserID INT,  -- ID пользователя
OUT pUserEmail varchar (255), -- E-mail пользователя
OUT pUserNick varchar (255), -- Nick пользователя
OUT pIsUserLoginApproved bit(1), --  'Login  одобрен (1) или не одобрен (0) администратором'
OUT pUseractive bit(1),-- Пользователь  активен (1) или блокирован (0)'
OUT pUserregdate datetime ,-- Дата и время регистрации пользователя',
OUT pUser_must_change_psw bit(1), -- При следующем входе пользователь ОБЯЗАН сменить парлоль
OUT pUserAuthResultCode INT  -- Код результата аутентификации пользователя
*/
// printf("BEFORE IF adminLogin = %s \n", $adminLogin);
// printf("BEFORE IF adminPsw = %s \n", $adminPsw);
if (($adminLogin<>'') and ($adminPsw<>'') )
{ // Логин  и пароль введены
if
	( // Подготовка параметров и вызов функции зпроса аутентификации
	!$mysqli->query("SET @pUserID = 0") ||
	!$mysqli->query("SET @pUserEmail = ''") ||
	!$mysqli->query("SET @pUserNick = ''") ||
	!$mysqli->query("SET @pIsUserLoginApproved = 0") ||
	!$mysqli->query("SET @pUseractive = 0") ||
	!$mysqli->query("SET @pUserregdate = 0") ||
	!$mysqli->query("SET @pUser_must_change_psw = 0") ||
	!$mysqli->query("SET @pUserAuthResultCode = 0") ||
	!$mysqli->query("CALL UserAuth('".$adminLogin."','".$adminPsw."',
    @pUserID,@pUserEmail,@pUserNick,@pIsUserLoginApproved,
    @pUseractive,@pUserregdate,@pUser_must_change_psw,@pUserAuthResultCode)")
	)
    { // Сбой аутентификации (программная ошибка)
    echo "CALL UserAuth ERROR: (" . $mysqli->errno . ") " . $mysqli->error;
    }
// Получение результата запроса на аутентификацию
if (!($res = $mysqli->query("SELECT @pUserID as _pUserID,
									@pUserEmail as _pUserEmail,
									@pUserNick  as _pUserNick ,
									@pUseractive as _pUseractive,
									@pUser_must_change_psw as _pUser_must_change_psw,
									@pUserAuthResultCode as _pUserAuthResultCode
									")))
									{
									echo "CALL UserAuth Data not found: (" . $mysqli->errno . ") " . $mysqli->error;
									}

$row = $res->fetch_assoc();
$UserId = $row['_pUserID'];
$UserEmail = $row['_pUserEmail'];
$UserNick = $row['_pUserNick'];
$pUseractive = $row['_pUseractive'];
$pUser_must_change_psw = $row['_pUser_must_change_psw'];
$pUserAuthResultCode = $row['_pUserAuthResultCode'];

 printf("After authentification : UserAuthResultCode= %s \n", $pUserAuthResultCode);
// Получить сообщение об ошибке по ее коду

		if (!($res = $mysqli->query("SELECT ErrorGetErrorMessage($pUserAuthResultCode,'ru-ru') as _errMsg")))
		{
			echo "ErrorGetErrorMessage error: (" . $mysqli->errno . ") " . $mysqli->error;
		}
		else
		{ // Сообщение об ошибке получено
			$row = $res->fetch_assoc();
			$errMsg = 'Код:'.$pUserAuthResultCode.' '.$row['_errMsg'];
			$_SESSION['errMsg']=$errMsg; 		// Сообщение системы аутентификации пользователя


		} // Сообщение об ошибке получено


// printf("After authentification : UserId = %s UserEmail = %s \n", $UserId ,$UserEmail);


$extra = '';

if ($pUserAuthResultCode == -146 ) // Код результата аутентификации пользователя: Успешно аутентифицирован.
{
		$_SESSION['authentificated']=1; 	// Пользователь успешно аутентифицирован.
		$_SESSION['UserId']=$UserId;		// Id аутентифицированного пользователя
		$_SESSION['UserLogin']=$adminLogin; // Логин аутентифифированного пользователя
		$_SESSION['UserNick']=$UserNick; 	// Ник аутентифифированного пользователя
		$_SESSION['errMsg']=$errMsg; 		// Сообщение системы аутентификации пользователя
		$_SESSION['extra']='adminControlPanel.php';

	//	printf("SET extra. pUserAuthResultCode = %s  EXTRA = %s \n", $pUserAuthResultCode,$_SESSION['extra']);


}
//if (($pUserAuthResultCode == -144 )or ($pUserAuthResultCode == -145 ))
// Код результата аутентификации пользователя: -144 - ошиб логин, 145 - непр пароль
else
{


		$_SESSION['authentificated']=NULL; 	// Пользователь успешно аутентифицирован.
		$_SESSION['UserId']=NULL;		// Id аутентифицированного пользователя
		$_SESSION['UserLogin']=NULL; // Логин аутентифифированного пользователя
		$_SESSION['UserNick']=NULL; 	// Ник аутентифифированного пользователя
		$_SESSION['errMsg']=$errMsg; 		// Сообщение системы аутентификации пользователя
		$_SESSION['extra']='index.php';

	//	printf("SET extra. pUserAuthResultCode = %s  EXTRA = %s \n", $pUserAuthResultCode,$_SESSION['extra']);

}
if ($_SESSION['extra'])
 {
		$extra =$_SESSION['extra'];
		if ($extra !='index.php')
		{
		$thehost  = $_SERVER['HTTP_HOST'];
		$uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');

		header('HTTP/1.1 200 OK');
		header("Location: http://$thehost$uri/$extra");
		exit();
		}
 }
unset($_SESSION['extra']);
// printf("Index2_session_EXTRA_2: %s\n",$_SESSION['extra']);
} // Логин  и пароль введены
else
{
	if (isset($_SESSION['LoginPasswordEmpty']))
	{
	$errMsg= 'Поля"Логин" и "Пароль" не могут быть незаполнены';
	$_SESSION['errMsg']=$errMsg; 		// Сообщение системы аутентификации пользователя
	}

	$_SESSION['LoginPasswordEmpty']=true;
}
// Закрытие соединения MySQL
$mysqli->close();

$thePostAction='index.php';
include ('EducAdminHeader.php');

echo <<<_PROJECTDOC
<div class="thinDivider"> </div>
<article class="mainArticle" >
	<header  class="headerArticle">Вход на сайт</header>
		<table class="adminLoginTable">
			<tr>
				<td>Логин:</td>
				<td width="50%"> <input type="text"  name="adminLogin"  /> </td>
			</tr>
			<tr>
				<td>Пароль:</td>
				<td > <input type="password"  name="adminPsw" /> </td>
			</tr>
			<tr>
				<td></td>
				<td> <input type="image" src="/images/illum.jpg" width="140" height="30" alt="Вход" ALIGN=ABSMIDDLE/> </td>
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
