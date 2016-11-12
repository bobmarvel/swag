DELIMITER $$
CREATE DEFINER=`diana`@`localhost` FUNCTION `isUserNickExist`( NickToCheck varchar (40) ) RETURNS tinyint(1)
    COMMENT 'Процедура проверки существования в БД указанного Ника'
BEGIN 

DECLARE nickCount int ; -- Количество таких ников в  системе

SELECT COUNT(*) FROM users 
    WHERE users.userNick = NickToCheck INTO nickCount ;
    
IF (nickCount >0)
 THEN RETURN true;
 ELSE RETURN false;
 end if;
 
END$$
DELIMITER ;
