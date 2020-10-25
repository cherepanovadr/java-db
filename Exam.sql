-- 1.1
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'softuni_stores_system'
ORDER BY COLUMN_NAME, TABLE_NAME;


-- 1.2
SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'softuni_stores_system'
ORDER BY COLUMN_NAME, TABLE_NAME;

-- 1.3
SELECT 
    COLUMN_KEY
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_SCHEMA = 'softuni_stores_system'
        AND COLUMN_NAME IN ('id' , 'product_id',
        'store_id',
        'town_id',
        'address_id',
        'category_id',
        'picture_id',
        'manager_id')
ORDER BY COLUMN_NAME , TABLE_NAME DESC , COLUMN_KEY DESC;

-- 2 
INSERT into products_stores (product_id, store_id)
select p.id, 1 from 
products p left join products_stores ps on ps.product_id = p.id
 where ps.store_id is null; 
 
 #2 query
SELECT store_id, s.name, p.name, product_id FROM products_stores
JOIN products p ON p.id = products_stores.product_id
JOIN stores s ON products_stores.store_id = s.id
ORDER BY product_id, store_id;

-- 3
select * from employees e join stores s
on e.store_id = s.id
where year(e.hire_date) >=2003 and s.`name` not in('Cardguard', 'Veribet');

update employees e 
join stores s
on e.store_id = s.id
set manager_id = '3' and salary = salary - 500
where s.`name` not in('Cardguard', 'Veribet') and year(e.hire_date) >=2003;

-- 4  Delete
delete  from employees
where manager_id is not null and salary >=6000;

SELECT first_name, salary, hire_date, id
FROM employees;

-- 5.	Employees
select first_name, middle_name, last_name, salary, hire_date
from employees
order by hire_date desc;

-- 6.	Products with old pictures
select pr.`name` product_name,price, best_before,	concat(left(`description`,10),'...') short_description, url from products pr join pictures pic 
on pr.picture_id = pic.id
where char_length(`description`) >100 and year(added_on) < 2019 and price >20
order by price desc;

-- 7 Count of products in stores and their average

select s.`name`, count(ps.product_id) product_count, round(avg(price),2) from stores s 
left join products_stores ps on s.id = ps.store_id
left join products p on p.id = ps.product_id
group by 1
order by 2 desc, 3 desc, s.id;

-- 8.	Specific employees
select concat(first_name,' ', last_name) Full_name, s.`name` Store_name, a.`name` address, salary from employees e
join stores s on e.store_id = s.id
join addresses a on a.id = s.address_id
where e.salary < 7000 and a.`name` like '%a%' and char_length(s.`name`) > 5
order by e.id

-- 9.	Find all information about stores

select REVERSE(s.`name`), concat(UPPER(t.`name`),'-', a.`name`) full_address, count(e.id) , min(price), count(prod.id), DATE_FORMAT(max(added_on), "%D-%b-%Y") from stores s
join addresses a on s.address_id = a.id
join towns t on a.town_id = t.id
left join employees e on s.id = e.store_id
left join products_stores ps on s.id = ps.store_id
left join products prod on ps.product_id = prod.id
left join pictures pic on prod.picture_id = pic.id
group by 1
having  min(price) > 10
order by 1, min(price) ;

-- -10
select concat_ws(' ', first_name, concat(middle_name,'.'), last_name,'works in store for',TIMESTAMPDIFF(year,hire_date, '2020-10-18'),'years') from employees e
join stores s on e.store_id = s.id
where s.`name` = 'Keylex' 
order by salary desc
limit 1;

delimiter //
create function udf_top_paid_employee_by_store(store_name VARCHAR(50))
returns text deterministic
begin
return (select concat_ws(' ', first_name, concat(middle_name,'.'), last_name,'works in store for',TIMESTAMPDIFF(year,hire_date, '2020-10-18'),'years') from employees e
join stores s on e.store_id = s.id
where s.`name` = store_name 
order by salary desc
limit 1);
end //
delimiter ;
SELECT udf_top_paid_employee_by_store('Stronghold') as 'full_info';
SELECT udf_top_paid_employee_by_store('Keylex') as 'full_info';

-- 11
delimiter //
create procedure udp_update_product_price(address_name VARCHAR(50)) 
begin
	update addresses a
	join stores s on s.address_id = a.id
	join products_stores ps on ps.store_id = s.id
	join products p on p.id = ps.product_id
	set price = if(left(address_name,1) = 0 , price + 100, price +200)
	where a.`name` = address_name;
end //
delimiter ;
CALL udp_update_product_price('07 Armistice Parkway');
SELECT name, price FROM products WHERE id = 15;

CALL udp_update_product_price('1 Cody Pass');
SELECT name, price FROM products WHERE id = 17;






 
 
