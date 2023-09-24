/*
������� � ������� Orders ������, ������� ���� ���������� �� 1������ 1997 ���� (������� ShippedDate),
� ������� ���������� � ShipVia >= 3. ������ �������� ���� ������ ���� ������ ��� ����� ������������ ����������.
������ ������ ����������� ������ ������� OrderID, ShippedDate � ShipVia. 
*/
select
	OrderID
	,ShippedDate
	,ShipVia
from Orders
where ShippedDate < convert(datetime, '19970101', 112)
	and ShipVia >= 3
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� ��� ���������� �� ������� �� ������� ������� (�� ��������).
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
������� �� ������� Employees ����� � ������� ���� ����������� ������ 70-��  ���. 
�������� ����� ������� ���������� � ������� � ��������� �Age� ������� ��� �������.
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
�������� ������, ������� ������� ������ �������� ��� ����� �� ������� Suppliers.
� ����������� ������� ����������� ��� ������� Fax ������ �������� NULL
������ �No fax� � ������������ ��������� ������� CAS�. ������ ������ ����������� ������ ������� CompanyName � Fax.
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
������� � ������� Orders ������, ������� ���� ���������� �� 6 ��� 1998 ���� (ShippedDate) �� ������� ��� ���� ��� ������� ��� �� ����������.
� ������� ������ ������������� ������ ������� OrderID (������������� � Order Number) � ShippedDate (������������� � Shipped Date). 
� ����������� ������� ����������� ��� ������� ShippedDate ������ �������� NULL ������ �Not Shipped�, 
��� ��������� �������� ����������� ���� � ������� �� ���������.
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
������� ������, ������������ �� 5 ��� 2007 ����. 
�������� ������ OrderID � ���� �������� ���. ���� �������� � ������� ��� �� ���� ��:�� AM (��� PM). ������������ ������� CAST.
*/
select
	OrderID
	,cast(ShippedDate as varchar(20)) as ShippedDate
from Orders
where ShippedDate < convert(datetime, '20070505', 112)
-----------------------------------------------------------------------------------------------------------------------------------------
/*
������� ������, ������������ �� 5 ��� 2007 ����. �������� ������ OrderID � ���� �������� ���. ���� �������� � ������� ��/��/����.
������������ ������� CONVERT.
*/
select
	OrderID
	,convert(char,ShippedDate, 101) as ShippedDate
from Orders
where ShippedDate < convert(datetime, '20070505', 112)
-----------------------------------------------------------------------------------------------------------------------------------------
/*
������� ���� �����������, ����������� � ������� � ������. ������ ������� � ������ ������� ��������� IN. 
����������� ������� � ������, �������� ������������ � ��������� ������ � ����������� �������. 
����������� ���������� ������� �� ������� �����������.
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
������� �� ������� Employees ���� �����������, �� ����������� � ������� � ������. ������ ������� � ������� ��������� IN. 
����������� ������� � ������, �������� ������������ � ��������� ������ � ����������� �������. 
����������� ���������� ������� �� ������� �����������.
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
������� �� ������� Customers ��� ContactTitle, ������� � ��� �����������.
������ ContactTitle ������ ���� �������� ������ ���� ��� � ������ ������������ �� �����������.
�� ������������ ����������� GROUP BY. ����������� ������ ���� ������� � ����������� �������. 
*/
select distinct ContactTitle
from Customers
order by ContactTitle
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� �� ������� Shippers ���� CompanyName � ShipperID. ���������� ������� ����������� �� ����� ����� � �������, ������� ������.
select
	CompanyName
	,ShipperID
from Shippers
order by CompanyName, ShipperID
-----------------------------------------------------------------------------------------------------------------------------------------
/*
��� ������� ���������� ��������� 2-�� ���������. ������� ��� ������ (OrderID) �� ������� Order Details (������ �� ������ �����������), 
��� ����������� �������� � ����������� �� 1 �� 6 �� ������� 1 � 6 � ��� ������� Quantity � ������� Order Details. 
������������ �������� BETWEEN. ������ ������ ����������� ������ ������� OrderID. 
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
������� ���� ���������� �� ������� Customers, � ������� ������ ����� �������� ������ �� ��������� o � r. 
������������ �������� BETWEEN. ������ ������ ����������� ������ ������� CustomerID � Country � ������������ �� Country.
*/
select
	CustomerID
	,Country
from Customers
where substring(Country, 2, 1) between 'o' and 'r'
order by Country
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� ���� ���������� �� ������� Customers, � ������� ������ ����� �������� ������ �� ��������� o � r, �� ��������� �������� BETWEEN.
select
	CustomerID
	,Country
from Customers
where substring(Country, 2, 1) >= 'o'
	and substring(Country, 2, 1) <=  'r'
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� �� �������  ����������� ��� ��������, �������� ������� ���������� �� �L�.
select CompanyName
from Suppliers
where CompanyName like 'l%'

-- � ������� Products ����� ��� �������� (������� ProductName), ��� ����������� ������� t ('tt').
select ProductName
from Products
where ProductName like '%tt%'
-----------------------------------------------------------------------------------------------------------------------------------------
-- ���������� ������� ��� ���������� � ����������(������� Employees), ��� ������� ����� �� �������� (Davolio ��� Diavolo).
select *
from Employees
where LastName like 'd%avol%o'

-- ����� ���-�� ������� �� ������� ������ 30%.
select count(*) as Count
from [Order Details]
where Discount < 0.3
-----------------------------------------------------------------------------------------------------------------------------------------
/*
����� ����� ����� ���� ������� �� ������� Order Details � ������ ���������� ����������� ������� � ������ �� ��� � ������� �� ��� ������, 
� ������� ������ ������ 15 ���������. ��������� ��������� �� �����. 
������ (������� Discount) ���������� ������� �� ��������� ��� ������� ������. 
��� ����������� �������������� ���� �� ��������� ������� ���� ������� ������ �� ��������� � ������� UnitPrice ����. 
����������� ������� ������ ���� ���� ������ � ����� �������� � ��������� ������� 'Totals'.
*/
select round(sum((UnitPrice - UnitPrice * Discount) * Quantity), 2) as Totals
from [Order Details]
where Discount >= 0.15
-----------------------------------------------------------------------------------------------------------------------------------------
/*
����� ������� ����� ������������ � ����������� �� ���� ������� �� ������� Order Details � ������ ���������� ����������� ������� � ������ �� ���.
��������� ��������� �� �����. 
*/
select round(max((UnitPrice - UnitPrice * Discount) * Quantity) - min((UnitPrice - UnitPrice * Discount) * Quantity), 2) as Totals
from [Order Details]
group by OrderID
-----------------------------------------------------------------------------------------------------------------------------------------
-- ����� ������� ���-�� ��������� � �������.
select avg(Quantity) as AVG_Quantity
from [Order Details]
group by OrderID
-----------------------------------------------------------------------------------------------------------------------------------------
/*
�� ������� Orders ����� ���������� �������, ������� ��� ���������� (�.�. � ������� ShippedDate ���� ��������  ���� ��������). 
������������ ��� ���� ������� ������ �������� COUNT. �� ������������ ����������� WHERE � GROUP
*/
select count(ShippedDate)
from Orders
-----------------------------------------------------------------------------------------------------------------------------------------
/*
������� 6.13.
�� ������� Customers ����� ���������� ��������� �������, � ������� ����������� ���������. 
������������ ������� COUNT � �� ������������ ����������� WHERE � GROUP.
*/
select count(distinct City) as CountUniqueCity
from Customers
-----------------------------------------------------------------------------------------------------------------------------------------
/*
�� ������� Orders ����� ���������� ������� � ������������ �� ����������. 
� ����������� ������� ���� ����������� ��� ������� c ���������� Customer � Total. 
�������� ����������� ������, ������� ��������� ���������� ���� �������.
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
�� ������� Orders ����� ���������� �������, ��������� ������ ����������. ����� ���������� ��������� � ��� ����� ������ � ������� Orders, 
��� � ������� CustomerID ������ �������� ��� ������� ���������. � ����������� ������� ���� ����������� ������� � ��������� �������� ���������
(�������� ������ ������ ������������ ����������� �� CustomerID), � ��������� ������� �Customer� � ������� c ����������� �������
����������� � ��������� 'Amount'. ���������� ������� ������ ���� ����������� �� �������� ���������� �������.
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
����� ����������� � ���������, ������� ����� � ����� ������. ���� � ������ ����� ������ ���� ��� ��������� ��������� ��� ������ ���� 
��� ��������� �����������, �� ���������� � ����� ���������� � ��������� �� ������ �������� � �������������� �����. 
�.�. ���� � ������ ����� ������ �������� ��� ������ ����������, �� ��� ������ �� ���������.  �� ������������ ����������� JOIN. 
� ����������� ������� ���������� ������� ��������� ��������� ��� ����������� �������: �Person�, �Type� (����� ���� �������� ������ �Customer� 
���  �Seller� � ��������� �� ���� ������), �Country�. ������������� ���������� ������� �� ������� �Country� � �� �Person�.
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
����� ���� �����������, ������� �����������  � ����� ������. � ������� ������������ ���������� ������� Suppliers c ����� - ��������������. 
��������� ������� SupplierID � Country. ������ �� ������ ����������� ����������� ������. ��� �������� �������� ������, ������� ����������� ������, 
������� ����������� ����� ������ ���� � ������� Suppliers. 
��� �������� ��������� ������������ �������.
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
�� ������� Employees ����� ��� ������� �������� ��� ������������, �.�. ���� �� ������ �������.
��������� ������� � ������� 'User Name' (LastName) � 'Boss'.
� �������� ������ ���� ��������� ����� �� ������� LastName. 
*/
select
	t1.LastName as [User Name]
	,t2.LastName as Boss
from Employees as t1
	left join Employees as t2 on t1.ReportsTo = t2.EmployeeID
-----------------------------------------------------------------------------------------------------------------------------------------  
-- ����� ����������� ������ � ������� OrderID ������ ������ 5000.
select top 1 with ties
	sum((UnitPrice - UnitPrice * Discount) * Quantity) as MinOrder
from [Order Details]
group by OrderId
having sum((UnitPrice - UnitPrice * Discount) * Quantity) > 5000
order by MinOrder
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� �������� ��������� � �������� �����������, ����������� � ���
select
	p.ProductName
	,s.CompanyName
from Products as p
	inner join Suppliers as s on p.SupplierID = s.SupplierID
where s.Country = 'USA'
-----------------------------------------------------------------------------------------------------------------------------------------
-- ���������� ��������, ���������� ��������� �� �������. ������� �������� �������� � ��� �������.
select
	p.ProductName
	,c.CompanyName
from Products as p
	inner join [Order Details] as od on p.ProductID = od.ProductID
	inner join Orders as o on od.OrderID = o.OrderID
	inner join Customers as c on o.CustomerID = c.CustomerID
		and c.City = 'Madrid'
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� ���� �� ������� � �������� ���������, ���������� 26.02.1998
select
	p.UnitPrice
	,p.ProductName
from Products as p
	inner join [Order Details] as od on p.ProductID = od.ProductID
	inner join Orders as o on od.OrderID = o.OrderID
where o.OrderDate = convert(datetime, '19980226', 112)
-----------------------------------------------------------------------------------------------------------------------------------------
/*
������� ������� ���� ��������� � ��������� ����� �� �������. 
��������� ��, ��� � �������� ����� �� ���� �������. ����������� ���������� �� �������� ����� �������.
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
������� ��� ����������� �� �������� (������� Shippers) � ���, ��������� � ���� ������.
�������� ��� ����������� ���������� �� ����, ����������� ��� � ���������� ������� ��� ���.
*/
select
	s.CompanyName
	,o.OrderID
from Shippers as s
	left join Orders as o on s.ShipperID = o.ShipVia
-----------------------------------------------------------------------------------------------------------------------------------------
/*
������� ����� �������� � �������� �����������, ������� ��������� � ����� ������. 
�������� ����� ��������, ���� ���� � �� ������ ��� ����������� � ��������
*/
select
	c.CompanyName
	,s.CompanyName
from Customers as c
	full join Suppliers as s on c.City = s.City
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� ��� ��������� ���������� �������� ����������� � �������� ���������
select
	s.CompanyName
	,p.ProductName
from Suppliers as s
	cross join Products as p
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� ����� ��������, ������ ��� ������� ����� ��������� � ������
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
-- ������� ��� ������, ����������� ���������� �� �� ���
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
-- ������� �������� �����������, � ������� ���� �� ������� ������ ����� 10 � 15
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
-- ��������� ���� ��������, ������� ����� ����� 15 �������. ������������ ��������� ��������������� SELEC�
select c.CompanyName
from Customers as c
where c.CustomerID in (
	select o.CustomerID
	from Orders as o
	where c.CustomerID = o.CustomerID
	group by o.CustomerID
	having count(*) > 15)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ����� �����������, ���� �� ������� ������ ������� ����� 50% ������� ���� ���� ������� ���� �����������
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
-- ������� �������, ������� ����� 15 ����������
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
-- ������� ������ �� ��������, �� ������� ��� ������ � ������� [Order Details]. (���� ������ ����� ����, ���������������, ��� ��� ����)
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
-- �������� ����� ��������, ������ ���� ���� �� ���� �� ��� ��������� � �������
select ContactName
from Customers
where exists (
	select *
	from Customers
	where City = 'Madrid')
-----------------------------------------------------------------------------------------------------------------------------------------
/*
��� ������������ ����������� ��������� ��������, � ������� �������� ������� ��������� �� ������� Customers ������ ������ ��� ���� ��������,
� ������� ���������� �������� �������� (������� CompanyName) �� ���� �������. ���������� ������ ������ ���� ������������ �� �����������
*/
select distinct left(CompanyName, 1) as Alphabet
from Customers
order by Alphabet
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� ���������� ���������� � ���� �������� � ������� ��������
select upper(ContactTitle) as UpContactTitle
from Customers
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� � ������� ������ ����� �������� ��������, � ������� �������� �������
select unicode(left(CompanyName, 1)) as UnicodeCompanyName
from Customers
-- ������� ����� ���������, ������� � 4 �������. ��������� ������ ���� ������������ �� ��������
select substring(FirstName, 4, 6) as MayTheFourthBeWithYou
from Employees
order by MayTheFourthBeWithYou desc
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� �������� ���� ���������, ����� � ������� '����� ��������' ������� ����� ��������. ��������� ������ ���� ������������ �� ��������
select 
	ProductName
	,len(ProductName) as [����� ��������]
from Products
order by ProductName
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� �������� ����������� ����� ������ � � ������ ��������
select lower(reverse(CompanyName)) as LowReverseCompanyName
from Suppliers
-----------------------------------------------------------------------------------------------------------------------------------------
/*
��������� �����, ���������� ����������� ������ � ������� ��� � ������ ���������� ����������� ������� � ������ �� ���. 
������ �������� ������ ����� ������� ������ 100.
*/
select
	o.OrderID
	,o.OrderDate
	,cast(sum((UnitPrice - UnitPrice * Discount) * Quantity) as money) as [����������� �����]
from Orders as o
	inner join [Order Details] as od on o.OrderID = od.OrderID
group by
	o.OrderDate
	,o.OrderID
having sum((UnitPrice - UnitPrice * Discount) * Quantity) < 100
order by OrderDate
-----------------------------------------------------------------------------------------------------------------------------------------
-- ������� 5 ������ �����������, ��������� ��������� ��������� ������� �� ��������� 75000
select top 5 with ties
	s.CompanyName
	,cast(sum((od.UnitPrice - od.UnitPrice * od.Discount) * od.Quantity) as money) as [�����]
from Suppliers as s
	inner join Products as p on s.SupplierID = p.SupplierID
	inner join [Order Details] as od on p.ProductID = od.ProductID
group by
    s.SupplierID
    ,s.CompanyName
    ,s.ContactName
having cast(sum((od.UnitPrice - od.UnitPrice * od.Discount) * od.Quantity) as money) <= 75000
order by [�����] desc