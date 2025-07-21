USE StoreDB

-- 1. Customer Spending Analysis#
--Write a query that uses variables to find the total amount spent by customer ID 1.
--Display a message showing whether they are a VIP customer (spent > $5000) or regular customer.
declare @Total_Amount decimal(10,2)
declare @Cust_Id int =1
select @Total_Amount=sum(oi.list_price*oi.quantity * (1 - oi.discount))
from [sales].[order_items] oi
join [sales].[orders] o on oi.order_id=o.order_id
where o.customer_id=@Cust_Id
print 'Customer ID is '+cast(@Cust_Id as varchar) 
print 'Total Spent is '+cast(@Total_Amount as varchar)
if @Total_Amount>5000
	begin
		print 'VIP'
	end
else
	begin
		print 'regular'
	end




-- 2. Product Price Threshold Report#
--Create a query using variables to count how many products cost more than $1500. 
--Store the threshold price in a variable and display both the threshold and count in a formatted message.
declare @productCount int
declare @threshold decimal(10,2)=1500
select @productCount=count(*) from [production].[products] where list_price>@threshold
print 'Threshold price is '+cast(@threshold as varchar)
print 'Number of products over threshold is '+cast(@productCount as varchar)




--3. Staff Performance Calculator#
--Write a query that calculates the total sales for staff member ID 2 in the year 2017.
--Use variables to store the staff ID, year, and calculated total. Display the results with appropriate labels.
declare @StaffID int=2
declare @year int=2022
declare @TotalSales decimal(10,2)
select @TotalSales=sum(oi.list_price*oi.quantity * (1 - oi.discount))
from [sales].[order_items] oi
join [sales].[orders] o on oi.order_id=o.order_id
where @StaffID=o.staff_id and @year=year(o.order_date)
print 'Staff ID is '+cast(@StaffID as varchar)
print 'Year is '+cast(@year as varchar)
print 'Total sales is '+cast(@TotalSales as varchar)




--4. Global Variables Information#
--Create a query that displays the current server name, SQL Server version,
--and the number of rows affected by the last statement. Use appropriate global variables.
select @@SERVERNAME as Server_Name ,@@VERSION as ServerVersion ,@@ROWCOUNT as last_affected_rows




--5.Write a query that checks the inventory level for product ID 1 in store ID 1. Use IF statements to display different messages based on stock levels:#
--If quantity > 20: Well stocked
--If quantity 10-20: Moderate stock
--If quantity < 10: Low stock - reorder needed
declare @quantity int
declare @storeId int =1
declare @productId int =1
select @quantity=s.quantity
from [production].[stocks] s 
where s.store_id=1 and s.product_id=1
print 'Store ID is '+cast(@storeId as varchar)
print 'Product ID is '+cast(@productId as varchar)
if @quantity >20
	begin print 'Well stocked'
	end
if @quantity between 10 and 20
	begin print 'Moderate stock'
	end
if @quantity <10
	begin print 'Low stock - reorder needed'
	end




--6.Create a WHILE loop that updates low-stock items (quantity < 5) in batches of 3 products at a time.
--Add 10 units to each product and display progress messages after each batch.
declare @batch int =3
declare @processed int=0
while exists (select top 1* from [production].[stocks] where quantity<50) 
	begin
		update top (@batch) [production].[stocks]
		set quantity=quantity+10
		where quantity<50

		set @processed=@processed+@batch
		print 'Batch of '+cast(@batch as varchar)+' products updated'
		print 'total processed is '+cast(@processed as varchar)
	end





--7. Product Price Categorization#
--Write a query that categorizes all products using CASE WHEN based on their list price:
--Under $300: Budget
--$300-$800: Mid-Range
--$801-$2000: Premium
--Over $2000: Luxury
select p.product_id ,p.product_name,p.list_price,
case 
	when p.list_price <300 then 'Budget'
	when p.list_price between 300 and 800 then 'Mid-Range'
	when p.list_price between 801 and 2000 then 'Premium'
	when p.list_price >2000 then 'Luxury'
end as Price_Category
from [production].[products] p 
order by p.list_price




--8. Customer Order Validation#
--Create a query that checks if customer ID 5 exists in the database. 
--If they exist, show their order count. If not, display an appropriate message.
declare @Customer_Id int =5
declare @Order_Count int
select @Order_Count=count(*) from [sales].[orders]
where @Customer_Id=customer_id
if exists (select 1 from [sales].[orders] where @Customer_Id=customer_id )
begin
	print 'Order Count is '+cast (@Order_Count as varchar)
end
else
begin
	print 'Invalid Customer'
end




--9. Shipping Cost Calculator Function#
--Create a scalar function named CalculateShipping that takes an order total as input and returns shipping cost:
--Orders over $100: Free shipping ($0)
--Orders $50-$99: Reduced shipping ($5.99)
--Orders under $50: Standard shipping ($12.99)
create function CalculateShipping (@OrderTotal decimal(10,2))
returns decimal(10,2)
as
begin
	declare @shipping decimal(10,2)
	if @OrderTotal>100
		set @shipping=0
	else if @OrderTotal between 50 and 99
		set @shipping=5.99
	else
		set @shipping=12.99

	return @shipping
end
select [dbo].[CalculateShipping](30) as ShippingCost




--10. Product Category Function#
--Create an inline table-valued function named GetProductsByPriceRange 
--that accepts minimum and maximum price parameters 
--and returns all products within that price range with their brand and category information.
create function GetProductsByPriceRange(@min_price decimal(10,2),@max_price decimal(10,2))
returns table
as
return (
	select p.category_id,c.category_name,p.brand_id,b.brand_name,p.list_price
	from [production].[products] p
	join [production].[brands] b on p.brand_id=b.brand_id
	join [production].[categories] c on p.category_id=c.category_id
	where p.list_price between @min_price and @max_price
)
--declare @min_price decimal(10,2)
--set @min_price =(select min(list_price) from [production].[products] )
--declare @max_price decimal(10,2)
--set @max_price=(select max(list_price) from [production].[products])
select * from [dbo].[GetProductsByPriceRange](500,1000)




--11. Customer Sales Summary Function#
--Create a multi-statement function named GetCustomerYearlySummary that takes a customer ID
--and returns a table with yearly sales data including total orders, total spent, and average order value for each year.
create function GetCustomerYearlySummary(@CustomerID int)
returns @summary table(sales_year int ,total_order int,total_spent decimal(10,2),avg_order decimal(10,2))
as
begin
	insert into @summary
	select year(o.order_date),count(distinct o.order_id),sum(oi.quantity*oi.list_price* (1 - oi.discount)),
	avg(oi.quantity*oi.list_price* (1 - oi.discount))
	from [sales].[orders] o
	join [sales].[order_items] oi on o.order_id=oi.order_id
	WHERE o.customer_id = @CustomerID
    GROUP BY YEAR(o.order_date);
	return
end
select * from [dbo].[GetCustomerYearlySummary](1)




--12. Discount Calculation Function#
--Write a scalar function named CalculateBulkDiscount that determines discount percentage based on quantity:
--1-2 items: 0% discount
--3-5 items: 5% discount
--6-9 items: 10% discount
--10+ items: 15% discount
create function CalculateBulkDiscount(@qunt int)
returns decimal(10,2)
as
begin
	declare @discount decimal(10,2) 
	if @qunt between 1 and 2 
		set @discount=0
	else if @qunt between 3 and 5 
		set @discount=0.05
	else if @qunt between 6 and 9 
		set @discount=0.10
    else
		set @discount=0.15

	return @discount
end
select [dbo].[CalculateBulkDiscount](5) as Discount_Calculation
	





--13. Customer Order History Procedure#
--Create a stored procedure named sp_GetCustomerOrderHistory that accepts a customer ID and optional start/end dates.
--Return the customer's order history with order totals calculated.
create proc sp_GetCustomerOrderHistory
	@customer_id int,
	@startDate date=null,
	@endDate date =null
as
begin
	select o.customer_id,o.order_id,o.order_date,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_total
	from [sales].[orders] o
	join [sales].[order_items] oi on o.order_id=oi.order_id
	where o.customer_id=@customer_id
	 AND (@startDate IS NULL OR o.order_date >= @startDate)
     AND (@endDate IS NULL OR o.order_date <= @endDate)
	group by o.customer_id,o.order_id,o.order_date
end
exec [dbo].[sp_GetCustomerOrderHistory] @customer_id=1, @startDate = '2017-01-01';





--14. Inventory Restock Procedure#
--Write a stored procedure named sp_RestockProduct with input parameters for store ID, product ID, and restock quantity.
--Include output parameters for old quantity, new quantity, and success status.
create proc sp_RestockProduct 
	@storeId int,
	@productId int,
	@restock_quantity int,
	@oldquantity int output,
	@newQuantity int output,
	@succesStatus bit output
as
begin
	if exists (select 1 from [production].[stocks] where store_id=@storeId and product_id=@productId)
	begin 
		select @oldquantity=quantity from [production].[stocks] 
		where store_id=@storeId and product_id=@productId

		update [production].[stocks] set quantity = quantity+@restock_quantity
		where store_id=@storeId and product_id=@productId

		select @newQuantity=quantity from [production].[stocks] 
		where store_id=@storeId and product_id=@productId

		set @succesStatus=1
	end
	else
	begin set @succesStatus=0 end
end
declare @oldquantity int ,@newQuantity int ,@succesStatus bit 
exec [dbo].[sp_RestockProduct] @storeId=1,@productId =1,@restock_quantity =20,
	@oldquantity =@oldquantity output,
	@newQuantity =@newQuantity output,
	@succesStatus =	@succesStatus  output
print 'Old Quantity :'+cast(@oldquantity as varchar)
print 'New Quantity :'+cast(@newQuantity as varchar)
print 'Succes Status :'+
	case @succesStatus
		when 1 then 'Yes'
		else 'No'
	end





--15. Order Processing Procedure#
--Create a stored procedure named sp_ProcessNewOrder that handles complete order creation with proper transaction control and error handling.
--Include parameters for customer ID, product ID, quantity, and store ID
CREATE PROCEDURE sp_ProcessNewOrder
    @customer_id INT,
    @product_id INT,
    @quantity INT,
    @store_id INT
AS
BEGIN
    DECLARE @order_id INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO sales.orders(customer_id, order_status, order_date, required_date, store_id, staff_id)
        VALUES (@customer_id, 1, GETDATE(), DATEADD(DAY, 7, GETDATE()), @store_id, 1);

        SET @order_id = SCOPE_IDENTITY();

        DECLARE @list_price DECIMAL(10,2);

        SELECT @list_price = list_price
        FROM production.products
        WHERE product_id = @product_id;

        INSERT INTO sales.order_items(order_id, item_id, product_id, quantity, list_price, discount)
        VALUES (@order_id, 1, @product_id, @quantity, @list_price, 0);

        COMMIT;
        PRINT 'Order processed successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END




--16. Dynamic Product Search Procedure#
--Write a stored procedure named sp_SearchProducts that builds dynamic SQL based on optional parameters:
--product name search term, category ID, minimum price, maximum price, and sort column.
CREATE PROCEDURE sp_SearchProducts
    @search_term VARCHAR(255) = NULL,
    @category_id INT = NULL,
    @min_price DECIMAL(10,2) = NULL,
    @max_price DECIMAL(10,2) = NULL,
    @sort_col VARCHAR(50) = 'product_name'
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX) = N'
        SELECT p.product_id, p.product_name, p.list_price, c.category_name
        FROM production.products p
        JOIN production.categories c ON p.category_id = c.category_id
        WHERE 1=1';

    IF @search_term IS NOT NULL
        SET @sql += ' AND p.product_name LIKE ''%' + @search_term + '%''';
    IF @category_id IS NOT NULL
        SET @sql += ' AND p.category_id = ' + CAST(@category_id AS VARCHAR);
    IF @min_price IS NOT NULL
        SET @sql += ' AND p.list_price >= ' + CAST(@min_price AS VARCHAR);
    IF @max_price IS NOT NULL
        SET @sql += ' AND p.list_price <= ' + CAST(@max_price AS VARCHAR);

    SET @sql += ' ORDER BY ' + QUOTENAME(@sort_col);

    EXEC sp_executesql @sql;
END




--17. Staff Bonus Calculation System#
--Create a complete solution that calculates quarterly bonuses for all staff members.
--Use variables to store date ranges and bonus rates. Apply different bonus percentages based on sales performance tiers.
DECLARE @start_date DATE = '2022-01-01';
DECLARE @end_date DATE = '2022-03-31'; 
DECLARE @bonus_rate1 DECIMAL(4,2) = 0.05; -- for sales > 10000
DECLARE @bonus_rate2 DECIMAL(4,2) = 0.03; -- for sales > 5000
DECLARE @bonus_rate3 DECIMAL(4,2) = 0.01; -- others

SELECT 
    s.staff_id,
    s.first_name,
    s.last_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales,
    CASE 
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 10000 THEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonus_rate1
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 5000 THEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonus_rate2
        ELSE SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonus_rate3
    END AS bonus
FROM sales.staffs s
JOIN sales.orders o ON s.staff_id = o.staff_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.order_date BETWEEN @start_date AND @end_date
GROUP BY s.staff_id, s.first_name, s.last_name;




--18. Smart Inventory Management#
--Write a complex query with nested IF statements that manages inventory restocking.
--Check current stock levels and apply different reorder quantities based on product categories and current stock levels.
select s.store_id,s.product_id,p.product_name,p.category_id,s.quantity,
 CASE 
        WHEN s.quantity < 5 AND p.category_id = 1 THEN 'Reorder 50'
        WHEN s.quantity < 10 AND p.category_id = 2 THEN 'Reorder 30'
        WHEN s.quantity < 20 THEN 'Reorder 10'
        ELSE 'Stock OK'
 END AS Action
from [production].[products] p
join [production].[stocks] s on p.product_id=s.product_id




--19. Customer Loyalty Tier Assignment#
--Create a comprehensive solution that assigns loyalty tiers to customers based on their total spending.
--Handle customers with no orders appropriately and use proper NULL checking.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    ISNULL(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_spent,
    CASE 
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) IS NULL THEN 'No Orders'
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 10000 THEN 'Platinum'
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 5000 THEN 'Gold'
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 1000 THEN 'Silver'
        ELSE 'Bronze'
    END AS loyalty_tier
FROM [sales].[customers] c
LEFT JOIN [sales].[orders] o ON c.customer_id = o.customer_id
LEFT JOIN [sales].[order_items] oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;





--20. Product Lifecycle Management#
--Write a stored procedure that handles product discontinuation including checking for pending orders,
--optional product replacement in existing orders, clearing inventory, and providing detailed status messages.
CREATE PROCEDURE sp_DiscontinueProduct
    @product_id INT,
    @replacement_product_id INT = NULL
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [sales].[order_items] oi
        JOIN [sales].[orders] o ON oi.order_id = o.order_id
        WHERE oi.product_id = @product_id AND o.order_status IN (1, 2)
    )
    BEGIN
        PRINT 'Cannot discontinue product: it has pending orders.';
        RETURN;
    END

    IF @replacement_product_id IS NOT NULL
    BEGIN
        UPDATE [sales].[order_items]
        SET product_id = @replacement_product_id
        WHERE product_id = @product_id;
    END

    DELETE FROM [production].[stocks] WHERE product_id = @product_id;
    DELETE FROM [production].[products] WHERE product_id = @product_id;

    PRINT 'Product discontinued successfully.';
END






--21. Advanced Analytics Query#
--Create a query that combines multiple advanced concepts to generate a comprehensive sales 
--report showing monthly trends, staff performance, and product category analysis.
WITH MonthlySales AS (
    SELECT 
        month(o.order_date) AS OrderMonth,
        SUM(oi.quantity * oi.list_price) AS TotalRevenue
    FROM [sales].[orders] o
    JOIN [sales].[order_items] oi ON o.order_id = oi.order_id
    GROUP BY month(o.order_date)
),
StaffPerformance AS (
    SELECT 
        o.staff_id,
        s.first_name + ' ' + s.last_name AS StaffName,
        SUM(oi.quantity * oi.list_price) AS StaffRevenue
    FROM [sales].[orders] o
    JOIN [sales].[order_items] oi ON o.order_id = oi.order_id
    JOIN sales.staffs s ON o.staff_id = s.staff_id
    GROUP BY o.staff_id, s.first_name, s.last_name
),
CategoryAnalysis AS (
    SELECT 
        c.category_name,
        SUM(oi.quantity * oi.list_price) AS CategoryRevenue
    FROM sales.order_items oi
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.categories c ON p.category_id = c.category_id
    GROUP BY c.category_name
)
SELECT * FROM MonthlySales;
SELECT * FROM StaffPerformance;
SELECT * FROM CategoryAnalysis;




-- 22. Data Validation System#
--Build a complete data validation system using functions and procedures that ensures data integrity
--when inserting new orders, including customer validation, inventory checking, and business rule enforcement.








