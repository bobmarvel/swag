DELIMITER $$
CREATE DEFINER=`useravc`@`localhost` FUNCTION `ErrorGetErrorMessage`(
pErrorCode INT, -- Код ошибки
pErrorMessageLang varchar(10) -- Язык сообщения
) RETURNS varchar(2048) CHARSET cp1251
    COMMENT 'Получить  текст сообщения обошибке по ID ошибки'
BEGIN 
DECLARE tErrorMessage varchar (2048) ;-- Текст сообщения


IF (pErrorCode IS NULL)or(pErrorCode>0 ) THEN RETURN "Неверный код ошибки. Сообщение об ошибке не найдено." ; END IF; -- Код ошибки не может быть положительным
IF (pErrorMessageLang IS NULL)or(pErrorMessageLang="" ) THEN SET pErrorMessageLang ='ru-ru' ; END IF; -- Язык сообщения по умолчанию - Русский


SELECT ErrorMessage  from  Errors
 WHERE ((ErrorCode = pErrorCode) AND (ErrorMessageLang = pErrorMessageLang))
 INTO tErrorMessage;
 
 IF (FOUND_ROWS()=1) 
   THEN  RETURN tErrorMessage;  -- Возврат сообщения с текстом ошибки
	ELSE BEGIN
		SELECT ErrorMessage  from  Errors
			WHERE ((ErrorCode = pErrorCode) AND (ErrorMessageLang = 'ru-ru'))
			INTO tErrorMessage;
			IF (FOUND_ROWS()=1) 
             THEN  RETURN tErrorMessage;  -- Возврат сообщения с текстом ошибки на языке по умолчанию (РУССКИЙ)
             ELSE RETURN "Неверный код ошибки. Сообщение об ошибке не найдено." ; 
			END IF;
        END;

 END IF;
 
END$$
DELIMITER ;