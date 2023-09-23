/*
������� ���������� � ���� ������ "�������"
��������������� �� ��������, ������������� �� ������ ������� �����. ������� ��������� ���������:
Classes (class, type, country, numGuns, bore, displacement)
Ships (name, class, launched)
Battles (name, date)
Outcomes (ship, battle, result)
������� � ��������� ��������� �� ������ � ���� �� �������, � ������ ������������� ���� ��� ������� �������,
������������ �� ������� �������, ���� �������� ������ ������ ��� �������, ������� �� ��������� �� � ����� �� �������� � ��.
�������, ������ �������� ������, ���������� ��������.
��������� Classes �������� ��� ������, ��� (bb ��� ������� (���������) ������� ��� bc ��� ������� ��������), ������, � �������
�������� �������, ����� ������� ������, ������ ������ (������� ������ ������ � ������) � ������������� ( ��� � ������).
� ��������� Ships �������� �������� �������, ��� ��� ������ � ��� ������ �� ����. � ��������� Battles �������� �������� � ���� �����,
� ������� ����������� �������, � � ��������� Outcomes � ��������� ������� ������� ������� � ����� (��������-sunk, ��������� - damaged
��� �������� - OK).
���������. 1) � ��������� Outcomes ����� ������� �������, ������������� � ��������� Ships. 2) ����������� ������� � ����������� ������
������� �� ���������.
*/
-- 14(2) ������� �����, ��� � ������ ��� �������� �� ������� Ships, ������� �� ����� 10 ������.*/

select
	c.class
	,s.name
	,c.country
from ships as s
	inner join classes as c on s.class = c.class
where c.numguns >= 10;

/*
������� ���������� � ���� ������ "������������ �����"
����� �� ������� �� ������� ������:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, price, screen)
Printer(code, model, color, type, price)
������� Product ������������ ������������� (maker), ����� ������ (model) � ���
('PC' - ��, 'Laptop' - ��-������� ��� 'Printer' - �������). ��������������, ���
������ ������� � ������� Product ��������� ��� ���� �������������� � ����� ���������.
� ������� PC ��� ������� ��, ���������� ������������� ���������� ����� � code, �������
������ � model (������� ���� � ������� Product), �������� - speed (���������� � ����������),
����� ������ - ram (� ����������), ������ ����� - hd (� ����������), �������� ������������
���������� - cd (��������, '4x') � ���� - price (� ��������). ������� Laptop ���������� �������
�� �� ����������� ����, ��� ������ �������� CD �������� ������ ������ -screen (� ������).
� ������� Printer ��� ������ ������ �������� �����������, �������� �� �� ������� - color
('y', ���� �������), ��� �������� - type (�������� � 'Laser', �������� � 'Jet' ��� ��������� � 'Matrix') � ���� - price.
*/

-- 15(2) ������� ������� ������� ������, ����������� � ���� � ����� PC. �������: HD

select hd
from pc
group by hd
having count(*) >= 2;

/*
6(2) ��� ������� �������������, ������������ ��-�������� c ������� �������� ����� �� ����� 10 �����, ����� �������� ����� ��-���������.
�����: �������������, ��������.
*/

select distinct
	p.maker as Maker
	,l.speed
from laptop as l
	inner join product as p on l.model = p.model
where l.hd >= 10;


/*
7(2) ������� ������ ������� � ���� ���� ��������� � ������� ��������� (������ ����) ������������� B (��������� �����).
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
8(2) ������� �������������, ������������ ��, �� �� ��-��������.
*/

-- 1 �������
select p.maker 
from product as p
where type = 'pc'

except

select p.maker 
from product as p
where type = 'laptop';

-- 2 �������
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
�������: 16 (2)
������� ���� ������� PC, ������� ���������� �������� � RAM.
� ���������� ������ ���� ����������� ������ ���� ���, �.�. (i,j), �� �� (j,i), 
������� ������: ������ � ������� �������, ������ � ������� �������, �������� � RAM.
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
17(2) ������� ������ ��-���������, �������� ������� ������ �������� ������� �� ��.
�������: type, model, speed.
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
18(2) ������� �������������� ����� ������� ������� ���������. �������: maker, price
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
20(2) ������� ��������������, ����������� �� ������� ���� ��� ��������� ������ ��.
�������: Maker, ����� ������� ��.
*/

select
	maker
	,count(*) as [����������]
from product
where type = 'PC'
group by maker
having count(*) >= 3;

/*
23(2) ������� ��������������, ������� ����������� �� ��� ��
�� ��������� �� ����� 750 ���, ��� � ��-�������� �� ��������� �� ����� 750 ���.
�������: Maker
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



-- 24(2) ����������� ������ ������� ����� �����, ������� ����� ������� ���� �� ���� ��������� � ���� ������ ���������.

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
25(2) ������� �������������� ���������, ������� ���������� �� � ���������� ������� RAM � � ����� ������� ����������� ����� ���� ��, 
������� ���������� ����� RAM. �������: Maker
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
�������: 26 (2) ������� ������� ���� �� � ��-���������, ���������� �������������� A (��������� �����). 
�������: ���� ����� ������� ����.
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
�������: 27 (2)������� ������� ������ ����� �� ������� �� ��� ��������������, ������� ��������� � ��������. 
�������: maker, ������� ������ HD.
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



-- �������: 28 (2) ��������� ������� Product, ���������� ���������� ��������������, ����������� �� ����� ������.

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
�������: 35 (2) � ������� Product ����� ������, ������� ������� ������ �� ���� ��� ������ �� ��������� ���� (A-Z, ��� ����� ��������).
�����: ����� ������, ��� ������.
*/

select 
	model
	,type
from Product
where model not like '%[^a-z]%'
	or model not like '%[^0-9]%'


/*
����� ����� ��������� ������� ������ ���������. ������ ����� �������� ������ ��� �� ������ ��������� ���������.
�������� � ��������� ����� �� ������� ������ ������������ � �������:
Income_o(point, date, inc)
��������� ������ �������� (point, date). ��� ���� � ������� date ������������ ������ ���� (��� �������),
�.�. ����� ����� (inc) �� ������ ������ ������������ �� ���� ������ ���� � ����. �������� � ������ ����� ��������� ���������
������������ � �������:
Outcome_o(point, date, out)
� ���� ������� ����� ��������� ���� (point, date) ����������� ���������� ������� ������ � �������� ������� (out) �� ���� ������ ���� � ����.
� ������, ����� ������ � ������ ����� ����� ������������� ��������� ��� � ����, ������������ ������ ����� � ���������,
�������� ��������� ���� code:
Income(code, point, date, inc)
Outcome(code, point, date, out)
����� ����� �������� ������� date �� �������� �������.*/
/*29(2)
� �������������, ��� ������ � ������ ����� �� ������ ������ ������ ����������� �� ���� ������ ���� � ����
[�.�. ��������� ���� (�����, ����)], �������� ������ � ��������� ������� (�����, ����, ������, ������).
������������ ������� Income_o � Outcome_o.
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
�������: 61 (2)
��������� ������� �������� ������� �� ���� ������� ������ ��� ���� ������ � ����������� �� ���� ������ ���� � ����.
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
	sum(cte.sum) as [�������]
from cte;

/*
��������������� �� ��������, ������������� �� ������ ������� �����. ������� ��������� ���������:
Classes (class, type, country, numGuns, bore, displacement)
Ships (name, class, launched)
Battles (name, date)
Outcomes (ship, battle, result)
������� � ��������� ��������� �� ������ � ���� �� �������, � ������ ������������� ���� ��� ������� �������,
������������ �� ������� �������, ���� �������� ������ ������ ��� �������, ������� �� ��������� �� � ����� �� �������� � ��.
�������, ������ �������� ������, ���������� ��������.
��������� Classes �������� ��� ������, ��� (bb ��� ������� (���������) ������� ��� bc ��� ������� ��������), ������, 
� ������� �������� �������, ����� ������� ������, ������ ������ (������� ������ ������ � ������) � ������������� ( ��� � ������). 
� ��������� Ships �������� �������� �������, ��� ��� ������ � ��� ������ �� ����. � ��������� Battles �������� �������� � ���� �����, 
� ������� ����������� �������, � � ��������� Outcomes � ��������� ������� ������� ������� � ����� (��������-sunk, ��������� - damaged 
��� �������� - OK).
���������. 1) � ��������� Outcomes ����� ������� �������, ������������� � ��������� Ships. 2) ����������� ������� � ����������� ������ 
������� �� ���������.
*/
/*
34(2) �� �������������� �������������� �������� �� ������ 1922 �. ����������� ������� �������� ������� �������������� ����� 35 ���.����. 
������� �������, ���������� ���� ������� (��������� ������ ������� c ��������� ����� ������ �� ����). ������� �������� ��������.
*/

select s.name
from classes c
	inner join ships s on c.class = s.class
where c.type = 'bb'
	and s.launched >= 1922
	and c.displacement > 35000



-- 36(2) ����������� �������� �������� ��������, ��������� � ���� ������ (������ ������� � Outcomes)

select name
from ships
where class = name

union

select ship as name
from classes c
	inner join outcomes o on c.class = o.ship


/*
�������: 46 (2)
��� ������� �������, �������������� � �������� ��� ������������ (Guadalcanal), ������� ��������, ������������� � ����� ������.
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