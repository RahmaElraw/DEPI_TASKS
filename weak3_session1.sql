use StoreDB

-- 1.Write a query that classifies all products into price categories:
--   Products under $300: "Economy"
--   Products $300-$999: "Standard"
--   Products $1000-$2499: "Premium"
--   Products $2500 and above: "Luxury"
select product_id,product_name,list_price,
case
	when list_price<300 then 'Economy'
	when list_price between 300 and 999 then 'Standard'
    when list_price between 1000 and 2499 then 'Premium'
	else 'Luxury'
end as Price_Categories
from [production].[products]
order by list_price;


-- 2.Create a query that shows order processing information with user-friendly status descriptions:
--  Status 1: "Order Received" Status 2: "In Preparation" Status 3: "Order Cancelled" Status 4: "Order Delivered"
--  Also add a priority level:
--  Orders with status 1 older than 5 days: "URGENT" ,  Orders with status 2 older than 3 days: "HIGH" All other orders: "NORMAL"
select order_id,order_status,
case order_status
	when 1 then 'Order Received'
	when 2 then 'In Preparation'
	when 3 then 'Order Cancelled'
	when 4 then 'Order Delivered'
end as Status_Descriptions,
case 
	when order_status=1 and DATEDIFF(day,order_date,getdate())>5 then 'URGENT'
	when order_status=2 and DATEDIFF(day,order_date,getdate())>3 then 'HIGH'
	else 'NORMAL'
end as Priority_Level
from [sales].[orders];



-- 3.Write a query that categorizes staff based on the number of orders they've handled:
-- 0 orders: "New Staff" ,1-10 orders: "Junior Staff" ,11-25 orders: "Senior Staff" ,26+ orders: "Expert Staff"
select s.staff_id,s.first_name,s.last_name ,count(o.order_id) as Order_Count,
case 
	when count(o.order_id)=0 then 'New Staff'
	when count(o.order_id)between 1 and 10 then 'Junior Staff'
	when count(o.order_id) between 11 and 25 then 'Senior Staff'
	else 'Expert Staff'
end as Staff_Level
from [sales].[staffs] s
left join [sales].[orders] o on s.staff_id=o.staff_id
group by s.staff_id,s.first_name,s.last_name;



-- 4.Create a query that handles missing customer contact information:
-- Use ISNULL to replace missing phone numbers with "Phone Not Available"
-- Use COALESCE to create a preferred_contact field (phone first, then email, then "No Contact Method")
-- Show complete customer information
 select * ,
 COALESCE(phone,email,'No Contact Method') as Available_contact ,
 ISNULL(phone,'Phone Not Available') as Current_phone
 from [sales].[customers]


 
--5. Write a query that safely calculates price per unit in stock:
--   Use NULLIF to prevent division by zero when quantity is 0
--   Use ISNULL to show 0 when no stock exists
--   Include stock status using CASE WHEN
--   Only show products from store_id = 1
select s.store_id,p.product_id,p.list_price,s.quantity,
ISNULL(p.list_price/nullif(quantity,0),0) as Unit_Price,
case 
	when s.quantity =0 then 'Out of stock'
	else 'In stock'
end as Stock_Status
from [production].[stocks] s
join [production].[products] p on s.product_id=p.product_id
where s.store_id=1;



-- 6.Create a query that formats complete addresses safely:
--   Use COALESCE for each address component
--   Create a formatted_address field that combines all components
--   Handle missing ZIP codes gracefully
select customer_id,first_name+' '+last_name as Customer_Name,
COALESCE(street,'No street') as street,
COALESCE(city,'No city') as city,
COALESCE(state,'No state') as state,
COALESCE(zip_code,'No code') as zip_code,

	COALESCE(street,'No street') +'/ '+
	COALESCE(city,'No city')+'/ '+
	COALESCE(state,'No state')+'/ '+
	COALESCE(zip_code,'No code')
	as Full_Adress
from [sales].[customers];



--7.Use a CTE to find customers who have spent more than $1,500 total:
-- Create a CTE that calculates total spending per customer
-- Join with customer information
-- Show customer details and spending
-- Order by total_spent descending
with Customer_Spending as
( select o.customer_id,sum(oi.quantity*oi.list_price) as total_spending
from [sales].[orders] o
join [sales].[order_items] oi on o.order_id=oi.order_id
group by o.customer_id
)
select c.*,cs.total_spending
from Customer_Spending cs
join [sales].[customers] c on cs.customer_id=c.customer_id 
where cs.total_spending>1500
order by cs.total_spending desc;



--8.Create a multi-CTE query for category analysis:
--  CTE 1: Calculate total revenue per category
--  CTE 2: Calculate average order value per category
--  Main query: Combine both CTEs
--  Use CASE to rate performance: >$50000 = "Excellent", >$20000 = "Good", else = "Needs Improvement"
with Category_Revenue as
( select c.category_id,c.category_name,sum(oi.list_price*oi.quantity) as Total_Revenue
from [production].[products] p
join [production].[categories] c on p.category_id=c.category_id 
join [sales].[order_items] oi on p.product_id=oi.product_id
group by c.category_id,c.category_name
),
Category_Avg_Order as
( select p.category_id,avg(oi.list_price*oi.quantity)as AVG_Order
from [production].[products] p
join [sales].[order_items] oi on p.product_id=oi.product_id
group by p.category_id
)
select r.category_id,r.category_name,r.Total_Revenue,o.AVG_Order,
case 
	when r.Total_Revenue <20000 then 'Needs Improvement'
	when r.Total_Revenue between 20000 and 50000 then 'Good'
	else 'Excellent'
end as Rate_Performance
from Category_Revenue r
join Category_Avg_Order o on r.category_id=o.category_id
order by category_id



-- 9.Use CTEs to analyze monthly sales trends:
--   CTE 1: Calculate monthly sales totals
--   CTE 2: Add previous month comparison
--   Show growth percentage
with Total_Monthly_Sales as 
(select MONTH(o.order_date) as OrderMonth,year(o.order_date)as OrderYear,sum(oi.quantity*oi.list_price)as Monthly_Total
from [sales].[order_items] oi
join [sales].[orders] o on oi.order_id=o.order_id
group by MONTH(o.order_date),year(o.order_date)
),
previous_Month as
(select MONTH(o.order_date) as OrderMonth,year(o.order_date)as OrderYear,sum(oi.quantity*oi.list_price)as Monthly_Total
from [sales].[order_items] oi
join [sales].[orders] o on oi.order_id=o.order_id
group by MONTH(o.order_date),year(o.order_date)
)
select curr.OrderMonth,curr.OrderYear,curr.Monthly_Total as current_sales,
prev.Monthly_Total as previous_sales,
(((curr.Monthly_Total-prev.Monthly_Total)*100.0)/nullif(prev.Monthly_Total,0)) as growth_percentage
from Total_Monthly_Sales curr
left join previous_Month prev on ((curr.OrderMonth=prev.OrderMonth+1 and curr.OrderYear=prev.OrderYear)
                                  or (curr.OrderMonth=1 and prev.OrderMonth=12 and curr.OrderYear=prev.OrderYear+1))



-- 10.Create a query that ranks products within each category:
--    Use ROW_NUMBER() to rank by price (highest first)
--    Use RANK() to handle ties
--    Use DENSE_RANK() for continuous ranking
--    Only show top 3 products per category
with Rank_Products as (
select c.category_id,c.category_name,p.product_name,oi.list_price,
ROW_NUMBER()over(partition by c.category_id order by oi.list_price desc) as Row_Num,
rank()over(partition by c.category_id order by oi.list_price desc) as Rank,
DENSE_RANK()over(partition by c.category_id order by oi.list_price desc) as Dense_Rank
from [production].[categories] c
join [production].[products] p on c.category_id=p.category_id
join [sales].[order_items]oi on p.product_id=oi.product_id
)
select * 
from Rank_Products
where Row_Num<=3;



-- 11.Rank customers by their total spending:
--    Calculate total spending per customer
--    Use RANK() for customer ranking
--    Use NTILE(5) to divide into 5 spending groups
--    Use CASE for tiers: 1="VIP", 2="Gold", 3="Silver", 4="Bronze", 5="Standard"
with spending as(
select c.first_name+' '+c.last_name as Customer_Name,sum(oi.list_price) as Customer_Spending
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
join [sales].[order_items] oi on o.order_id=oi.order_id
group by c.first_name,c.last_name )
select * ,
RANK()over(order by Customer_Spending desc) as Rank,
NTILE(5)over(order by Customer_Spending desc) as Spending_Groups,
case NTILE(5)over(order by Customer_Spending desc)
	when 1 then 'VIP'
	when 2 then 'Gold'
	when 3 then 'Silver'
	when 4 then 'Bronze'
	when 5 then 'Standard'
end as Tiers
from spending;




--12.Create a comprehensive store performance ranking:
--   Rank stores by total revenue
--   Rank stores by number of orders
--   Use PERCENT_RANK() to show percentile performance
with Revenue as (
select s.store_id,s.store_name,sum(oi.quantity*oi.list_price) as Total_Revenue,count(DISTINCT o.order_id)as Order_Count
from [sales].[stores] s
join [sales].[orders] o on s.store_id=o.store_id
join [sales].[order_items] oi on o.order_id=oi.order_id
group by s.store_id,s.store_name
)
select * , 
RANK()over(order by Total_Revenue ) as Revenue_Rank,
RANK()over(order by Order_Count ) as Order_Rank,
PERCENT_RANK()over(order by Total_Revenue) as Revenue_percentile
from Revenue ;



-- 13.Create a PIVOT table showing product counts by category and brand:
--    Rows: Categories
--    Columns: Top 4 brands (Electra, Haro, Trek, Surly)
--    Values: Count of products
select * from (
select p.product_id,c.category_name,b.brand_name
from [production].[products] p
join [production].[categories] c on p.category_id=c.category_id
join [production].[brands] b on p.brand_id=b.brand_id
WHERE b.brand_name IN ('Zara', 'Puma', 'Gap', 'Hollister')
)as source_table
pivot (
count(product_id) for brand_name in ([Zara], [Puma], [Gap], [Hollister]) 
)as pivot_table;



-- 14.Create a PIVOT showing monthly sales revenue by store:
--    Rows: Store names
--    Columns: Months (Jan through Dec)
--    Values: Total revenue
--    Add a total column
select * from
( select s.store_name,MONTH(o.order_date) as order_month,sum(oi.quantity*oi.list_price) as Revenue
from [sales].[orders] o 
join [sales].[order_items] oi on o.order_id=oi.order_id
join [sales].[stores] s on s.store_id=o.store_id
group by s.store_name,MONTH(o.order_date)
) as souce_table
pivot (
sum(Revenue) for order_month in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) as pivot_table;




--15.PIVOT order statuses across stores:
--   Rows: Store names
--   Columns: Order statuses (Pending, Processing, Completed, Rejected)
--   Values: Count of orders
select * from
(select o.order_id,s.store_name,
case o.order_status
when 1 then 'Pending'
when 2 then 'Processing'
when 3 then 'Rejected'
when 4 then 'Completed'
end as Status
from [sales].[orders] o
join [sales].[stores] s on o.store_id=s.store_id
) as source
pivot (
count(order_id) for  Status in([Pending],[Processing],[Completed],[Rejected])
)as pivot_table;




--16.Create a PIVOT comparing sales across years:
--   Rows: Brand names
--   Columns: Years (2016, 2017, 2018)
--   Values: Total revenue
--   Include percentage growth calculations
select * from
(select b.brand_name,YEAR(o.order_date) as Order_Year,sum(oi.list_price*oi.quantity) as Revenue
from [production].[products] p
join [sales].[order_items] oi on p.product_id=oi.product_id
join [production].[brands] b on p.brand_id=b.brand_id
join [sales].[orders] o on o.order_id=oi.order_id
where YEAR(o.order_date) in (2022,2023,2024)
group by b.brand_name,YEAR(o.order_date)
 )as source_table
 pivot ( sum(Revenue) for Order_Year in ([2022],[2023],[2024])
 )as pivot_table;
 

 -- total answer
WITH brand_sales_per_year AS (
    SELECT 
        b.brand_name,
        YEAR(o.order_date) AS sales_year,
        SUM(oi.quantity * oi.list_price) AS total_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE YEAR(o.order_date) IN (2022, 2023, 2024)
    GROUP BY b.brand_name, YEAR(o.order_date)
)
SELECT 
    brand_name,
    ISNULL([2016], 0) AS Revenue_2016,
    ISNULL([2017], 0) AS Revenue_2017,
    ISNULL([2018], 0) AS Revenue_2018,
    CASE 
        WHEN ISNULL([2016], 0) = 0 THEN NULL
        ELSE ROUND((([2017] - [2016]) * 100.0) / [2016], 2)
    END AS Growth_2017,
    CASE 
        WHEN ISNULL([2017], 0) = 0 THEN NULL
        ELSE ROUND((([2018] - [2017]) * 100.0) / [2017], 2)
    END AS Growth_2018
FROM (
    SELECT 
        brand_name,
        sales_year,
        total_revenue
    FROM brand_sales_per_year
) AS SourceTable
PIVOT (
    SUM(total_revenue)
    FOR sales_year IN ([2016], [2017], [2018])
) AS PivotResult
ORDER BY brand_name;




--17.Use UNION to combine different product availability statuses:
--   Query 1: In-stock products (quantity > 0)
--   Query 2: Out-of-stock products (quantity = 0 or NULL)
--   Query 3: Discontinued products (not in stocks table)
select p.product_id,p.product_name,'In-stock' as Status
from [production].[products] p
join [production].[stocks] s on p.product_id=s.product_id
where s.quantity>0
union 
select p.product_id,p.product_name,'Out-of-stock' as Status
from [production].[products] p
join [production].[stocks] s on p.product_id=s.product_id
where ISNULL(s.quantity,0)=0
union 
select  p.product_id,p.product_name,'Discontinued' as Status
from [production].[products] p
where NOT EXISTS (
    SELECT 1 FROM production.stocks s WHERE s.product_id = p.product_id
);




--18.Use INTERSECT to find loyal customers:
--   Find customers who bought in both 2017 AND 2018
--   Show their purchase patterns
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,o.order_id,YEAR(o.order_date) as order_year
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where c.customer_id in (
select distinct customer_id from [sales].[orders] where year(order_date)=2022
INTERSECT
select distinct customer_id from [sales].[orders] where year(order_date)=2023
);




--19.Use multiple set operators to analyze product distribution:
--   INTERSECT: Products available in all 3 stores
select s.product_id  from [production].[stocks] s where s.store_id=1
INTERSECT
select s.product_id  from [production].[stocks] s where s.store_id=2
INTERSECT
select s.product_id  from [production].[stocks] s where s.store_id=3
--   EXCEPT: Products available in store 1 but not in store 2
select s.product_id  from [production].[stocks] s where s.store_id=1
EXCEPT
select s.product_id  from [production].[stocks] s where s.store_id=2
--   UNION: Combine above results with different labels
select s.product_id ,'in all stores' as lable from [production].[stocks] s where s.store_id=1
INTERSECT
select s.product_id ,'in all stores' as lable from [production].[stocks] s where s.store_id=2
INTERSECT
select s.product_id ,'in all stores' as lable from [production].[stocks] s where s.store_id=3
union
select s.product_id ,'in store 1 only' as lable from [production].[stocks] s where s.store_id=1
EXCEPT
select s.product_id ,'in store 1 only' as lable from [production].[stocks] s where s.store_id=2




-- 20.Complex set operations for customer retention:
--    Find customers who bought in 2022 but not in 2023 (lost customers)
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'lost customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date)=2022
except 
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'lost customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date)=2023
--    Find customers who bought in 2023 but not in 2022 (new customers)
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'new customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date)=2023
except 
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'new customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date)=2022
--    Find customers who bought in both years (retained customers)
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'retained customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date) =2022
intersect 
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'retained customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date) =2023
--    Use UNION ALL to combine all three groups
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'lost customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date)=2022
except 
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'lost customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date)=2023

union all

select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'new customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date)=2023
except 
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'new customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date)=2022

union all

select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'retained customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date) =2022
intersect 
select c.customer_id,c.first_name+' '+c.last_name as Customer_Name,YEAR(o.order_date) as Order_Year,
'retained customers' as Status 
from [sales].[customers] c
join [sales].[orders] o on c.customer_id=o.customer_id
where YEAR(o.order_date) =2023