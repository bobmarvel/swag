DELIMITER $$
create definer = `useravc`@`localhost` FUNCTION `createSalt` () returns char(10) charset utf8
comment 'Fuction of creation salt for password'
begin 
declare baseStr char(50);
declare theSalt varchar(10) default ""; -- defense from bruteforce attack on password
declare i int default 10;
declare j int ;
declare returnSalt char(10);
set baseStr= 'dfwdg2gwdf2r82hg81gfwg2h2qhtgqeghq';

while i>0 do -- floor (i + rand()* (j-1)) для случ числа i<= R < j
set j = Floor (1+ RAND() * 49); -- random from 1 to 50
set theSalt = concat(theSalt, SUBSTRING(baseStr,j,1));
set i=i-1;
end  while;
set returnSalt = theSalt;
RETURN returnSalt;
end $$
DELIMITER ;