/*
В процессе эксплуатации информационной системы возникла необходимость хранить информацию о поставщиках товара.
В связи с этим Вам необходимо внести изменения в схему данных базы данных, в частности требуется создать таблицу для хранения поставщиков.
Таблицу назовите vendors, она должна хранить информацию о наименовании поставщика, при этом у нее должен быть
целочисленный первичный ключ с автоинкрементом.
Поставщиков без наименования быть не может, поэтому, чтобы обезопасить себя от такой аномалии, задайте соответствующее
свойство при создании таблицы.
Напишите инструкцию создания таблицы vendors.
*/
drop table if exists vendors
go

create table vendors 
(
	id int not null identity (1, 1),
	vendor_name varchar(100) not null,
	constraint pk_vendors primary key (id)
)
go

/*
Добавьте в таблицу vendors следующих поставщиков:
ООО «Компьютер»
ИП Попов В.А.
АО «Intelligence»
ООО «Дом софта»
SoftPic Inc.
Напишите инструкцию добавления соответствующих записей.
*/
insert into vendors (vendor_name)
values
	('ООО «Компьютер»'),
	('ИП Попов В.А.'),
	('АО «Intelligence»'),
	('ООО «Дом софта»'),
	('SoftPic Inc.')
go

/*
У каждого товара может быть только один поставщик. Чтобы реализовать связь, необходимо в таблицу с товарами добавить один столбец,
который будет ссылаться на поставщика данного товара.
Добавьте в таблицу с товарами столбец для хранения идентификатора поставщика.
Напишите соответствующую инструкцию.
*/
alter table products
	add vendor_id int null
go

/*
Чтобы актуализировать текущие данные, необходимо заполнить информацию о поставщиках по существующим товарам.
Проставьте ссылку на поставщика для каждого товара в соответствии со следующей информацией:
Наименование товара	Поставщик товара
Процессор V5	ООО «Компьютер»
Материнская плата R7Q	АО «Intelligence»
Клавиатура S939	ООО «Компьютер»
Мышь N56	ИП Попов В.А.
Материнская плата ES20	ООО «Компьютер»
Принтер 3075	ИП Попов В.А.
Кулер для процессора D17	АО «Intelligence»
Процессор V7	АО «Intelligence»
Антивирусная программа	ООО «Дом софта»
Операционная система	SoftPic Inc.
Напишите инструкции для обновления таблицы с товарами.
*/
update products
set vendor_id = (
	select id
	from vendors
	where vendor_name = (
		case product_name
			when 'Процессор V5'
				then 'ООО «Компьютер»'
			when 'Материнская плата R7Q'
				then 'АО «Intelligence»'
			when 'Клавиатура S939'
				then 'ООО «Компьютер»'
			when 'Мышь N56'
				then 'ИП Попов В.А.'
			when 'Материнская плата ES20'
				then 'ООО «Компьютер»'
			when 'Принтер 3075'
				then 'ИП Попов В.А.'
			when 'Кулер для процессора D17'
				then 'АО «Intelligence»'
			when 'Процессор V7'
				then 'АО «Intelligence»'
			when 'Антивирусная программа'
				then 'ООО «Дом софта»'
			when 'Операционная система'
				then 'SoftPic Inc.'
		end))
go
select * from products
go

/*
У товара обязательно должна быть заполнена информация о поставщике, товаров без поставщика быть не может,
поэтому добавьте соответствующее ограничение в таблицу с товарами.
Напишите соответствующую инструкцию.
*/
alter table products
	alter column vendor_id int not null
go

/*
Чтобы физически реализовать связь между таблицей с товарами и таблицей с поставщиками, добавьте ограничение внешнего ключа
в таблицу с товарами.
Напишите соответствующую инструкцию.
*/
alter table products
	add constraint fk_vendors foreign key (vendor_id) references vendors (id)
go

/*
Напишите проверочный запрос, который покажет наименование товара и наименование соответствующего поставщика.
Отсортируйте данные по идентификатору товара.
*/
select
	p.product_name,
	v.vendor_name
from products as p
	inner join vendors as v on v.id = p.vendor_id
order by p.product_id
go

/*
Разработайте представление, которое будет показывать количество проданных товаров каждого поставщика.
Представление назовите vendor_quantity_sales.
Представление должно возвращать следующие данные:
Идентификатор поставщика
Наименование поставщика
Количество проданных товаров
*/
create or alter view vendor_quantity_sales 
as
	select
		v.id as vendor_id,
		v.vendor_name,
		count(op.order_id) as quantity_sales
	from vendors as v
		inner join products as p on p.vendor_id = v.id
		inner join orders_products as op on op.product_id = p.product_id
	group by
		v.id,
		v.vendor_name
go

/*
Разработайте представление, которое будет показывать детализацию заказа в части включенных в заказ товаров.
Представление назовите product_in_order.
Представление должно возвращать следующие данные:
Идентификатор заказа
Наименовании товара
Описание товара
Стоимость товара
Тип товара
Поставщик товара
*/
create or alter view product_in_order
as
	select
		op.order_id,
		p.product_name,
		coalesce(p.description, 'Нет описания') as description,
		p.price,
		pt.name,
		v.vendor_name
	from orders_products as op
		inner join products as p on p.product_id = op.product_id
		inner join product_types as pt on pt.type_id = p.type_id
		inner join vendors as v on v.id = p.vendor_id
go

/*
Разработайте представление, которое будет показывать детали заказа, включая количество товаров, входящих в заказ.
Представление назовите order_details.
Представление должно возвращать следующие данные:
Идентификатор заказа
Номер заказа
Дата заказа
Сумма заказа
Количество товаров
*/
create or alter view product_in_order
(order_id, order_number, order_date, order_summa, quantity_products)
as
	select
		o.order_id,
		o.order_number,
		o.order_date,
		o.order_summa,
		count(op.product_id) as quantity_products
	from orders as o
		inner join orders_products as op on op.order_id = o.order_id
	group by
			o.order_id,
			o.order_number,
			o.order_date,
			o.order_summa
go

/*
Разработайте представление, которое будет выявлять одинаковые номера заказов и выводить детализированные данные таких заказов.
Представление назовите orders_same_numbers.
Представление должно возвращать следующие данные:
Идентификатор заказа
Номер заказа
Дата заказа
Сумма заказа
*/
create or alter view orders_same_numbers
(order_id, order_number, order_date, order_summa)
as
	select distinct
		o.order_id,
		o.order_number,
		o.order_date,
		o.order_summa
	from orders as o
	where o.order_number in (
		select o.order_number
		from orders as o
		group by o.order_number
		having count(*) > 1)
go