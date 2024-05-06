--
-- дефолтный путь сохранения запросов pgAdmin - /var/lib/pgadmin/storage/<your_email>/
--

--
-- select
--

select * from employees;

select employee_id, first_name, last_name from employees where title_of_courtesy = 'Dr.';

select distinct city from employees;

select distinct city, country from employees;

--
-- count()
--

select count(distinct country) from employees;

--
-- ДЗ
--

-- Выбрать все данные из таблицы customers
select * from customers;

-- Выбрать все записи из таблицы customers, но только колонки "имя контакта" и "город"
select contact_name, city from customers;

-- Выбрать все записи из таблицы orders, но взять две колонки: идентификатор заказа и 
-- колонку, значение в которой мы рассчитываем как разницу между датой отгрузки и датой формирования заказа.
select order_id, shipped_date - order_date from orders;

-- Выбрать все уникальные города в которых "зарегестрированы" заказчики
select distinct city from customers;

-- Выбрать все уникальные сочетания городов и стран в которых "зарегестрированы" заказчики
select distinct city, country from customers;

-- Посчитать кол-во заказчиков
select count(customer_id) from customers;

-- Посчитать кол-во уникальных стран в которых "зарегестрированы" заказчики
select count(distinct country) from customers;

--
-- where
--

select company_name, contact_name, phone from customers where country = 'USA';

select * from products where unit_price > 20;

select count(product_id) from products where unit_price > 40;

select * from products where discontinued = 1;

select * from customers where city != 'Berlin'; -- или where city <> 'Berlin'

select * from orders where order_date >= '1998-03-02';

--
-- and, or
--

select * from products where unit_price > 25 and units_in_stock > 40;

select * from customers where city = 'Berlin' or city = 'San Francisco' or city = 'London';

select * from orders where shipped_date > '1998-04-30' and (freight < 75 or freight > 150); 

--
-- between
--

select * from orders where freight >= 20 and freight <= 40;

-- аналог с between
-- between включает границы
select * from orders where freight between 20 and 40;

-- даты
select * from orders where order_date between '1998-03-30' and '1998-04-03';

select customer_id, order_date from orders where order_date < '1996-07-08' or order_date > '1998-05-05';

-- аналог через not between
select customer_id, order_date from orders where order_date not between '1996-07-08' and '1998-05-05';

--
-- in, not in
-- 

select * from customers where country = 'Mexico' or country = 'Germany' or country = 'USA' or country = 'Canada';

-- аналог с in и списком значений
select * from customers where country in ('Mexico', 'Germany', 'USA', 'Canada');

--
-- сортировка с order by
--

-- если не указать как сортировать, то используется сортировка по возрастанию, т.е. asc
select distinct country from customers order by country asc; -- ascending

select distinct country from customers order by country desc; -- descending

-- сортировка по двум полям
-- в этом случаем сортировка происходит по набору полей
select distinct country, city
from customers
order by 
	country asc,
	city    asc;

--
-- min, max, avg, sum
--

-- id самого раннего заказа из Лондона
select order_id 
from orders 
where ship_city = 'London' 
order by 
	order_date asc
limit 1;

-- такую же форму имеет и функция min
-- как выбрать другой столбец разберемся позже 
select min(order_date) from orders where ship_city = 'London';

-- средняя цена продуктов в продаже
select avg(unit_price) from products where discontinued = 0;

-- общее кол-во товаров не в продаже
select sum(units_in_stock) from products where discontinued = 1;

--
-- ДЗ
--

-- Выбрать все заказы из стран France, Austria, Spain
select * from orders where ship_country in ('France', 'Austria', 'Spain');

-- Выбрать все заказы, отсортировать по required_date (по убыванию) и отсортировать по дате отгрузке (по возрастанию)
select * from orders order by required_date desc, shipped_date asc;

-- Выбрать минимальное кол-во  единиц товара среди тех продуктов, которых в продаже более 30 единиц.
select min(units_in_stock) from products where units_in_stock > 30 and discontinued=0;

-- Выбрать максимальное кол-во единиц товара среди тех продуктов, которых в продаже более 30 единиц.
select max(units_in_stock) from products where units_in_stock > 30 and discontinued=0;

-- Найти среднее значение дней уходящих на доставку с даты формирования заказа в USA
select avg(shipped_date - order_date) from orders where ship_country = 'USA';

select sum(units_in_stock * unit_price) from products where discontinued = 0; 

--
-- ключевое слово like (% - ноль и более символов, _ - ровно один символ)
--

-- все сотрудники имя которых заканчивается на n
select last_name, first_name from employees where first_name like '%n';

-- все сотрудники имя которых начинается на b
select last_name, first_name from employees where last_name like 'B%';

--
-- limit
-- 

select 
	product_name, unit_price 
from 
	products 
where 
	discontinued != 1 
order by 
	unit_price desc
limit 5; 

--
-- null, is null, is not null
--

-- все записи где ship_region null
select 
	ship_city, ship_region, ship_country 
from 
	orders 
where 
	ship_region is null;

-- все записи где ship_region не null
select 
	order_id, ship_name, ship_region
from 
	orders
where
	ship_region is not null;


--
-- group by
--


select 
	ship_country, count(*)
from 
	orders
where
	freight > 50
group by
	ship_country
order by
	count(*) desc;


select
	category_id, sum(units_in_stock)
from 
	products
group by
	category_id
order by
	sum(units_in_stock) desc
limit 5;
	
--
-- having - пост фильтр
--

select
	category_id, sum(unit_price * units_in_stock)
from
	products
where
	discontinued != 1
group by
	category_id
having
	sum(unit_price * units_in_stock) > 5000
order by
	sum(unit_price * units_in_stock) desc;

--
-- union, intersect, except
--

select 
	country
from 
	customers
-- если не нужно исключать повторения нужно написать union all
union select 
	country
from
	employees;

	
select 
	country
from
	customers
intersect select
	country
from
	suppliers;

-- пояснение к тому как работает except и except all
-- set A = (10 11 12 10 10)
-- set B = (10 10)
-- A except B ---> (11 12)
-- A except all B ---> (10 11 12)

	
select 
	country
from
	customers
except select
	country
from 
	suppliers;


--
-- ДЗ
--


-- Выбрать все записи заказов в которых наименование страны отгрузки начинается с 'U'

select 
	order_id, ship_name, ship_country 
from 
	orders
where
	ship_country
like
	'U%';

-- Выбрать записи заказов (включить колонки идентификатора заказа, идентификатора заказчика, веса и страны отгузки), которые должны быть 
-- отгружены в страны имя которых начинается с 'N', отсортировать по весу (по убыванию) и вывести только первые 3 записей.
select 
	order_id, customer_id, freight, ship_country
from
	orders
where
	ship_country
like
	'N%'
order by
	freight desc
limit 
	3;

-- Выбрать записи работников (включить колонки имени, фамилии, телефона, региона) в которых регион неизвестен
select 
	first_name, last_name, home_phone, region
from 
	employees
where
	region is null;

-- Подсчитать кол-во заказчиков регион которых известен
select
	count(*)
from 
	customers
where
	region is not null;

-- Подсчитать кол-во поставщиков в каждой из стран и отсортировать результаты группировки по убыванию кол-ва
select 
	country, count(*) 
from 
	suppliers
group by
	country
order by
	count(*) desc;

-- Подсчитать суммарный вес заказов (в которых известен регион) по странам, затем отфильтровать по суммарному весу 
-- (вывести только те записи где суммарный вес больше 2750) и отсортировать по убыванию суммарного веса.
select 
	ship_country, sum(freight) 
from 
	orders
where 
	ship_region is not null
group by
	ship_country
having
	sum(freight) > 2750
order by
	sum(freight) desc;

-- Выбрать все уникальные страны заказчиков и поставщиков и отсортировать страны по возрастанию
select 
	country 
from
	customers
union select
	country
from
	suppliers
order by
	country asc;

-- Выбрать такие страны в которых "зарегистированы" одновременно и заказчики и поставщики и работники.
select
	country
from
	customers
intersect select
	country
from 
	suppliers
intersect select
	country
from
	employees;

-- Выбрать такие страны в которых "зарегистированы" одновременно заказчики и поставщики, но при этом в них не "зарегистрированы" работники.
select
	country
from
	customers
intersect select
	country
from
	suppliers
except select
	country
from
	employees;