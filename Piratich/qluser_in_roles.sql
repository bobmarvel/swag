CREATE TABLE user_in_roles (
    idusers_in_roles INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ID записи',
    iduser INT(11) NOT NULL ,
    id_role INT(11) DEFAULT NULL ,
    PRIMARY KEY (`idusers_in_roles`)
)  ENGINE=INNODB AUTO_INCREMENT=2 DEFAULT CHARSET=UTF8 COMMENT='Принадлежность пользователей ролям';