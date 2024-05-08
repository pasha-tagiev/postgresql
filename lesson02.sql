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