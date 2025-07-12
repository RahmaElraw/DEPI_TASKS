use StoreDB

-- 1. Count the total number of products in the database.
select count(*) as Num_Of_Products
from [production].[products];

-- 2. Find the average, minimum, and maximum price of all products.
select 
	avg(list_price) as AveragePrice,
	min(list_price) as MinimumPrice,
	max(list_price) as MaximumPrice
from [production].[products];

-- 3. Count how many products are in each category.
select category_id ,count(*) as productCount
from [production].[products]
group by category_id
order by category_id;

-- 4. Find the total number of orders for each store.
select store_id,count(*) as OrderCount
from [sales].[orders]
group by store_id
order by store_id;

-- 5. Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers.
select
	UPPER(first_name) as FirstName ,
	LOWER(last_name) as LastName
from [sales].[customers]
where customer_id<=10
order by customer_id;

-- 6. Get the length of each product name. Show product name and its length for the first 10 products.
select product_name,Len(product_name) as Name_Lenght
from [production].[products]
where product_id <=10
order by product_id;

-- 7. Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15.
select customer_id, left(phone,3) as AreaCode
from [sales].[customers]
order by customer_id
offset 0 rows fetch next 15 rows only;

-- 8. Show the current date and extract the year and month from order dates for orders 1-10.
select order_id,order_date,
GETDATE() as CurrentDate,
year(order_date) as OrderYear,
MONTH(order_date) as OrderMonth
from [sales].[orders]
order by order_id
offset 0 rows fetch next 10 rows only;

-- 9. Join products with their categories. Show product name and category name for first 10 products.
select p.product_name , c.category_name
from [production].[products] p
join [production].[categories] c on p.category_id=c.category_id
order by p.product_id
offset 0 rows fetch next 10 rows only;

-- 10. Join customers with their orders. Show customer name and order date for first 10 orders.
select c.first_name+' '+c.last_name as Customer_Name,
o.order_date
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
order by c.customer_id
offset 0 rows fetch next 10 rows only;

-- 11. Show all products with their brand names, even if some products don't have brands.Include product name, brand name (show 'No Brand' if null).
select p.product_name,COALESCE(b.brand_name,'No Brand') as Brand_Name
from [production].[products] p
left join [production].[brands] b on p.brand_id=b.brand_id;

-- 12. Find products that cost more than the average product price. Show product name and price.
select product_name ,list_price
from [production].[products]
where list_price >(select avg(list_price) from [production].[products]);

-- 13. Find customers who have placed at least one order. Use a subquery with IN. Show customer_id and customer_name.
select customer_id , first_name+' '+last_name as Customer_Name
from [sales].[customers] 
where customer_id in (select customer_id from [sales].[orders] );

-- 14. For each customer, show their name and total number of orders using a subquery in the SELECT clause.
select first_name+' '+last_name as CustomerName ,
(select count(*) from [sales].[orders] o where c.customer_id=o.customer_id ) as Total_Orders
from [sales].[customers] c;

-- 15. Create a simple view called easy_product_list that shows product name, category name,and price. Then write a query to select all products from this view where price > 100.
CREATE VIEW easy_product_list AS
select p.product_name ,c.category_name ,p.list_price
from [production].[products] p 
join [production].[categories] c on p.category_id =c.category_id;

select * 
from easy_product_list 
where list_price>100;

-- 16. Create a view called customer_info that shows customer ID, full name (first + last), email, and city and state combined. Then use this view to find all customers from California (CA).
CREATE VIEW customer_info AS
select
	customer_id,
	first_name+' '+last_name as Full_Name,
	email,city+' '+state as City_State
from [sales].[customers];

select * 
from customer_info 
where (RIGHT(City_State,2)='CA');

-- 17. Find all products that cost between $50 and $200. Show product name and price, ordered by price from lowest to highest.
select product_name,list_price
from [production].[products]
where list_price between 50 and 200
order by list_price asc;

-- 18. Count how many customers live in each state. Show state and customer count, ordered by count from highest to lowest.
select state ,count(*) as CustomerCount
from [sales].[customers]
group by state
order by count(*) desc;

-- 19. Find the most expensive product in each category. Show category name, product name, and price.
select c.category_name ,p.product_name,p.list_price
from [production].[categories] c
join [production].[products] p on c.category_id=p.category_id
where p.list_price=(select max(p.list_price) from [production].[products] p
	                       where c.category_id=p.category_id );


-- 20. Show all stores and their cities, including the total number of orders from each store. Show store name, city, and order count.
select s.store_name,s.city,count(o.order_id) as OrderCount
from [sales].[stores] s
left join [sales].[orders] o on s.store_id=o.store_id
group by s.store_name,s.city;
