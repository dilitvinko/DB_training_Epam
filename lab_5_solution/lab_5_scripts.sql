# 1. Выборка всех изменений цен деталей
CREATE VIEW details_prices
AS SELECT detail.id, name, code, new_price, date
FROM detail
JOIN price_changes ON detail.id = price_changes.id_detail;

# Достать из выборки все детали ценой выше 100
SELECT *
FROM details_prices
WHERE new_price > 100;

# 2.1 Триггер, который обновляет сумму деталей в таблице amount_of_detail_in_order,
# при добавлении новых заказов в таблицу order, количество берется из count в таблице order

DELIMITER $$
CREATE TRIGGER `trigger_1_1` AFTER INSERT ON `order`
    FOR EACH ROW BEGIN        
        UPDATE amount_of_detail_in_order
		SET amount_of_all_detail = (SELECT SUM(`order`.`count`) FROM `order`)
		WHERE id = 1;
    END;
$$

#2)	Создайте триггер(ы), фиксирующий дату-время и автора изменений данных в таблице. 
DELIMITER $$
CREATE TRIGGER `trigger_1_2` AFTER INSERT ON `order`
    FOR EACH ROW BEGIN        
        INSERT INTO `user_sessions_changes` (`name`, `times`) VALUES (CURRENT_USER, CURRENT_TIMESTAMP());
    END;
$$

INSERT INTO `order` (`count`, `id_detail`, `id_price_changes`, `id_purchase`) VALUES ('2', '5', '5', '1');
INSERT INTO `order` (`count`, `id_detail`, `id_price_changes`, `id_purchase`) VALUES ('5', '3', '3', '1');
INSERT INTO `order` (`count`, `id_detail`, `id_price_changes`, `id_purchase`) VALUES ('7', '2', '2', '2');

# 3.1) хранимая процедура, которая возращает деталь и код из выброннаго промежутка цен
DELIMITER //
CREATE PROCEDURE info_price_of_detail (price_1 double, price_2 double)
BEGIN
    SELECT name, code, new_price, date
    FROM detail
    JOIN price_changes ON detail.id = price_changes.id_detail
    WHERE new_price BETWEEN price_1 and price_2 ;
END //
DELIMITER ; 

# вызов процедуры
CALL info_price_of_detail (30, 100);

#4.1)	Создайте хранимую функцию, которая вычисляет кол-во дней до конца года по заданной дате.
CREATE FUNCTiON func_4_1 ( d Date ) RETURNS int
RETURN (365 - DAYOFYEAR(d));

#4.2) Вызов хранимой функции
SELECT func_4_1 ("2018-11-29");





