-- соединения
-- inner join
-- left join, right join
-- full join
-- cross join
-- self join

--
-- inner join
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
    sum(products.unit_price * products.units_in_stock) desc