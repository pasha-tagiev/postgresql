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