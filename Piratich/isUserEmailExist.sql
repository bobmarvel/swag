DELIMITER $$
CREATE DEFINER=`diana`@`localhost` FUNCTION `isUserEmailExist`( EmailToCheck varchar (40) ) RETURNS tinyint(1)
    COMMENT 'Процедура проверки существования в БД указанного E-mail-а'
BEGIN 

DECLARE emailCount int ; -- Количество таких E-mail-ов в  системе

SELECT COUNT(*) FROM users 
    WHERE users.userEmail = EmailToCheck INTO emailCount ;
    
IF (emailCount >0)
 THEN RETURN true;
 ELSE RETURN false;
 end if;
 
END$$
DELIMITER ;
