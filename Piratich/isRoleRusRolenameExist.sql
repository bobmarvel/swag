DELIMITER $$
CREATE DEFINER=`useravc`@`localhost` FUNCTION `isRoleRusRolenameExist`( RusRolenameToCheck varchar (45) ) RETURNS tinyint(1)
    COMMENT 'Процедура проверки существования указанной роли на русском языке'
BEGIN 

DECLARE RusRolenameCount int ; -- Количество таких Rolename 

SELECT COUNT(*) FROM roles 
    WHERE roles.rusrolename = RusRolenameToCheck INTO RusRolenameCount ;
    
IF (RusRolenameCount >0)
 THEN RETURN true;
 ELSE RETURN false;
 end if;
 
END$$
DELIMITER ;
