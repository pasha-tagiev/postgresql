-- соединения
-- inner join
-- left join, right join
-- full join
-- cross join
-- self join

--
-- [inner] join 
--

select
    products.product_name, 
    suppliers.company_name, 
    products.units_in_stock
from 
    products 
inner join 
    suppliers
on 
    products.supplier_id = suppliers.supplier_id
order by 
    products.units_in_stock desc;


select 
    categories.category_name, 
    categories.description, 
    sum(products.units_in_stock)
from 
    categories
inner join
    products
on 
    products.category_id = categories.category_id
where
    products.discontinued != 1
group by 
    categories.category_name, 
    categories.description
order by 
    sum(products.units_in_stock) desc
limit
    5;


select
    categories.category_name,
    categories.description,
    sum(products.unit_price * products.units_in_stock)
from
    categories
inner join 
    products
on 
    products.category_id = categories.category_id
where
    products.discontinued != 1
group by
    categories.category_name,
    categories.description
having
    sum(products.unit_price * products.units_in_stock) > 5000
order by
    sum(products.unit_price * products.units_in_stock) desc;


select 
    employees.employee_id,
    employees.last_name,
    employees.first_name,
    orders.ship_name
from
    employees
inner join
    orders
on
    orders.employee_id = employees.employee_id
order by
    employees.employee_id;


select 
    orders.order_date,
    products.product_name,
    orders.ship_country,
    products.unit_price,
    order_details.quantity,
    order_details.discount
from
    order_details
inner join 
    orders   on orders.order_id = order_details.order_id 
inner join 
    products on products.product_id = order_details.product_id; 


select
    customers.contact_name,
    customers.company_name,
    customers.phone,
    employees.first_name,
    employees.last_name,
    employees.title,
    orders.order_date,
    products.product_name,
    orders.ship_country,
    products.unit_price,
    order_details.quantity,
    order_details.discount
from
    order_details
join
    orders on orders.order_id = order_details.order_id
join
    products on products.product_id = order_details.product_id
join
    employees on employees.employee_id = orders.employee_id
join
    customers on customers.customer_id = orders.customer_id
where
    orders.ship_country = 'USA';


--
-- left/right join
--


-- если каждому ключу есть соответсвие, то left/right join 
-- идентичен inner join

select 
    company_name,
    product_name
from
    suppliers
left join -- в этом запросе left join идентичен inner join 
    products on products.supplier_id = suppliers.supplier_id;


-- найдем компании у которых нет заказов
select
    company_name,
    order_id
from
    customers
left join
    orders on orders.customer_id = customers.customer_id
where
    order_id is null;


-- есть ли работники которые не обрабатывают заказы?
select
    employees.first_name,
    employees.last_name,
    orders.employee_id
from 
    employees
left join
    orders on orders.employee_id = employees.employee_id
where
    orders.employee_id is null;


-- full join - это объединение left и right join
-- cross join - каждая строка первой таблицы объединяется
-- с каждой строкой второй таблицы, для cross join не нужен on


--
-- self join
--


-- примера для self join в базе данных northwind не нашлось,
-- поэтому прежде чем использовать следующий пример нужно
-- создать новую базу данных

-- self join применяется когда существует иерархия в рамках одной таблицы

create table employee (
    employee_id int primary key,
    first_name varchar(256) not null,
    last_name varchar(256) not null,
    manager_id int,
    -- внешний ключ ссылается на первичный ключ этой же таблицы
    foreign key (manager_id) references employee(employee_id)
);

insert into 
    employee (employee_id, first_name, last_name, manager_id)
values
    (1, 'Windy', 'Hays', null),
    (2, 'Ava', 'Christensen', 1),
    (3, 'Hassan', 'Conner', 1),
    (4, 'Anna', 'Reeves', 2),
    (5, 'Sau', 'Norman', 2),
    (6, 'Kelsie', 'Hays', 3),
    (7, 'Tory', 'Goff', 3),
    (8, 'Salley', 'Lester', 3);
    
-- пример self join
-- выводим в первой колонке работников, во второй их менеджеров

select 
    e.first_name || ' ' || e.last_name as employee,
    m.first_name || ' ' || m.last_name as manager
from
    employee e
left join 
    employee m 
on 
    m.employee_id = e.manager_id
order by
    manager;


--
-- using, natural join
--

-- using можно применить когда происходит join по столбцам с одинаковым именем


select
    customers.contact_name,
    customers.company_name,
    customers.phone,
    employees.first_name,
    employees.last_name,
    employees.title,
    orders.order_date,
    products.product_name,
    orders.ship_country,
    products.unit_price,
    order_details.quantity,
    order_details.discount
from
    order_details
join
    orders using(order_id) -- вместо on orders.order_id = order_details.order_id
join
    products using(product_id)
join
    employees using(employee_id)
join
    customers using(customer_id)
where
    orders.ship_country = 'USA';


-- natural join - join всех столбцов с одинаковым наименованием
-- по умолчанию ведет себя как inner join
-- общий вид: natural [ { left | right } [ outer ] | inner ] join
select
    orders.order_id,
    orders.customer_id,
    employees.first_name,
    employees.last_name,
    employees.title
from
    orders
natural join
    employees;


--
-- as (псевдонимы)
--


select 
    count(*) as employees_count
from
    employees;


select
    count(distinct country) as country
from
    employees;


select
    categories.category_name, 
    sum(products.units_in_stock) as units_in_stock
from 
    products
join 
    categories using(category_id)
group by 
    categories.category_name
order by
    categories.category_name desc
limit 
    5;


select
    categories.category_name as category,
    sum(products.unit_price * products.units_in_stock) as total_price
from
    categories
join
    products using(category_id)
where
    products.discontinued != 1
group by
    category
having
    -- в where и having нельзя использовать псевдонимы,
    -- т.к. они работают до вызова select
    sum(products.unit_price * products.units_in_stock) > 10000
order by
    total_price desc;


--
-- ДЗ
--


-- Найти заказчиков и обслуживающих их заказы сотрудников таких, что и заказчики 
-- и сотрудники из города London, а доставка идёт компанией Speedy Express. 
-- Вывести компанию заказчика и ФИО сотрудника.
select 
    customers.company_name,
    employees.first_name || ' ' || employees.last_name as full_name
from
    orders
join
    customers using(customer_id)
join
    employees using(employee_id)
join
    shippers on shippers.shipper_id = orders.ship_via
where
    employees.city = 'London' and
    customers.city = 'London' and
    shippers.company_name = 'Speedy Express';


-- Найти активные (см. поле discontinued) продукты из категории Beverages и Seafood, 
-- которых в продаже менее 20 единиц. Вывести наименование продуктов, кол-во единиц в 
-- продаже, имя контакта поставщика и его телефонный номер.
select 
    products.product_name,
    products.units_in_stock,
    suppliers.contact_name,
    suppliers.phone
from
    products
join
    suppliers using(supplier_id)
join
    categories using(category_id)
where
    categories.category_name in ('Beverages', 'Seafood') and
    products.discontinued = 0 and
    products.units_in_stock < 20
order by
    products.units_in_stock;


-- Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и order_id.
select 
    customers.contact_name,
    orders.order_id
from
    customers
left join
    orders using(customer_id)
where
    orders.order_id is null;


-- Переписать предыдущий запрос, использовав симметричный 
-- вид джойна (подсказка: речь о LEFT и RIGHT).
select 
    customers.contact_name,
    orders.order_id
from
    orders
right join
    customers using(customer_id)
where
    orders.order_id is null;