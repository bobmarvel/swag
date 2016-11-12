DELIMITER $$
CREATE DEFINER=`diana`@`localhost` FUNCTION `RoleCreateNewRole`(
pRoleName varchar (45),
pRusRoleName varchar (45)
) RETURNS int(11)
    COMMENT 'Создать новую роль'
BEGIN 
DECLARE tIdRole int;


IF ((pRoleName IS NULL)or(pRoleName="")) THEN RETURN -31 ; END IF; -- Создание роли: Наименование роли не может быть пустым.
IF ((pRusRoleName IS NULL)or(pRusRoleName="")) THEN RETURN -34 ; END IF; -- Наименование роли на русском языке не может быть пустым.

IF (isRoleRolenameExist(pRoleName)) THEN RETURN -32 ; END IF; -- Создание роли: Нельзя создать роль. Роль с таким наименованием уже существует.
IF (isRoleRusRolenameExist(pRusRoleName)) THEN RETURN -35 ; END IF; -- Нельзя создать роль. Роль с таким наименованием на русском языке уже существует.

INSERT INTO   roles SET rolename = pRoleName, rusrolename = pRusRoleName ;
 
 
  IF (ROW_COUNT()<1) THEN  RETURN -33; END IF; -- Ошибка при создании роли.
  SET tIdRole  = LAST_INSERT_ID();
RETURN tIdRole ; -- УСПЕШНО - Возвращаем tIdRole
 
END$$errors
DELIMITER ;
