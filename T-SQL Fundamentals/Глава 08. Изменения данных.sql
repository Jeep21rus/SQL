/*
Добавьте в таблицу dbo.Customers строку со следующими значениями:
 custid: 100
 companyname: Рога и копыта
 country: США
 region: WA
 city: Редмонд
*/
insert into dbo.Customers (custid, companyname, country, region, city)
	values 
	(100, 'Рога и копыта', 'США', 'WA', 'Рэдмонд')
----------------------------------------------------------------------------------------------------------------------------------------
/*
Выберите из таблицы Sales.Customers записи о всех клиентах, которые размещали
заказы, и скопируйте их в таблицу dbo.Customers.
*/
-- Через join
insert into dbo.Customers
	select distinct 
		c.custid
		,c.companyname
		,c.country
		,c.region
		,c.city
		from Sales.Customers as c
			inner join Sales.Orders as o on c.custid = o.custid

-- Через exists
insert into dbo.Customers (custid, companyname, country, region, city)
	select
		c.custid
		,c.companyname
		,c.country
		,c.region
		,c.city
	from Sales.Customers as c
	where exists (
		select *
		from Sales.Orders as o
		where o.custid = c.custid)
----------------------------------------------------------------------------------------------------------------------------------------
/*
С помощью команды SELECT INTO создайте таблицу dbo.Orders и заполните ее
заказами из таблицы Sales.Orders, которые были размещены в 2006–2008 гг. Стоит
отметить, что это упражнение можно выполнить только на локальной версии SQL
Server, поскольку SQL Database не поддерживает команду SELECT INTO (вместо
этого используются команды CREATE TABLE и INSERT SELECT).
*/
select *
into dbo.Orders
from Sales.Orders
where year(orderdate) between 2006 and 2008;
----------------------------------------------------------------------------------------------------------------------------------------
/*
Удалите из таблицы dbo.Orders заказы, размещенные до августа 2006 г. Исполь-
зуйте инструкцию OUTPUT, чтобы вернуть атрибуты orderid и orderdate, при-
надлежащие удаленным строкам.
*/
delete from dbo.Orders
output
	deleted.orderid as deleted_orderid
	,deleted.orderdate as deleted_orderdate
where orderdate < '20060801';
----------------------------------------------------------------------------------------------------------------------------------------
-- Удалите из таблицы dbo.Orders заказы, размещенные бразильскими клиентами.
-- Через exists
delete from o
from dbo.Orders as o
where exists (
	select *
	from dbo.Customers as c
	where o.custid = c.custid
		and c.country = N'Бразилия')

-- Через join
delete from o
from dbo.Orders as o
	inner join dbo.Customers as c on o.custid = c.custid
where c.country = 'Бразилия'
----------------------------------------------------------------------------------------------------------------------------------------
/*
Выполните запрос к таблице dbo.Customers, представленный ниже. Обратите
внимание, что некоторые строки содержат NULL в столбце region.
SELECT * FROM dbo.Customers;
Теперь обновите таблицу dbo.Customers, заменяя отметки NULL значениями
'<None>'. Используйте инструкцию OUTPUT, чтобы вывести содержимое столбцов custid, oldregion и newregion.
*/
update dbo.Customers
	set region = '<None>'
output
	inserted.custid
	,deleted.region as oldregion
	,inserted.region as newregion
where region is null;
----------------------------------------------------------------------------------------------------------------------------------------
/*
Обновите в таблице dbo.Orders все заказы, которые были размещены клиен-
тами из Великобритании; присвойте их атрибутам shipcountry, shipregion
и shipcity значения country, region и city, взятые из таблицы dbo.Customers.
*/
-- Через update
update o
set 
	shipcountry = c.country
	,shipregion = c.region
	,shipcity = c.city
from dbo.Orders as O
	inner join dbo.Customers as c on o.custid = c.custid
where c.country = 'Великобритания'

-- Через merge
merge into dbo.Orders as o
using dbo.Customers as c
	on o.custid = c.custid
		and c.country = 'Великобритания'
when matched then
update set
	shipcountry = c.country
	,shipregion = c.region
	,shipcity = c.city;