DELIMITER $$
CREATE DEFINER=`diana`@`localhost` FUNCTION `RoleGetIdRoleUsingRoleName`(
pRoleName varchar (45) -- имя роли
) RETURNS int(11)
    COMMENT 'Получить ID роли по имени роли'
BEGIN 
DECLARE tIdRole int;


IF (pRoleName IS NULL)or(pRoleName="") THEN RETURN -29 ; END IF; -- Поиск IdRole: Наименование роли не может быть пустым.

SELECT idrole INTO tIdRole from  roles 
 WHERE rolename = pRoleName;
 
 IF (FOUND_ROWS()<>1) THEN  RETURN -30; END IF; -- Поиск IdRole: Искомая роль не найдена в базе данных.

RETURN tIdRole ; -- УСПЕШНО - Возвращаем IdRole
 
END$$
DELIMITER ;
