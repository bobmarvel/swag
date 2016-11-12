DELIMITER $$
CREATE DEFINER=`diana`@`localhost` FUNCTION `UserGetIdUsingLogin`(
pUserLogin varchar (20) -- Login пользователя
) RETURNS int(11)
    COMMENT 'Получить ID пользователя через его Login'
BEGIN 
DECLARE tIdUser int;
-- INSERT INTO ErrorLog 
-- SET
-- ModuleName= 'UserGetIdUsingLogin',
-- ErrorMessage= 'Function started';

 IF (pUserLogin IS NULL)or(pUserLogin="") THEN RETURN -22 ; END IF; -- Поиск UserId: Login не может быть пустым  


 SELECT idUser INTO tIdUser from  users 
 WHERE userlogin = pUserLogin;
 
 IF (FOUND_ROWS()<>1) THEN  RETURN -26; END IF; -- Поиск UserId: Данный Login не найден в базе данных.
--  INSERT INTO ErrorLog 
-- SET
-- ModuleName= 'UserGetIdUsingLogin',
-- ErrorMessage= concat ('theUserId=',cast(tIdUser as CHAR(7)));

RETURN tIdUser ; -- УСПЕШНО - Возвращаем IdUser
 
END$$
DELIMITER ;
