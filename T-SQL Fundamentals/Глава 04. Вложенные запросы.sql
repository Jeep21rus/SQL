/*
Напишите запрос, который возвращает все заказы, сделанные в последний день,
учтенный в таблице Orders.
 Используется таблица Sales.Orders.
*/
-- С сортировкой
select
	orderid
	,orderdate
	,custid
	,empid
from Sales.Orders
where orderdate = (
	select orderdate
	from Sales.Orders
	order by orderdate desc
	offset 0 rows fetch next 1 row only)

-- С агрегатной функцией
select
	orderid
	,orderdate
	,custid
	,empid
from Sales.Orders
where orderdate = (
	select max(orderdate)
	from Sales.Orders)
----------------------------------------------------------------------------------------------------------------------------------------
/*
Напишите запрос, который будет возвращать все заказы, размещенные клиен-
том (или клиентами) с самым большим количеством заказов. Учитывайте вероят-
ность того, что одно и то же количество заказов может быть сразу у нескольких
клиентов.
Используется таблица Sales.Orders.
*/
select
	custid
	,orderid
	,orderdate
	,empid
from Sales.Orders
where custid in (
	select q1.custid
	from (
		select top (1) with ties
			custid
			,count(*) as qty
		from Sales.Orders
		group by custid
		order by qty desc) as q1)
----------------------------------------------------------------------------------------------------------------------------------------
/*
Напишите запрос, который возвращает список сотрудников, не обрабатывавших
заказы c 1 мая 2008 г.
Используются таблицы HR.Employees и Sales.Orders.
*/
select
	e.empid
	,e.firstname
	,e.lastname
from HR.Employees as e
where e.empid not in (
	select o.empid
	from Sales.Orders as o
	where o.orderdate >= '20080501')
----------------------------------------------------------------------------------------------------------------------------------------
/*
Получите список стран, в которых есть клиенты, но нет сотрудников.
 Используются таблицы HR.Employees и Sales.Customers.
*/
select distinct c.country
from Sales.Customers as c
where not exists(
	select *
	from HR.Employees as e
	where c.country = e.country)
----------------------------------------------------------------------------------------------------------------------------------------
/*
Напишите запрос, который возвращает все заказы, размещенные в последний
день активности каждого клиента.
 Используется таблица Sales.Orders.
*/
select
	custid
	,orderid
	,orderdate
	,empid
from Sales.Orders as o1
where orderdate = (
	select max(o2.orderdate)
	from Sales.Orders as o2
	where o2.custid = o1.custid)
order by custid
----------------------------------------------------------------------------------------------------------------------------------------
/*
Напишите запрос, который возвращает список клиентов, размещавших заказы
в 2007-м, но не в 2008 г.
 Используются таблицы Sales.Orders и Sales.Customers.
*/
-- Через подзапрос
select distinct
	c.custid
	,c.companyname
from Sales.Customers as c
	inner join Sales.Orders as o on c.custid = o.custid
		and year(orderdate) = 2007
		and c.custid not in( 
			select distinct	c.custid
			from Sales.Customers as c
				inner join Sales.Orders as o on c.custid = o.custid
					and year(orderdate) = 2008)

-- Через except
select distinct
	c.custid
	,c.companyname
from Sales.Customers as c
	inner join Sales.Orders as o on c.custid = o.custid
where year(orderdate) = 2007

except

select distinct
	c.custid
	,c.companyname
from Sales.Customers as c
	inner join Sales.Orders as o on c.custid = o.custid
where year(orderdate) = 2008
----------------------------------------------------------------------------------------------------------------------------------------
/*
Напишите запрос, который возвращает список клиентов, заказывавших товар
под номером 12.
Используются таблицы Sales.Orders, Sales.Customers и Sales.OrderDetails.
*/
-- Через in
select
	c.custid
	,c.companyname
from Sales.Customers as c
where c.custid in(
	select o.custid
	from Sales.Orders as o
	where o.orderid in(
		select od.orderid
		from Sales.OrderDetails as od
		where productid = 12))

-- Через exists
select
	custid
	,companyname
from Sales.Customers as c
where exists (
	select *
	from Sales.Orders as o
	where o.custid = c.custid
		and exists (
			select *
			from Sales.OrderDetails as od
			where od.orderid = o.orderid
				and od.ProductID = 12))
----------------------------------------------------------------------------------------------------------------------------------------
/*
Напишите запрос, который вычисляет общее текущее количество заказанного
товара для каждого клиента за каждый месяц.
Используется таблица Sales.CustOrders.
*/
select
	custid
	,ordermonth
	,qty
	,(select sum(O2.qty)
	from Sales.CustOrders as o2
	where o2.custid = o1.custid
		and O2.ordermonth <= O1.ordermonth) as runqty
from Sales.CustOrders as o1
order by custid, ordermonth