CREATE TABLE `rolesroles` (
    `idrole` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ID роли',
    `rolename` VARCHAR(45) NOT NULL COMMENT 'Наименование роли',
    `rusrolename` VARCHAR(45) NOT NULL COMMENT 'Русское наименование роли',
    PRIMARY KEY (`idrole`),
    UNIQUE KEY `rolename_UNIQUE` (`rolename`),
    UNIQUE KEY `rusrolename_UNIQUE` (`rusrolename`)
)  ENGINE=INNODB AUTO_INCREMENT=9 DEFAULT CHARSET=UTF8 COMMENT='Роли пользователей';