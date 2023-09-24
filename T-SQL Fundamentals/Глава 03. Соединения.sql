use TSQL2012
/*
Напишите запрос, который генерирует по пять копий каждой строки из таблицы HR.Employees.
Используются таблицы HR.Employees и dbo.Nums.
*/
select
	empid
	,firstname
	,lastname
	,n
from HR.Employees
	cross join Nums
where n <= 5
------------------------------------------------------------------------------------------------------------------------------------
/*
Напишите запрос, который возвращает по одной строке для каждого сотрудника
и дня в диапазоне с 12 по 16 июня 2009 г.
Используются таблицы HR.Employees и dbo.Nums
*/
select
	empid
	,dateadd(day,n - 1, '20090612') as dt
from HR.Employees
	cross join Nums
where n <= datediff(day, '20090612','20090616') +1
order by empid
------------------------------------------------------------------------------------------------------------------------------------
/*
Запрос должен отобрать всех клиентов из США и вернуть для каждого из них
количество сделанных заказов и общее число заказанных товаров.
Используются таблицы Sales.Customers, Sales.Orders и Sales.OrderDetails.
*/
select
	o.custid
	,count(distinct(o.orderid)) as [Общее количество заказов]
	,sum(od.qty) as [Общее число заказанных товаров]
from Sales.OrderDetails as od
	inner join Sales.Orders as o on od.orderid = o.orderid
	inner join Sales.Customers as c on o.custid = c.custid
where c.country = 'США'
group by o.custid
------------------------------------------------------------------------------------------------------------------------------------
/*
Нужно получить список клиентов с их заказами. В результат должны попасть
даже те клиенты, которые ничего не заказывали.
Используются таблицы Sales.Customers и Sales.Orders.
*/
select
	c.custid
	,c.companyname
	,o.orderid
	,o.orderdate
from Sales.Customers as c
	left join Sales.Orders as o on c.custid = o.custid
------------------------------------------------------------------------------------------------------------------------------------
/*
Запрос должен вернуть всех клиентов, которые не делали заказов.
Используются таблицы Sales.Customers и Sales.Orders.
*/
select
	c.custid
	,c.companyname
from Sales.Customers as c
	left join Sales.Orders as o on c.custid = o.custid
where o.orderid is null
------------------------------------------------------------------------------------------------------------------------------------
/*
Получите список клиентов, которые размещали заказы 12 февраля 2007 г.
В результат должны войти столбцы из таблицы Sales.Orders.
Используются таблицы Sales.Customers и Sales.Orders.
*/
select
	c.custid
	,c.companyname
	,o.orderid
	,o.orderdate
from Sales.Customers as c
	inner join Sales.Orders as o on c.custid = o.custid
where o.orderdate = '20070212'
------------------------------------------------------------------------------------------------------------------------------------
/*
Получите список клиентов, которые размещали заказы 12 февраля 2007 г.
В результат должны войти столбцы из таблицы Sales.Orders и клиенты, у которых
не было заказов в этот день.
Используются таблицы Sales.Customers и Sales.Orders.
*/
select
	c.custid
	,c.companyname
	,o.orderid
	,o.orderdate
from Sales.Customers as c
	left join Sales.Orders as o on c.custid = o.custid
		and o.orderdate = '20070212'
------------------------------------------------------------------------------------------------------------------------------------
/*
Получите список всех клиентов. Результат должен содержать столбец со значе-
ниями «Да/Нет», которые определяются тем, размещал ли клиент заказ 12 февраля
2007 г.
Используются таблицы Sales.Customers и Sales.Orders.
*/
-- 1 вариант
select distinct
	c.custid
	,c.companyname
	,case
		when o.orderdate = '20070212'
			then 'Да'
		else 'Нет'
	end as [размещал ли клиент заказ 12 февраля 2007 г.?]
from Sales.Customers as c
	left join Sales.Orders as o on c.custid = o.custid
order by c.custid

-- 2 вариант
select distinct
	c.custid
	,c.companyname
	,case
		when o.orderid is not null
			then 'Да'
		else 'Нет'
	end as [размещал ли клиент заказ 12 февраля 2007 г.?]
from Sales.Customers as c
	left join Sales.Orders as o on c.custid = o.custid
		and O.orderdate = '20070212'