DELIMITER $$
CREATE DEFINER=`diana`@`localhost` FUNCTION `mapIdUserToIdRole`(
pIdUser int,
pIdRole int
) RETURNS int(11)
    COMMENT 'Связать по ID пользователя с ролью'
BEGIN 
DECLARE tRoleCount int;
DECLARE tUserCount int;
DECLARE tLinksOfUserRoleCount int;

SELECT  Count(*) INTO tRoleCount  FROM roles WHERE idrole = pIdRole;

IF (tRoleCount <>1) THEN RETURN -140 ; END IF; -- Создание связи пользователь - роль: Роль не найдена.

SELECT  Count(*) INTO tUserCount  FROM users WHERE iduser = pIdUser;

IF (tUserCount <>1) THEN RETURN -141 ; END IF; -- Создание связи пользователь - роль: Пользователь не найден.

SELECT Count(*) INTO tLinksOfUserRoleCount FROM users_in_roles WHERE ((iduser = pIdUser) and(id_role = pIdRole));
IF (tLinksOfUserRoleCount = 1) THEN RETURN -143 ; END IF; -- Создание связи пользователь - роль: Ошибка.Такая связь уже существует..


INSERT INTO   users_in_roles SET 
iduser = pIdUser,
id_role = pIdRole;
 
 
  IF (ROW_COUNT()<1) THEN  RETURN -142; END IF; -- Ошибка при создании связи.
  
RETURN 0 ; -- УСПЕШНО 
END$$
DELIMITER ;
