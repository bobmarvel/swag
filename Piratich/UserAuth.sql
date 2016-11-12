DELIMITER $$
CREATE DEFINER=`diana`@`localhost` PROCEDURE `UserAuth`(
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
)
    COMMENT 'Процедура  аутентификации пользователя'
LUserAuth: BEGIN 

DECLARE tUserPswSalt char (10);
DECLARE tUserPsw varchar (255);
DECLARE tPswMD5 char(32);

declare baseStr char (50);
DECLARE theSalt varchar(10) DEFAULT "";
DECLARE tUserId INT default -1;

declare users_iduser INT;
declare users_userlogin varchar(20);
declare users_userpswMD5 char(32);
declare users_userEmail varchar(255);
declare users_userNick varchar(255);
declare users_userloginapproved bit(1);
declare users_useractive bit(1);
declare users_userregdate datetime;
declare users_user_must_change_psw bit(1);
declare users_userPswSalt char(10);


SET pUserID =-1; -- ID пользователя
SET pUserEmail =""; -- E-mail пользователя
SET pUserNick =""; -- Nick пользователя
SET  pIsUserLoginApproved =false; --  'Login  одобрен (1) или не одобрен (0) администратором'
SET  pUseractive=false;-- Пользователь  активен (1) или блокирован (0)'
SET pUserregdate ="";-- Дата и время регистрации пользователя',
SET  pUser_must_change_psw =false; -- При следующем входе пользователь ОБЯЗАН сменить парлоль
SET  pUserAuthResultCode =0; -- Код результата аутентификации пользователя

SELECT `users`.`iduser`,
    `users`.`userlogin`  ,
    `users`.`userpswMD5`,
    `users`.`userEmail`,
    `users`.`userNick`,
    `users`.`userloginapproved`,
    `users`.`useractive`,
    `users`.`userregdate`,
    `users`.`user_must_change_psw`,
    `users`.`userPswSalt`
FROM `doc2016`.`users`
WHERE  userlogin = pUserLogin
INTO  users_iduser ,users_userlogin, users_userpswMD5 , users_userEmail , users_userNick ,
 users_userloginapproved , users_useractive , users_userregdate , users_user_must_change_psw , users_userPswSalt ;

IF (FOUND_ROWS()<>1) THEN SET  pUserAuthResultCode =  -144; LEAVE LUserAuth; END IF; -- Аутентификация пользователя: Данный Login не найден в базе данных.

SET tUserPswSalt = users_userPswSalt;
SET tUserPsw  = concat(pUserPassword,tUserPswSalt);
SET tPswMD5 = md5(tUserPsw);

IF (!(tPswMD5=users_userpswMD5)) THEN SET pUserAuthResultCode = -145; LEAVE LUserAuth; END IF;  -- Аутентификация пользователя: Неправильный пароль.

SET pUserID 				= users_iduser; 				-- ID пользователя
SET pUserEmail 				= users_userEmail; 			-- E-mail пользователя
SET pUserNick 				= users_userNick; 			-- Nick пользователя
SET pIsUserLoginApproved 	= users_userloginapproved; 	-- Login  одобрен (1) или не одобрен (0) администратором
SET pUseractive				= users_useractive;			-- Пользователь  активен (1) или блокирован (0)
SET pUserregdate 			= users_userregdate;			-- Дата и время регистрации пользователя',
SET pUser_must_change_psw 	= users_user_must_change_psw; -- При следующем входе пользователь ОБЯЗАН сменить парлоль

SET  pUserAuthResultCode 	= -146 ; -- Код результата аутентификации пользователя: Успешно аутентифицирован.

IF (pIsUserLoginApproved=false) THEN SET  pUserAuthResultCode = -147; END IF; --  Аутентифицирован, но не одобрен администратором.
IF (pUseractive=false) THEN SET  pUserAuthResultCode = -148; END IF; --  Аутентификация пользователя: Аутентифицирован, но пользователь заблокирован администратором или системой.
IF (pUser_must_change_psw = true) THEN SET  pUserAuthResultCode = -149; END IF; -- Аутентификация пользователя: Аутентифицирован, но пользователь должен сменить пароль.
  
END$$
DELIMITER ;
