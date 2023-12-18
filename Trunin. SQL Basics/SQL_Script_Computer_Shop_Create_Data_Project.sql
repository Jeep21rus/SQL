/*
	Курс: Основы SQL
	Описание файла: Скрипт создания тестовых данных для итогового проекта.
					Скрипт проверен и точно работает в MySQL, PostgreSQL и Microsoft SQL Server.
	Описание данных: База данных компьютерного магазина. В ней хранится информация о товарах, покупателях и заказах.
	Сайт: https://self-learning.ru
*/

-- Удаление представлений, если они не были удалены ранее
DROP VIEW IF EXISTS sales_products, quantity_sales_products;

-- Удаление таблиц для пересоздания схемы данных
DROP TABLE IF EXISTS orders_products, orders, products, buyers, product_types;

CREATE TABLE buyers(
	buyer_id INT NOT NULL PRIMARY KEY,
	buyer_name VARCHAR(100) NOT NULL,
	birthday DATE NOT NULL
);

CREATE TABLE orders(
	order_id INT NOT NULL PRIMARY KEY,
	buyer_id INT NOT NULL,
	order_number INT NOT NULL,
	order_date DATE NOT NULL,
	order_summa NUMERIC(18, 2) NOT NULL,
 CONSTRAINT fk_buyers FOREIGN KEY(buyer_id) REFERENCES buyers (buyer_id),
 CONSTRAINT uk_number_date UNIQUE (order_number, order_date),
 CONSTRAINT ck_summa CHECK (order_summa > 0)
);

CREATE TABLE product_types(
	type_id INT NOT NULL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

CREATE TABLE products(
	product_id INT NOT NULL PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	description VARCHAR(200) NULL,
	price NUMERIC(18, 2) NULL,
	type_id INT NOT NULL,
 CONSTRAINT fk_product_types FOREIGN KEY (type_id) REFERENCES product_types (type_id)
);
 
CREATE TABLE orders_products(
	order_id INT NOT NULL,
	product_id INT NOT NULL,
 CONSTRAINT pk_orders_products PRIMARY KEY (order_id, product_id),
 CONSTRAINT fk_products FOREIGN KEY (order_id) REFERENCES orders (order_id),
 CONSTRAINT fk_orders FOREIGN KEY(product_id) REFERENCES products (product_id)
);


-- Добавление записей в таблицы
INSERT INTO buyers (buyer_id, buyer_name, birthday)
	VALUES (753, 'Зайцев А.Е.', '1998.04.12'),
		   (832, 'Иванов И.И.', '1993.07.16'),
		   (991, 'Попова Е.В.', '2001.10.28'),
		   (1028, 'John Smith', '2000.05.03'),
		   (1109, 'Сергеев А.С.', '1986.10.12'),
		   (1177, 'Петров С.Л.', '2003.06.11'),
		   (1201, 'Андреев В.А.', '1980.09.27');
		   
INSERT INTO orders (order_id, buyer_id, order_number, order_date, order_summa)
	VALUES (1459, 1201, 151, '2020.04.02', 12750),
		   (1567, 991, 259, '2020.04.17', 6700),
		   (1615, 832, 307, '2020.05.02', 21440),
		   (1646, 1109, 338, '2020.05.07', 15540),
		   (1660, 1201, 352, '2020.05.16', 2100),
		   (1708, 832, 400, '2020.05.21', 6700),
		   (1718, 1028, 410, '2020.05.21', 12300),
		   (1893, 832, 115, '2020.06.11', 4600),
		   (1923, 1109, 85, '2020.06.29', 23990),
		   (1959, 1201, 151, '2020.07.02', 1300),
		   (2052, 832, 244, '2020.07.30', 7900),
		   (2057, 991, 249, '2020.07.30', 16900),
		   (2106, 753, 298, '2020.08.08', 900),
		   (2146, 1201, 338, '2020.08.15', 2200),
		   (2181, 832, 373, '2020.08.23', 16740);

INSERT INTO product_types (type_id, name)
	VALUES (1, 'Физический'),
		   (2, 'Цифровой');

INSERT INTO products (product_id, product_name, description, price, type_id)
	VALUES (16, 'Процессор V5', '4-ядерный процессор, 3600 МГц', 12300, 1),
		   (29, 'Материнская плата R7Q', '2 слота DDR4, 1 слот PCI-E', 4600, 1),
		   (38, 'Клавиатура S939', 'Проводная, интерфейс USB', 1300, 1),
		   (47, 'Мышь N56', 'USB', 900, 1),
		   (60, 'Материнская плата ES20', '4 слота DDR4, 2 слота PCI-E', 6700, 1),
		   (71, 'Принтер 3075', 'Лазерный, 20 стр/мин (A4), USB', 3500, 1),
		   (83, 'Кулер для процессора D17', NULL, 450, 1),
		   (96, 'Процессор V7', '6-ядерный процессор, 3700 МГц', 15540, 1),
		   (108, 'Антивирусная программа', NULL, 1200, 2),
		   (125, 'Операционная система', NULL, 6700, 2);
		   
INSERT INTO orders_products (order_id, product_id)
	VALUES (1459, 16), (1459, 83), (1567, 125), (1615, 29),
		   (1615, 96), (1615, 38), (1646, 96), (1660, 108),
		   (1660, 47), (1708, 60), (1718, 16), (1893, 29),
		   (1923, 60), (1923, 83), (1923, 96), (1923, 38),
		   (1959, 38), (2052, 108), (2052, 125), (2057, 16),
		   (2057, 29), (2106, 47), (2146, 38), (2146, 47),
		   (2181, 108), (2181, 96);
