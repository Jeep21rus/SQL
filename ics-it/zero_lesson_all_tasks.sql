/*
2. Создать таблицы
	2.1 dbo.SKU (ID identity, Code, Name)
		2.1.1 Ограничение на уникальность поля Code
		2.1.2 Поле Code вычисляемое: "s" + ID
	2.2 dbo.Family (ID identity, SurName, BudgetValue)
	2.3 dbo.Basket (ID identity, ID_SKU (внешний ключ на таблицу dbo.SKU), ID_Family (Внешний ключ на таблицу dbo.Family) Quantity,
	Value, PurchaseDate, DiscountValue)
		2.3.1 Ограничение, что поле Quantity и Value не могут быть меньше 0 constraint UK_SKU_Code unique (Code)
		2.3.2 Добавить значение по умолчанию для поля PurchaseDate: дата добавления записи (текущая дата)
*/


-- Таблица dbo.SKU
if object_id('dbo.SKU') is null
begin
	create table dbo.SKU (
		ID int identity not null,
		Code as ('s' + cast (ID AS varchar(50))),
		Name varchar(255) not null,
		constraint PK_SKU primary key (ID)
	)
	alter table dbo.SKU add constraint UK_SKU_Code unique (Code)
end


-- Таблица dbo.Family
if object_id('dbo.Family') is null
begin
	create table dbo.Family (
		ID int identity not null,
		SurName varchar(255) not null,
		BudgetValue decimal(18, 2) not null,
		constraint PK_Family primary key (ID)
	)
end


-- Таблица dbo.Basket
if object_id('dbo.Basket') is null
begin
	create table dbo.Basket (
		ID int identity(1, 1) not null,
		ID_SKU int not null,
		ID_Family int not null,
		Quantity int not null,
		Value int not null,
		PurchaseDate date not null,
		DiscountValue decimal(18, 2) not null,
		constraint PK_Basket primary key (ID)
	)
	alter table dbo.Basket add constraint CK_Basket_Quantity check (Quantity >= 0)
	alter table dbo.Basket add constraint CK_Basket_Value check (Value >= 0)
	alter table dbo.Basket add constraint DF_Basket_PurchaseDate default getdate() for PurchaseDate
	alter table dbo.Basket add constraint FK_Basket_ID_SKU_SKU foreign key (ID_SKU) references dbo.SKU (ID)
	alter table dbo.Basket add constraint FK_Basket_ID_Family_Family foreign key (ID_Family) references dbo.Family (ID)
end


/*
3 Создать функцию
	3.1 Входной параметр @ID_SKU
	3.2 Рассчитывает стоимость передаваемого продукта из таблицы dbo.Basket по формуле
		3.2.1 сумма Value по переданному SKU / сумма Quantity по переданному SKU
	3.3 На выходе значение типа decimal(18, 2)
*/


-- Проверка на существование объекта и его удаление при его наличии
if object_id('dbo.udf_GetSKUPrice') is not null
	drop function dbo.udf_GetSKUPrice;
go


-- Создание функции
create function dbo.udf_GetSKUPrice (@ID_SKU int)
returns decimal(18, 2)
as
begin
	declare @ProductCost decimal(18, 2)
	select 
		@ProductCost = sum(b.Value) / sum(b.Quantity)
	from dbo.Basket as b
	where b.ID_SKU = @ID_SKU

	return @ProductCost
end


/*
4 Создать представление (на выходе: файл в репозитории dbo.vw_SKUPriceв ветке VIEWs)
	4.1 Возвращает все атрибуты продуктов из таблицы dbo.SKU и расчетный атрибут со стоимостью одного продукта
	(используя функцию dbo.udf_GetSKUPrice)
*/


-- Проверка на существование объекта и его удаление при его наличии
if object_id('dbo.vw_SKUPrice') is not null
	drop view dbo.vw_SKUPrice;
go


-- Создание представления
create view dbo.vw_SKUPrice
as
select
	s.ID
	,s.Code
	,s.Name
	,dbo.udf_GetSKUPrice(ID) as SKUPrice
from dbo.SKU as s;


/*
5 Создать процедуру (на выходе: файл dbo.usp_MakeFamilyPurchase)
	5.1 Входной параметр (@FamilySurName varchar(255)) одно из значений атрибута SurName таблицы dbo.Family
	5.2 Процедура при вызове обновляет данные в таблицы dbo.Family в поле BudgetValue по логике
		5.2.1 dbo.Family.BudgetValue - sum(dbo.Basket.Value), где dbo.Basket.Value покупки для переданной в процедуру семьи
		5.2.2 При передаче несуществующего dbo.Family.SurName пользователю выдается ошибка, что такой семьи нет
*/


-- Проверка на существование объекта и его удаление при его наличии
if object_id('dbo.usp_MakeFamilyPurchase') is not null
	drop procedure dbo.usp_MakeFamilyPurchase;
go


-- Создание хранимой процедуры
create procedure dbo.usp_MakeFamilyPurchase @FamilySurName varchar(255)
as
begin
	if not exists (
		select
			f.ID
			,f.SurName
			,f.BudgetValue
		from dbo.Family as f
		where SurName = @FamilySurName
		)
	begin
		print ('Семьи с данной фамилией не существует в таблице Family')
	end
	declare @FamilyPurchase decimal(18, 2)
	set @FamilyPurchase = (
		select
			sum (b.Value)
		from dbo.Basket as b
			inner join dbo.Family as f on f.ID = b.ID_Family 
		where f.SurName = @FamilySurName
		)
	update f
	set f.BudgetValue = f.BudgetValue - @FamilyPurchase
	from dbo.Family as f
	where f.SurName = @FamilySurName
end


/*
6. Создать триггер (на выходе: файл в репозитории dbo.TR_Basket_insert_update в ветке Triggers)
	6.1 Если в таблицу dbo.Basket за раз добавляются 2 и более записей одного ID_SKU, то значение в поле DiscountValue,
	для этого ID_SKU рассчитывается по формуле Value * 5%, иначе DiscountValue = 0
*/


-- Проверка на существование объекта и его удаление при его наличии
if object_id('dbo.TR_Basket_insert_update') is not null
	drop trigger dbo.TR_Basket_insert_update;
go


-- Создание триггера
create trigger dbo.TR_Basket_insert_update
on dbo.Basket
after insert, update
as
begin
	with cte_RowsCount as (
		select
			b.ID_SKU
			,count(*) as RowsCounter
		from dbo.Basket as b
		where b.ID_SKU in (
			select
				i.ID_SKU
			from inserted as i
			)
		group by
			b.ID_SKU
		)
	update b
	set DiscountValue = iif(
			rc.RowsCounter > 1
			,b.Value * 0.05
			,0
			)
	from cte_RowsCount as rc
		inner join dbo.Basket as b on b.ID_SKU = rc.ID_SKU
end
