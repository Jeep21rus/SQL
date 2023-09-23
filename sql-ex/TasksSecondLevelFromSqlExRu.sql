/*
Краткая информация о базе данных "Корабли"
Рассматривается БД кораблей, участвовавших во второй мировой войне. Имеются следующие отношения:
Classes (class, type, country, numGuns, bore, displacement)
Ships (name, class, launched)
Battles (name, date)
Outcomes (ship, battle, result)
Корабли в «классах» построены по одному и тому же проекту, и классу присваивается либо имя первого корабля,
построенного по данному проекту, либо названию класса дается имя проекта, которое не совпадает ни с одним из кораблей в БД.
Корабль, давший название классу, называется головным.
Отношение Classes содержит имя класса, тип (bb для боевого (линейного) корабля или bc для боевого крейсера), страну, в которой
построен корабль, число главных орудий, калибр орудий (диаметр ствола орудия в дюймах) и водоизмещение ( вес в тоннах).
В отношении Ships записаны название корабля, имя его класса и год спуска на воду. В отношение Battles включены название и дата битвы,
в которой участвовали корабли, а в отношении Outcomes – результат участия данного корабля в битве (потоплен-sunk, поврежден - damaged
или невредим - OK).
Замечания. 1) В отношение Outcomes могут входить корабли, отсутствующие в отношении Ships. 2) Потопленный корабль в последующих битвах
участия не принимает.
*/
-- 14(2) Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.*/

select
	c.class
	,s.name
	,c.country
from ships as s
	inner join classes as c on s.class = c.class
where c.numguns >= 10;

/*
Краткая информация о базе данных "Компьютерная фирма"
Схема БД состоит из четырех таблиц:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, price, screen)
Printer(code, model, color, type, price)
Таблица Product представляет производителя (maker), номер модели (model) и тип
('PC' - ПК, 'Laptop' - ПК-блокнот или 'Printer' - принтер). Предполагается, что
номера моделей в таблице Product уникальны для всех производителей и типов продуктов.
В таблице PC для каждого ПК, однозначно определяемого уникальным кодом – code, указаны
модель – model (внешний ключ к таблице Product), скорость - speed (процессора в мегагерцах),
объем памяти - ram (в мегабайтах), размер диска - hd (в гигабайтах), скорость считывающего
устройства - cd (например, '4x') и цена - price (в долларах). Таблица Laptop аналогична таблице
РС за исключением того, что вместо скорости CD содержит размер экрана -screen (в дюймах).
В таблице Printer для каждой модели принтера указывается, является ли он цветным - color
('y', если цветной), тип принтера - type (лазерный – 'Laser', струйный – 'Jet' или матричный – 'Matrix') и цена - price.
*/

-- 15(2) Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD

select hd
from pc
group by hd
having count(*) >= 2;

/*
6(2) Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов.
Вывод: производитель, скорость.
*/

select distinct
	p.maker as Maker
	,l.speed
from laptop as l
	inner join product as p on l.model = p.model
where l.hd >= 10;


/*
7(2) Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
*/

select
	p.model
	,l.price
from product as p
	inner join laptop as l on p.model = l.model
where maker = 'B'

union

select
	p.model
	,pc.price
from product as p
	inner join PC on p.model = PC.model
where maker = 'B'

union

select
	p.model
	,pr.price
from product as p
	inner join Printer as pr on p.model = pr.model
where maker = 'B'

/*
8(2) Найдите производителя, выпускающего ПК, но не ПК-блокноты.
*/

-- 1 вариант
select p.maker 
from product as p
where type = 'pc'

except

select p.maker 
from product as p
where type = 'laptop';

-- 2 вариант
select distinct p.maker 
from product as p
where type = 'pc'
	and p.maker not in (
		 select
			p.maker 
		 from product as p
		 where type = 'laptop'
		 );

/* 
Задание: 16 (2)
Найдите пары моделей PC, имеющих одинаковые скорость и RAM.
В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), 
Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.
*/

select distinct 
	a.model as model1
	,b.model as model2
	,a.speed,a.ram 
from pc as a 
	cross join pc as b
where a.speed = b.speed 
	and a.ram = b.ram 
	and a.model > b.model;


/*
17(2) Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
Вывести: type, model, speed.
*/

select distinct
	p.type
	,p.model
	,l.speed
from laptop as l
	inner join product as p on l.model = p.model
where l.speed < all 
	(
	select
		speed 
	from PC
	);

/*
18(2) Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
*/

select distinct
	p.maker
	,pr.price
from printer as pr
	inner join product as p on pr.model = p.model
where color = 'y'
	and pr.price = 
	(
	select 
		min(price) 
	from printer
	where color = 'y'
	);

/*
20(2) Найдите производителей, выпускающих по меньшей мере три различных модели ПК.
Вывести: Maker, число моделей ПК.
*/

select
	maker
	,count(*) as [Количество]
from product
where type = 'PC'
group by maker
having count(*) >= 3;

/*
23(2) Найдите производителей, которые производили бы как ПК
со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
Вывести: Maker
*/

select p.maker
from product as p
	inner join pc on p.model = pc.model
where pc.speed >= 750

intersect

select p.maker
from product as p
	inner join laptop as l on p.model = l.model
where l.speed >= 750;



-- 24(2) Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.

select q1.model
from (
	select 
		pc.model
		,pc.price
	from pc
	
	union
	
	select 
		l.model
		,l.price
	from laptop as l
	
	union
	
	select 
		pr.model
		,pr.price
	from printer as pr
	) as q1
	where price = (
		select max(q2.price)
		from (
			select pc.price
			from pc
			
			union
			
			select l.price
			from Laptop as l
			
			union
			
			select pr.price
			from Printer as pr
			) as q2
	);

with cte1 as
	(
	select 
		pc.model
		,pc.price
	from pc
	
	union
	
	select 
		l.model
		,l.price
	from laptop as l
	
	union
	
	select 
		pr.model
		,pr.price
	from printer as pr
	),
	cte2 as (
			select pc.price
			from pc
			
			union
			
			select l.price
			from Laptop as l
			
			union
			
			select pr.price
			from Printer as pr
			)
select cte1.model
from cte1
where price = (
				select max(cte2.price)
				from cte2
				);

/*
25(2) Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, 
имеющих наименьший объем RAM. Вывести: Maker
*/

select distinct maker
from product
where model in (
	select model
	from pc
	where ram = (
	  select min(ram)
	  from pc
	  )
	and speed = 
	  (
	  select max(speed)
	  from pc
	  where ram = 
		(
		select min(ram)
	   from pc
	   )
	  )
)
	and
	maker in (
		select maker
		from product
		where type = 'printer'
		);


/*
Задание: 26 (2) Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). 
Вывести: одна общая средняя цена.
*/

with cte as
(select 
	maker
	,price
from product p
	inner join pc on p.model = pc.model
where maker = 'A' and type = 'pc'

union all

select 
	maker
	,price
from product p
	inner join laptop l on p.model = l.model
where maker = 'A' and type = 'laptop')

select avg(price)
from cte;


/*
Задание: 27 (2)Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. 
Вывести: maker, средний размер HD.
*/

select 
	maker
	,avg(hd) as avg_hd
from product p
	inner join pc on p.model = pc.model
where maker in 
	(
	select 
		maker 
	from product
	where type = 'Printer'
	)
group by maker;



-- Задание: 28 (2) Используя таблицу Product, определить количество производителей, выпускающих по одной модели.

select count(maker) as qty
from product
where maker in
	(
	select maker
	from product
	group by maker
	having count(model) = 1
	);



/*
Задание: 35 (2) В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра).
Вывод: номер модели, тип модели.
*/

select 
	model
	,type
from Product
where model not like '%[^a-z]%'
	or model not like '%[^0-9]%'


/*
Фирма имеет несколько пунктов приема вторсырья. Каждый пункт получает деньги для их выдачи сдатчикам вторсырья.
Сведения о получении денег на пунктах приема записываются в таблицу:
Income_o(point, date, inc)
Первичным ключом является (point, date). При этом в столбец date записывается только дата (без времени),
т.е. прием денег (inc) на каждом пункте производится не чаще одного раза в день. Сведения о выдаче денег сдатчикам вторсырья
записываются в таблицу:
Outcome_o(point, date, out)
В этой таблице также первичный ключ (point, date) гарантирует отчетность каждого пункта о выданных деньгах (out) не чаще одного раза в день.
В случае, когда приход и расход денег может фиксироваться несколько раз в день, используется другая схема с таблицами,
имеющими первичный ключ code:
Income(code, point, date, inc)
Outcome(code, point, date, out)
Здесь также значения столбца date не содержат времени.*/
/*29(2)
В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день
[т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход).
Использовать таблицы Income_o и Outcome_o.
*/

select 
	io.point
	,io.date
	,inc
	,out
from Income_o io
	left join Outcome_o oo on io.point = oo.point 
		and io.date = oo.date
		
union

select 
	oo.point
	,oo.date
	,inc
	,out
from Income_o io
	right join Outcome_o oo on io.point = oo.point 
		and io.date = oo.date;

/*
Задание: 61 (2)
Посчитать остаток денежных средств на всех пунктах приема для базы данных с отчетностью не чаще одного раза в день.
*/

with cte as
	(
	select 
		point
		,sum(inc) as sum
	from income_o
	group by point
	
	union
	
	select
		point,
		-sum(out) as sum
	from outcome_o
	group by point
	)

select 
	sum(cte.sum) as [остаток]
from cte;

/*
Рассматривается БД кораблей, участвовавших во второй мировой войне. Имеются следующие отношения:
Classes (class, type, country, numGuns, bore, displacement)
Ships (name, class, launched)
Battles (name, date)
Outcomes (ship, battle, result)
Корабли в «классах» построены по одному и тому же проекту, и классу присваивается либо имя первого корабля,
построенного по данному проекту, либо названию класса дается имя проекта, которое не совпадает ни с одним из кораблей в БД.
Корабль, давший название классу, называется головным.
Отношение Classes содержит имя класса, тип (bb для боевого (линейного) корабля или bc для боевого крейсера), страну, 
в которой построен корабль, число главных орудий, калибр орудий (диаметр ствола орудия в дюймах) и водоизмещение ( вес в тоннах). 
В отношении Ships записаны название корабля, имя его класса и год спуска на воду. В отношение Battles включены название и дата битвы, 
в которой участвовали корабли, а в отношении Outcomes – результат участия данного корабля в битве (потоплен-sunk, поврежден - damaged 
или невредим - OK).
Замечания. 1) В отношение Outcomes могут входить корабли, отсутствующие в отношении Ships. 2) Потопленный корабль в последующих битвах 
участия не принимает.
*/
/*
34(2) По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. 
Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей.
*/

select s.name
from classes c
	inner join ships s on c.class = s.class
where c.type = 'bb'
	and s.launched >= 1922
	and c.displacement > 35000



-- 36(2) Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes)

select name
from ships
where class = name

union

select ship as name
from classes c
	inner join outcomes o on c.class = o.ship


/*
Задание: 46 (2)
Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal), вывести название, водоизмещение и число орудий.
*/

with cte as 
	(
	select 
		s.name as ship
		,c.displacement
		,c.numGuns
	from Ships as s
		inner join Classes as c on c.class=s.class
		
	union
	
	select 
		c.class as ship
		,c.displacement
		,c.numGuns
	from Classes as c
	)
	
select 
	o.ship
	,cte.displacement
	,cte.numGuns
from cte
	right join Outcomes as o on o.ship = cte.ship
where battle = 'Guadalcanal'