/*
Выбрать в таблице Orders заказы, которые были доставлены до 1января 1997 года (колонка ShippedDate),
и которые доставлены с ShipVia >= 3. Формат указания даты должен быть верным при любых региональных настройках.
Запрос должен высвечивать только колонки OrderID, ShippedDate и ShipVia. 
*/
select
	OrderID
	,ShippedDate
	,ShipVia
from Orders
where ShippedDate < convert(datetime, '19970101', 112)
	and ShipVia >= 3
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести всю информацию по заказам из крупных городов (не регионов).
select
	OrderID
	,CustomerID
	,EmployeeID
	,OrderDate
	,RequiredDate
	,ShippedDate
	,ShipVia
	,Freight
	,ShipName
	,ShipAddress
	,ShipCity
	,ShipRegion
	,ShipPostalCode
	,ShipCountry
from Orders
where ShipRegion is null
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Выбрать из таблицы Employees имена и фамилии всех сотрудников младше 70-ти  лет. 
Напротив имени каждого сотрудника в колонке с названием “Age” вывести его возраст.
*/
select
	FirstName
	,LastName
	,case
		when month(BirthDate) > month(getdate())
			or month(BirthDate) = month(getdate())
			and day(BirthDate) > day(getdate())
				then datediff(year, BirthDate, getdate()) - 1
		else datediff(year, BirthDate, getdate())
	end as Age
from Employees
where 
	case
		when month(BirthDate) > month(getdate())
			or month(BirthDate) = month(getdate())
			and day(BirthDate) > day(getdate())
				then datediff(year, BirthDate, getdate()) - 1
		else datediff(year, BirthDate, getdate()) 
	end < 70
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Написать запрос, который выводит только компании без факса из таблицы Suppliers.
В результатах запроса высвечивать для колонки Fax вместо значений NULL
строку ‘No fax’ – использовать системную функцию CASЕ. Запрос должен высвечивать только колонки CompanyName и Fax.
*/
select
	CompanyName
	,case
		when Fax is null
			then 'No fax'
		else Fax
	end as Fax
from Suppliers
where Fax is null
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Выбрать в таблице Orders заказы, которые были доставлены до 6 мая 1998 года (ShippedDate) не включая эту дату или которые еще не доставлены.
В запросе должны высвечиваться только колонки OrderID (переименовать в Order Number) и ShippedDate (переименовать в Shipped Date). 
В результатах запроса высвечивать для колонки ShippedDate вместо значений NULL строку ‘Not Shipped’, 
для остальных значений высвечивать дату в формате по умолчанию.
*/
-- Case
select
	OrderID as [Order Number]
	,case
		when ShippedDate is null
			then 'Not Shipped'
		else convert(char(10), ShippedDate, 102)
	end as [Shipped Date]
from Orders
where ShippedDate < convert(datetime, '19980506', 112)
	or ShippedDate is null

-- Iif
select
	OrderID as [Order Number]
	,iif(ShippedDate is null, 'Not Shipped', convert(char(10), ShippedDate, 102)) as [Shipped Date]
from Orders
where ShippedDate < convert(datetime, '19980506', 112)
	or ShippedDate is null
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Вывести заказы, доставленные до 5 мая 2007 года. 
Выводить только OrderID и дату доставки его. Дату выводить в формате мес дд гггг чч:мм AM (или PM). Использовать функцию CAST.
*/
select
	OrderID
	,cast(ShippedDate as varchar(20)) as ShippedDate
from Orders
where ShippedDate < convert(datetime, '20070505', 112)
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Вывести заказы, доставленные до 5 мая 2007 года. Выводить только OrderID и дату доставки его. Дату выводить в формате мм/дд/гггг.
Использовать функцию CONVERT.
*/
select
	OrderID
	,convert(char,ShippedDate, 101) as ShippedDate
from Orders
where ShippedDate < convert(datetime, '20070505', 112)
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Выбрать всех сотрудников, проживающих в Лондоне и Сиэтле. Запрос сделать с только помощью оператора IN. 
Высвечивать колонки с именем, фамилией пользователя и названием города в результатах запроса. 
Упорядочить результаты запроса по фамилии сотрудников.
*/
select
	FirstName
	,LastName
	,City
from Employees
where City in ('London', 'Seattle')
order by LastName
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Выбрать из таблицы Employees всех сотрудников, не проживающих в Лондоне и Сиэтле. Запрос сделать с помощью оператора IN. 
Высвечивать колонки с именем, фамилией пользователя и названием города в результатах запроса. 
Упорядочить результаты запроса по фамилии сотрудников.
*/
select
	FirstName
	,LastName
	,City
from Employees
where City not in ('London', 'Seattle')
order by LastName
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Выбрать из таблицы Customers все ContactTitle, которые в ней встречаются.
Каждый ContactTitle должен быть упомянут только один раз и список отсортирован по возрастанию.
Не использовать предложение GROUP BY. Высвечивать только одну колонку в результатах запроса. 
*/
select distinct ContactTitle
from Customers
order by ContactTitle
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести из таблицы Shippers поля CompanyName и ShipperID. Результаты запроса упорядочить по обоим полям в порядке, который указан.
select
	CompanyName
	,ShipperID
from Shippers
order by CompanyName, ShipperID
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Это задание необходимо выполнить 2-мя способами. Выбрать все заказы (OrderID) из таблицы Order Details (заказы не должны повторяться), 
где встречаются продукты с количеством от 1 до 6 не включая 1 и 6 – это колонка Quantity в таблице Order Details. 
Использовать оператор BETWEEN. Запрос должен высвечивать только колонку OrderID. 
*/
-- Between + <>
select distinct OrderID
from [Order Details]
where Quantity between 1 and 6
	and Quantity <> 1
	and Quantity <> 6

-- Between + not between
select distinct OrderID
from [Order Details]
where Quantity between 1 and 6
	and Quantity not between 0 and 1
	and Quantity not between 6 and 7

-- Between + not in
select distinct OrderID
from [Order Details]
where Quantity between 1 and 6
	and Quantity not in (1, 6)
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Выбрать всех заказчиков из таблицы Customers, у которых вторая буква названия страны из диапазона o и r. 
Использовать оператор BETWEEN. Запрос должен высвечивать только колонки CustomerID и Country и отсортирован по Country.
*/
select
	CustomerID
	,Country
from Customers
where substring(Country, 2, 1) between 'o' and 'r'
order by Country
-----------------------------------------------------------------------------------------------------------------------------------------
-- Выбрать всех заказчиков из таблицы Customers, у которых вторая буква названия страны из диапазона o и r, не используя оператор BETWEEN.
select
	CustomerID
	,Country
from Customers
where substring(Country, 2, 1) >= 'o'
	and substring(Country, 2, 1) <=  'r'
-----------------------------------------------------------------------------------------------------------------------------------------
-- Выбрать из таблицы  поставщиков все компании, названия которых начинаются на “L”.
select CompanyName
from Suppliers
where CompanyName like 'l%'

-- В таблице Products найти все продукты (колонка ProductName), где встречается двойное t ('tt').
select ProductName
from Products
where ProductName like '%tt%'
-----------------------------------------------------------------------------------------------------------------------------------------
-- Необходимо вывести всю информацию о сотруднике(таблица Employees), чья фамилия точно не известна (Davolio или Diavolo).
select *
from Employees
where LastName like 'd%avol%o'

-- Найти кол-во заказов со скидкой меньше 30%.
select count(*) as Count
from [Order Details]
where Discount < 0.3
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Найти общую сумму всех заказов из таблицы Order Details с учетом количества закупленных товаров и скидок по ним и вычесть из нее заказы, 
в которых скидка меньше 15 процентов. Результат округлить до сотых. 
Скидка (колонка Discount) составляет процент из стоимости для данного товара. 
Для определения действительной цены на проданный продукт надо вычесть скидку из указанной в колонке UnitPrice цены. 
Результатом запроса должна быть одна запись с одной колонкой с названием колонки 'Totals'.
*/
select round(sum((UnitPrice - UnitPrice * Discount) * Quantity), 2) as Totals
from [Order Details]
where Discount >= 0.15
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Найти разницу между максимальным и минимальным из всех заказов из таблицы Order Details с учетом количества закупленных товаров и скидок по ним.
Результат округлить до сотых. 
*/
select round(max((UnitPrice - UnitPrice * Discount) * Quantity) - min((UnitPrice - UnitPrice * Discount) * Quantity), 2) as Totals
from [Order Details]
group by OrderID
-----------------------------------------------------------------------------------------------------------------------------------------
-- Найти среднее кол-во продуктов в заказах.
select avg(Quantity) as AVG_Quantity
from [Order Details]
group by OrderID
-----------------------------------------------------------------------------------------------------------------------------------------
/*
По таблице Orders найти количество заказов, которые уже доставлены (т.е. в колонке ShippedDate есть значение  даты доставки). 
Использовать при этом запросе только оператор COUNT. Не использовать предложения WHERE и GROUP
*/
select count(ShippedDate)
from Orders
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Задание 6.13.
По таблице Customers найти количество различных городов, в которых расположены заказчики. 
Использовать функцию COUNT и не использовать предложения WHERE и GROUP.
*/
select count(distinct City) as CountUniqueCity
from Customers
-----------------------------------------------------------------------------------------------------------------------------------------
/*
По таблице Orders найти количество заказов с группировкой по заказчикам. 
В результатах запроса надо высвечивать две колонки c названиями Customer и Total. 
Написать проверочный запрос, который вычисляет количество всех заказов.
*/
-- Query
select
	CustomerID as Customer
	,count(*) as Total
from Orders
group by CustomerID

-- Check
select count(*) as CountOrders
from Orders
-----------------------------------------------------------------------------------------------------------------------------------------
/*
По таблице Orders найти количество заказов, сделанных каждым заказчиком. Заказ указанного заказчика – это любая запись в таблице Orders, 
где в колонке CustomerID задано значение для данного заказчика. В результатах запроса надо высвечивать колонку с названием компании заказчика
(основной запрос должен использовать группировку по CustomerID), с названием колонки ‘Customer’ и колонку c количеством заказов
высвечивать с названием 'Amount'. Результаты запроса должны быть упорядочены по убыванию количества заказов.
*/
select
	(select c.CompanyName
	from Customers as c
	where c.CustomerID = o.CustomerID) as Customer
	,count(o.OrderID) as Amount
from Orders as o
group by CustomerID
order by Amount desc
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Найти покупателей и продавцов, которые живут в одной стране. Если в стране живут только один или несколько продавцов или только один 
или несколько покупателей, то информация о таких покупателя и продавцах не должна попадать в результирующий набор. 
Т.е. если в стране живут только продавцы или только покупатели, то эти данные не выводятся.  Не использовать конструкцию JOIN. 
В результатах запроса необходимо вывести следующие заголовки для результатов запроса: ‘Person’, ‘Type’ (здесь надо выводить строку ‘Customer’ 
или  ‘Seller’ в завимости от типа записи), ‘Country’. Отсортировать результаты запроса по колонке ‘Country’ и по ‘Person’.
*/
select
	concat(FirstName, ' ', LastName) as Person
	,'Seller' as Type
	,Country
from Employees
where Country in (
	select Country
	from Customers)

union

select
	ContactName as Person
	,'Customer' as Type
	,Country
from Customers
where Country in (
	select Country
	from Employees)
order by Country, Person
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Найти всех поставщиков, которые расположены  в одной стране. В запросе использовать соединение таблицы Suppliers c собой - самосоединение. 
Высветить колонки SupplierID и Country. Запрос не должен высвечивать дублируемые записи. Для проверки написать запрос, который высвечивает страны, 
которые встречаются более одного раза в таблице Suppliers. 
Это позволит проверить правильность запроса.
*/
-- Query
select
	t1.SupplierID
	,t1.Country
from Suppliers as t1
	inner join Suppliers as t2 on t1.SupplierID <> t2.SupplierID
		and t1.Country = t2.Country
order by t1.Country

-- Check
select Country
from Suppliers
group by Country
having count(*) > 1
-----------------------------------------------------------------------------------------------------------------------------------------
/*
По таблице Employees найти для каждого продавца его руководителя, т.е. кому он делает репорты.
Высветить колонки с именами 'User Name' (LastName) и 'Boss'.
В колонках должны быть высвечены имена из колонки LastName. 
*/
select
	t1.LastName as [User Name]
	,t2.LastName as Boss
from Employees as t1
	left join Employees as t2 on t1.ReportsTo = t2.EmployeeID
-----------------------------------------------------------------------------------------------------------------------------------------  
-- Найти минимальные заказы в разрезе OrderID только больше 5000.
select top 1 with ties
	sum((UnitPrice - UnitPrice * Discount) * Quantity) as MinOrder
from [Order Details]
group by OrderId
having sum((UnitPrice - UnitPrice * Discount) * Quantity) > 5000
order by MinOrder
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести названия продуктов и названия поставщиков, находящихся в США
select
	p.ProductName
	,s.CompanyName
from Products as p
	inner join Suppliers as s on p.SupplierID = s.SupplierID
where s.Country = 'USA'
-----------------------------------------------------------------------------------------------------------------------------------------
-- Определить продукты, заказанные клиентами из Мадрида. Вывести Название продукта и Имя клиента.
select
	p.ProductName
	,c.CompanyName
from Products as p
	inner join [Order Details] as od on p.ProductID = od.ProductID
	inner join Orders as o on od.OrderID = o.OrderID
	inner join Customers as c on o.CustomerID = c.CustomerID
		and c.City = 'Madrid'
-----------------------------------------------------------------------------------------------------------------------------------------
-- Выбрать цену за единицу и названия продуктов, заказанных 26.02.1998
select
	p.UnitPrice
	,p.ProductName
from Products as p
	inner join [Order Details] as od on p.ProductID = od.ProductID
	inner join Orders as o on od.OrderID = o.OrderID
where o.OrderDate = convert(datetime, '19980226', 112)
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Вывести фамилии всех продавцов и суммарное число их заказов. 
Учитывать то, что у продавца может не быть заказов. Упорядочить результаты по убыванию числа заказов.
*/
select
	e.LastName
	,count(o.OrderID) as QuantityOrders
from Employees as e
	left join Orders as o on e.EmployeeID = o.EmployeeID
group by e.LastName
order by QuantityOrders desc
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Вывести все организации по доставке (таблица Shippers) и все, связанные с ними заказы.
Выводить все организации независимо от того, участвовали они в перевозках заказов или нет.
*/
select
	s.CompanyName
	,o.OrderID
from Shippers as s
	left join Orders as o on s.ShipperID = o.ShipVia
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Вывести имена клиентов и названия поставщиков, которые находятся в одном городе. 
Выводить имена клиентов, даже если в их городе нет поставщиков и наоборот
*/
select
	c.CompanyName
	,s.CompanyName
from Customers as c
	full join Suppliers as s on c.City = s.City
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести все возможные комбинации названий поставщиков и названий продуктов
select
	s.CompanyName
	,p.ProductName
from Suppliers as s
	cross join Products as p
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести имена клиентов, заказы для которых нужно доставить в Лондон
-- Join
select distinct	c.CompanyName
from Customers as c
	inner join Orders as o on c.CustomerID = o.CustomerID
		and o.ShipCity = 'London'

-- Subquery
select c.CompanyName
from Customers as c
where c.CustomerID in(
	select o.CustomerID
	from Orders as o
	where o.ShipCity = 'London')
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести все заказы, оформленные продавцами не из США
-- Join
select o.OrderID
from Orders as o
	inner join Employees as e on o.EmployeeID = e.EmployeeID
		and e.Country <> 'USA'

-- Subquery + not in
select o.OrderID
from Orders as o
where o.EmployeeID not in (
	select e.EmployeeID
	from Employees as e
	where e.Country = 'USA')

-- Subquery + in
select o.OrderID
from Orders as o
where o.EmployeeID in (
	select e.EmployeeID
	from Employees as e
	where e.Country <> 'USA')
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести названия поставщиков, у которых цена за единицу товара между 10 и 15
-- Join
select distinct s.CompanyName
from Suppliers as s
	inner join Products as p on s.SupplierID = p.SupplierID
		and p.UnitPrice between 10 and 15

-- Subquery
select s.CompanyName
from Suppliers as s
where s.SupplierID in (
	select p.SupplierID
	from Products as p
	where p.UnitPrice between 10 and 15)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Высветить всех клиентов, которые имеют более 15 заказов. Использовать вложенный коррелированный SELECТ
select c.CompanyName
from Customers as c
where c.CustomerID in (
	select o.CustomerID
	from Orders as o
	where c.CustomerID = o.CustomerID
	group by o.CustomerID
	having count(*) > 15)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Найти поставщиков, цена за единицу товара которых менее 50% средней цены всех товаров этих поставщиков
select s.CompanyName
from Suppliers as s
where s.SupplierID in (
	select p.SupplierID
	from Products as p
	where s.SupplierID = p.SupplierID
		and p.UnitPrice < (
			select avg(q1.UnitPrice) / 2
			from Products as q1
			where s.SupplierID = q1.SupplierID
			group by q1.SupplierID))
-----------------------------------------------------------------------------------------------------------------------------------------
-- Найдите регионы, имеющие более 15 территорий
-- Subquery
select r.RegionDescription
from Region as r
where r.RegionID in (
	select t.RegionID
	from Territories as t
	where r.RegionID = t.RegionID
	group by t.RegionID
	having count(*) > 15)

-- Exists
select r.RegionDescription
from Region as r
where exists (
	select *
	from Territories as t
	where r.RegionID = t.RegionID
	group by t.RegionID
	having count(*) > 15)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести только те продукты, на которые нет скидки в таблице [Order Details]. (Если скидка равна нулю, подразумевается, что она есть)
-- Subquery
select p.ProductName
from Products as p
where p.ProductID in (
	select od.ProductID
	from [Order Details] as od
	where p.ProductID = od.ProductID
		and od.Discount is null)

-- Left join
select p.ProductName, od.Discount
from Products as p
	left join [Order Details] as od on p.ProductID = od.ProductID
where od.Discount is null

-- Exists
select p.ProductName
from Products as p
where exists (
	select *
	from [Order Details] as od
	where p.ProductID = od.ProductID
		and od.Discount is null)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Выводить имена клиентов, только если хотя бы один из них проживает в Мадриде
select ContactName
from Customers
where exists (
	select *
	from Customers
	where City = 'Madrid')
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Для формирования алфавитного указателя компаний, в которых работают клиенты высветить из таблицы Customers список только тех букв алфавита,
с которых начинаются названия компаний (колонка CompanyName) из этой таблицы. Алфавитный список должен быть отсортирован по возрастанию
*/
select distinct left(CompanyName, 1) as Alphabet
from Customers
order by Alphabet
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести контактную информацию о всех клиентах в верхнем регистре
select upper(ContactTitle) as UpContactTitle
from Customers
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести в юникоде первые буквы названий компаний, в которых работают клиенты
select unicode(left(CompanyName, 1)) as UnicodeCompanyName
from Customers
-- Вывести имена продавцов, начиная с 4 символа. Результат должен быть отсортирован по убыванию
select substring(FirstName, 4, 6) as MayTheFourthBeWithYou
from Employees
order by MayTheFourthBeWithYou desc
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести названия всех продуктов, рядом в столбце 'Длина названия' вывести длину названий. Результат должен быть отсортирован по алфавиту
select 
	ProductName
	,len(ProductName) as [Длина названия]
from Products
order by ProductName
-----------------------------------------------------------------------------------------------------------------------------------------
-- Вывести названия поставщиков задом наперёд и в нижнем регистре
select lower(reverse(CompanyName)) as LowReverseCompanyName
from Suppliers
-----------------------------------------------------------------------------------------------------------------------------------------
/*
Составить отчет, содержащий минимальные заказы в разрезе дат с учетом количества закупленных товаров и скидок по ним. 
Причем выводить только суммы заказов меньше 100.
*/
select
	o.OrderID
	,o.OrderDate
	,cast(sum((UnitPrice - UnitPrice * Discount) * Quantity) as money) as [Минимальный заказ]
from Orders as o
	inner join [Order Details] as od on o.OrderID = od.OrderID
group by
	o.OrderDate
	,o.OrderID
having sum((UnitPrice - UnitPrice * Discount) * Quantity) < 100
order by OrderDate
-----------------------------------------------------------------------------------------------------------------------------------------
-- Выбрать 5 лучших поставщиков, суммарная стоимость продуктов которых не превышает 75000
select top 5 with ties
	s.CompanyName
	,cast(sum((od.UnitPrice - od.UnitPrice * od.Discount) * od.Quantity) as money) as [Сумма]
from Suppliers as s
	inner join Products as p on s.SupplierID = p.SupplierID
	inner join [Order Details] as od on p.ProductID = od.ProductID
group by
    s.SupplierID
    ,s.CompanyName
    ,s.ContactName
having cast(sum((od.UnitPrice - od.UnitPrice * od.Discount) * od.Quantity) as money) <= 75000
order by [Сумма] desc