#1.1 Показать детали и все изменения их цен.
SELECT detail.id,
		name, code,
		new_price,
        date
FROM detail
INNER JOIN price_changes
ON detail.id = price_changes.id_detail;

#1.2 Показать все покупки у дистрибьюторов (id_покупки и date)
SELECT distributor.id as id_distributor,
		name,
        purchase.id as id_purchase,
        date
FROM distributor
LEFT JOIN purchase
ON distributor.id = purchase.id_distributor;

#1.3 Показать цены ниже, чем у значения цены с id = 3
SELECT a.id, a.id_detail, a.new_price, a.date 
FROM price_changes a, price_changes b
WHERE a.new_price < b.new_price
AND b.id = 3;

#2.1 Вывести таблицу деталей с их первоначальной ценой
SELECT *,
		(SELECT new_price FROM price_changes WHERE detail.id = price_changes.id) as First_price
FROM detail;

#2.2(одно значение) Вывести id_детали и дату максимального значение цены
SELECT *
FROM price_changes 
WHERE new_price = (SELECT MAX(new_price) FROM price_changes);

#2.2.б.(несколько значение) Вывести id_детали и даты изменения цен, которые больше чем средняя цена за весь период
SELECT *
FROM price_changes 
WHERE new_price > (SELECT AVG(new_price) FROM price_changes);


#2.3 вывести все изменения цен на детали
SELECT name, new_price, date
FROM (SELECT name, code, id_detail, new_price, date FROM detail 
		INNER JOIN price_changes ON detail.id = price_changes.id_detail) as T
WHERE date > '2019-01-01';


