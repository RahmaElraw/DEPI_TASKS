

use StoreDB
-- 1. List all products with list price greater than 1000
select * from [production].[products] 
where list_price >1000;


-- 2. Get customers from "CA" or "NY" states
select * from [sales].[customers]
where state in ('ca' , 'ny');


-- 3. Retrieve all orders placed in 2023
select * from [sales].[orders]
where order_date between '2022-12-30' and '2024-01-01';


-- 4. Show customers whose emails end with @gmail.com
select * from [sales].[customers]
where email like '%@gmail.com';


-- 5. Show all inactive staff
select * from [sales].[staffs]
where active !=1;


-- 6.List top 5 most expensive products
select top 5 * from [production].[products]
order by list_price desc;


-- 7. Show latest 10 orders sorted by date
select top 10 * from [sales].[orders]
order by order_date desc;


-- 8. Retrieve the first 3 customers alphabetically by last name
select top 3 * from [sales].[customers]
order by last_name ;


-- 9. Find customers who did not provide a phone number
select * from [sales].[customers]
where phone is null;


-- 10. Show all staff who have a manager assigned
select * from [sales].[staffs]
where manager_id is not null;


-- 11. Count number of products in each category
select category_id, COUNT(*) AS COUNT_Products
from [production].[products]
group by category_id;


-- 12. Count number of customers in each state
select state,count(*) as Num_Of_Customers
from [sales].[customers]
group by state;


-- 13. Get average list price of products per brand
select brand_id, avg(list_price) as AVGPRICE
from [production].[products]
group by brand_id;


-- 14. Show number of orders per staff
select staff_id , count(*) as NUM_Of_Order
from [sales].[orders]
group by staff_id;


-- 15. Find customers who made more than 2 orders
select customer_id ,count(*) as Num_Of_Orders
from [sales].[orders]
group by customer_id
having count(*) >2;


-- 16. Products priced between 500 and 1500
select * from [production].[products]
where list_price between 500 and 1500;


-- 17. Customers in cities starting with "S"
select * from [sales].[customers]
where city like 's%';


-- 18. Orders with order_status either 2 or 4
select * from [sales].[orders]
where order_status in ('2' , '4');

select * from [sales].[orders]
where order_status =2 or order_status =4; 


-- 19. Products from category_id IN (1, 2, 3)
select * from [production].[products]
where category_id in ('1' , '2' , '3');


-- 20. Staff working in store_id = 1 OR without phone number
select * from [sales].[staffs]
where store_id = 1 or phone is null; 

