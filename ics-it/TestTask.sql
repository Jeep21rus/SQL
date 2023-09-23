/*
Вывести имена и периоды отпусков сотрудников, которые были в отпуске одновременно в 2020 году
    Одновременный отпуск - когда хотя бы 1 день отпусков у двух сотрудников совпадает
    Дополнение:
    - в случае декретного отпуска сотрудник мог уйти в отпуск в 2019-ом году, а вернуться в 2021-ом
    На выходе:
    - таблица со столбцами (КодСотрудника1, НачалоОтпуска, КонецОтпуска, КодСотрудника2, НачалоОтпуска, КонецОтпуска)
    - должна вернуться одна строка с парой "E01 - E03". При этом "E03 - E01" - это дубль, которого не должно быть в итоговом результате
    Ограничения:
    - правильными считаются решения без использования конструкций "group by", "distinct"
    - нет дублирования кода
    - решение должно быть без использования вспомогательных функций greatest(), least()
    - засчитываются решения БЕЗ использования OR в запросах
*/

-- DDL for T-SQL

-- Справочник сотрудников
create table Employee (
  ID int not null primary key,
  Code varchar(10) not null unique,
  Name varchar(255)
);

insert into Employee (ID, Code, Name)
values (1, 'E01', 'Ivanov Ivan Ivanovich'),
  (2, 'E02', 'Petrov Petr Petrovich'),
  (3, 'E03', 'Sidorov Sidr Sidorovich'),
  (4, 'E04', 'Semenov Semen Semenovich'),
  -- Полный тёзка сотрудника E02
  (5, 'E05', 'Petrov Petr Petrovich');

-- Отпуска сотрудников
create table Vacation (
  ID int not null identity primary key,
  ID_Employee int not null references Employee(ID),
  DateBegin date not null,
  DateEnd date not null
);

insert into Vacation (ID_Employee, DateBegin, DateEnd)
values (1, '2019-08-10', '2019-09-01')
  ,(2, '2019-05-01', '2019-05-15')
  ,(1, '2019-12-29', '2020-01-14')
  ,(3, '2020-01-14', '2020-01-14')
  ,(4, '2021-02-01', '2021-02-14');

-- DML 2 варианта

--	Первый вариант
select
    e1.Code as 'КодСотрудника1'
    ,v1.DateBegin as 'НачалоОтпуска'
    ,v1.DateEnd as 'КонецОтпуска'
    ,e2.Code as 'КодСотрудника2'
    ,v2.DateBegin as 'НачалоОтпуска'
    ,v2.DateEnd as 'КонецОтпуска'
from Vacation as v1 
	inner join Vacation as v2 on v1.DateBegin <= v2.DateEnd
		and v2.DateBegin <= v1.DateEnd
		and v1.ID_Employee < v2.ID_Employee
	inner join Employee as e1 on e1.ID = v1.ID_Employee
	inner join Employee as e2 on e2.ID = v2.ID_Employee;

--	Второй вариант
with cte as (
  select
    e.Code
    ,v.DateBegin
    ,v.DateEnd
  from Employee as e
    inner join Vacation as v on e.ID = v.ID_Employee
  where year(DateEnd) = '2020'
  )
select
    q1.Code as 'КодСотрудника1'
    ,q1.DateBegin as 'НачалоОтпуска'
    ,q1.DateEnd as 'КонецОтпуска'
    ,q2.Code as 'КодСотрудника2'
    ,q2.DateBegin as 'НачалоОтпуска'
    ,q2.DateEnd as 'КонецОтпуска'
from cte as q1 
  cross join cte as q2
where q1.Code <> q2.Code
	and q2.Code > q1.Code;