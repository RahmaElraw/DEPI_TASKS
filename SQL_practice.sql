use AdventureWorks2022


--1.1 List all employees hired after January 1, 2012, 
--showing their ID, first name, last name, and hire date, ordered by hire date descending.
select e.BusinessEntityID,e.HireDate,e.Gender,e.JobTitle
from [HumanResources].[Employee] e
where e.HireDate> '2012-01-01'
order by e.HireDate 



--1.2 List products with a list price between $100 and $500, showing product ID, name,
--list price, and product number, ordered by list price ascending.
select p.ProductID,p.Name,p.ListPrice,p.ProductNumber
from [Production].[Product] p
where p.ListPrice between 100 and 500
order by p.ListPrice asc




--1.3 List customers from the cities 'Seattle' or 'Portland', showing customer ID, first name, 
--last name, and city, using appropriate joins.
select c.CustomerID ,p.FirstName,p.LastName,a.City
FROM Sales.Customer c
JOIN Person.Person p 
    ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea 
    ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address a 
    ON bea.AddressID = a.AddressID
where a.City in ('Seattle' ,'Portland')



--1.4 List the top 15 most expensive products currently being sold, showing name, list price, product number,
--and category name, excluding discontinued products.
select top 15 c.Name as cat_name,p.ListPrice,p.ProductNumber,p.Name as product_Name
from [Production].[ProductCategory] c
join [Production].[Product] p on p.ProductSubcategoryID=c.ProductCategoryID
join [Production].[ProductCostHistory] pc on p.ProductID=pc.ProductID
order by p.ListPrice desc




--2.1 List products whose name contains 'Mountain' and color is 'Black',
--showing product ID, name, color, and list price.
select p.ProductID,p.Name,p.Color,p.ListPrice
from [Production].[Product] p
where p.Name like '%Mountain%' and p.Color='Black'



--2.2 List employees born between January 1, 1970, and December 31, 1985, showing full name
-- birth date, and age in years.
select e.BirthDate,datediff(year,e.BirthDate,GETDATE()) as age,e.Gender,e.JobTitle
from [HumanResources].[Employee] e
where e.BirthDate between '1970-01-01' and '1985-12-31' 




--2.3 List orders placed in the fourth quarter of 2013,
--showing order ID, order date, customer ID, and total due.
select so.SalesOrderID,so.OrderDate,so.CustomerID,so.TotalDue
from [Sales].[SalesOrderHeader] so
where YEAR(so.OrderDate)='2013' and MONTH(so.OrderDate) in (10,11,12)




--2.4 List products with a null weight but a non-null size,
--showing product ID, name, weight, size, and product number.
select p.ProductID,p.Name,p.Weight,p.Size,p.ProductNumber
from Production.Product p
where p.Weight is null and p.Size is not null



--3.1 Count the number of products by category, ordered by count descending.
select pc.Name as CategoryName,count(p.ProductID) as ProductCount 
from Production.Product p
JOIN Production.ProductSubcategory ps 
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
join Production.ProductCategory pc on ps.ProductCategoryID=pc.ProductCategoryID
group by pc.Name
order by count(p.ProductID) desc




--3.2 Show the average list price by product subcategory, including only subcategories with more than five products.
select psc.Name as Sub_Category_Name,avg(p.ListPrice) as Avg_listPrice,
count(p.ProductID) as ProductCount
from Production.ProductSubcategory psc
join Production.Product p on p.ProductSubcategoryID=psc.ProductSubcategoryID
group by psc.Name
having count(p.ProductID)>5



--3.3 List the top 10 customers by total order count, including customer name.
select top 10 p.firstName,p.LastName ,count(so.SalesOrderID) as OrderCount
from [Sales].[SalesOrderHeader] so
join Sales.Customer c on c.CustomerID=so.CustomerID
join Person.Person p on p.BusinessEntityID=c.PersonID
group by p.firstName,p.LastName
order by count(so.SalesOrderID) desc



--3.4 Show monthly sales totals for 2013, displaying the month name and total amount.
select MONTH(s.OrderDate) as OrderMonth,DATENAME(month,s.OrderDate),count(s.SalesOrderID) as Total_Order_Amount
from [Sales].[SalesOrderHeader] s
where year(s.OrderDate) ='2013'
group by MONTH(s.OrderDate),DATENAME(month,s.OrderDate)




--4.1 Find all products launched in the same year as 'Mountain-100 Black, 42'. 
--Show product ID, name, sell start date, and year.
select p.ProductID,p.Name as ProductName,p.SellStartDate,
YEAR(p.SellStartDate) as launchYear
from Production.Product p
where YEAR(SellStartDate) = (
    SELECT YEAR(SellStartDate)
    FROM Production.Product 
    WHERE Name = 'Mountain-100 Black, 42' )



--4.2 Find employees who were hired on the same date as someone else. 
--Show employee names, shared hire date, and the count of employees hired that day.
select e.NationalIDNumber,e.HireDate,e.BusinessEntityID,
COUNT(*) OVER (PARTITION BY e.HireDate) AS EmployeesHiredSameDay
from [HumanResources].[Employee] e
where  e.HireDate IN (
        SELECT HireDate
        FROM HumanResources.Employee
        GROUP BY HireDate
        HAVING COUNT(*) > 1
    )




--5.1 Create a table named Sales.ProductReviews with columns for 
--review ID, product ID, customer ID, rating, review date, review text, 
--verified purchase flag, and helpful votes. Include appropriate primary key, 
--foreign keys, check constraints, defaults, and a unique constraint on product ID and customer ID.
create table Sales.ProductReviews (
review_ID int primary key identity(1,1),
product_ID int unique,
customer_ID int unique,
rating int check (rating between 1 and 5),
review_date date default getdate(),
review_text varchar(255) not null,
verified_purchase_flag char(1) not null check (verified_purchase_flag in ('Y','N')),
helpful_votes int default 0,
foreign key(customer_ID) references sales.Customer(CustomerID) 
on delete no action on update no action 
 )


--6.1 Add a column named LastModifiedDate to the Production.Product table, with a default value of the current date and time.
alter table Production.Product add LastModifiedDate date default getdate()


--6.2 Create a non-clustered index on the LastName column of the Person.Person table,
--including FirstName and MiddleName.
CREATE NONCLUSTERED INDEX IX_Person_LastName
ON Person.Person (LastName)
INCLUDE (FirstName, MiddleName);


--6.3 Add a check constraint to the Production.Product table to ensure that ListPrice is greater than StandardCost.
select productId from Production.Product
where ListPrice<=StandardCost
update Production.Product set ListPrice=StandardCost+1 where ListPrice<=StandardCost
alter table Production.Product 
add constraint ch_listprice_stander
check (ListPrice > StandardCost)



--7.1 Insert three sample records into Sales.ProductReviews using existing product 
--and customer IDs, with varied ratings and meaningful review text.
insert into Sales.ProductReviews (
product_ID,
customer_ID,
rating,
review_date,
review_text,
verified_purchase_flag,
helpful_votes

) values
( 707, 11000, 5, '2025-07-18', 'Excellent quality and fast delivery!', 'Y', 12),
( 750, 11005, 3, '2025-07-15', 'Average product, could be better.', 'N', 4),
( 800, 11010, 1, '2025-07-10', 'Disappointed with the durability.', 'Y', 2);



--7.2 Insert a new product category named 'Electronics' 
--and a corresponding product subcategory named 'Smartphones' under Electronics.
INSERT INTO Production.ProductCategory (Name)
VALUES ('Electronics');
DECLARE @ElectronicsCategoryID INT;
SELECT @ElectronicsCategoryID = ProductCategoryID
FROM Production.ProductCategory
WHERE Name = 'Electronics';
INSERT INTO Production.ProductSubcategory (ProductCategoryID, Name)
VALUES (@ElectronicsCategoryID, 'Smartphones');
-- to show data
select ps.ProductCategoryID,p.Name as catName,
ps.ProductSubcategoryID,ps.Name as subCatName
from Production.ProductCategory p
join [Production].[ProductSubcategory] ps on p.ProductCategoryID=ps.ProductCategoryID




--7.3 Copy all discontinued products (where SellEndDate is not null) 
--into a new table named Sales.DiscontinuedProducts.
SELECT *
INTO Sales.DiscontinuedProducts
FROM Production.Product
WHERE SellEndDate IS NOT NULL;




--8.1 Update the ModifiedDate to the current date for all products where ListPrice 
--is greater than $1000 and SellEndDate is null.
update Production.Product set ModifiedDate=getdate()
where ListPrice>1000 and SellEndDate is null



--8.2 Increase the ListPrice by 15% for all products in the 'Bikes' category 
--and update the ModifiedDate.
update Production.Product
set ModifiedDate=getdate() ,ListPrice=ListPrice+ListPrice*0.15
where Name='Bikes'



--8.3 Update the JobTitle to 'Senior' plus the existing job title
--for employees hired before January 1, 2010.
update [HumanResources].[Employee] set JobTitle='Senior'+JobTitle
where HireDate <'2010-01-01'



--9.1 Delete all product reviews with a rating of 1 and helpful votes equal to 0.
delete from Sales.ProductReviews where rating=1 and helpful_votes =0

 
 ----------------------------------------------
--9.2 Delete products that have never been ordered, 
--using a NOT EXISTS condition with Sales.SalesOrderDetail.
delete from Production.Product
where NOT EXISTS (
    select 1
    from Sales.SalesOrderDetail sod
    where sod.ProductID = Production.Product.ProductID
);
--------------------------------------------------


--------------------------------------------------------
--9.3 Delete all purchase orders from vendors that are no longer active.
delete from [Purchasing].[Vendor] where ActiveFlag=0
--------------------------------------------------------



--10.1 Calculate the total sales amount by year from 2011 to 2014,
--showing year, total sales, average order value, and order count.
select YEAR(so.OrderDate),sum(so.TotalDue)as Total_sales,
AVG(so.TotalDue) as AVG_Order,count(so.SalesOrderID) as Order_Count
from [Sales].[SalesOrderHeader] so
group by YEAR(so.OrderDate) 
having YEAR(so.OrderDate) between 2011 and 2014




--10.2 For each customer, show customer ID, total orders, total amount, 
--average order value, first order date, and last order date.
select c.CustomerID,count(so.SalesOrderID) as Total_Order ,
sum(so.TotalDue) as Total_Amtount,avg(so.TotalDue) as Avg_Order ,
min(so.OrderDate) as First_Order ,max(so.OrderDate) as Last_Order
from [Sales].[Customer] c
join [Sales].[SalesOrderHeader] so on c.CustomerID=so.CustomerID
group by c.CustomerID




--10.3 List the top 20 products by total sales amount, including product name,
--category, total quantity sold, and total revenue.
select top 20 p.Name as Product_Name,pc.Name as category_Name,
count(po.OrderQty) as Total_Qunt_Sold,sum(po.LineTotal) as Total_Revenue
from [Production].[Product] p
join [Production].[ProductSubcategory] ps on p.ProductSubcategoryID=ps.ProductSubcategoryID
join [Production].[ProductCategory] pc on ps.ProductCategoryID=pc.ProductCategoryID
join [Purchasing].[PurchaseOrderDetail] po on p.ProductID=po.ProductID
group by p.Name,pc.Name
order by sum(po.LineTotal) desc




--10.4 Show sales amount by month for 2013, displaying the month name,
--sales amount, and percentage of the yearly total.
WITH MonthlySales AS (
    SELECT 
        DATENAME(MONTH, OrderDate) AS MonthName,
        MONTH(OrderDate) AS MonthNumber,
        SUM(TotalDue) AS MonthlyTotal
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2013
    GROUP BY DATENAME(MONTH, OrderDate), MONTH(OrderDate)
),
YearTotal AS (
    SELECT SUM(MonthlyTotal) AS TotalForYear FROM MonthlySales
)
SELECT 
    ms.MonthName,
    ms.MonthlyTotal,
    FORMAT(100.0 * ms.MonthlyTotal / yt.TotalForYear, 'N2') + '%' AS PercentOfYear
FROM MonthlySales ms
CROSS JOIN YearTotal yt
ORDER BY ms.MonthNumber;



--11.1 Show employees with their full name, age in years, years of service,
--hire date formatted as 'Mon DD, YYYY', and birth month name.
select p.FirstName+' '+p.LastName as Full_name,
DATEDIFF(year,e.BirthDate,getdate()) as Age,
DATEDIFF(year,e.HireDate,getdate()) as Years_Of_servers,
FORMAT(e.HireDate, 'MMM dd, yyyy') AS HireDateFormatted,
DATENAME(month,e.BirthDate) as Birth_month
from [HumanResources].[Employee] e
join Person.Person p on e.BusinessEntityID=p.BusinessEntityID



--11.2 Format customer names as 'LAST, First M.' (with middle initial),
--extract the email domain, and apply proper case formatting.
select p.LastName+', '+p.FirstName+' '+left(p.MiddleName,1)+'. 'as Customer_Name,
SUBSTRING(EmailAddress, CHARINDEX('@', EmailAddress)+1, LEN(EmailAddress)) AS Email_Domain
from Person.Person p
join [Person].[EmailAddress] e on p.BusinessEntityID=e.BusinessEntityID



--11.3 For each product, show name, weight rounded to one decimal, 
--weight in pounds (converted from grams), and price per pound.
select p.Name as Product_Name,round(p.Weight,1) as Product_weight,
round(p.Weight / 453.592, 2) AS WeightInPounds,p.ListPrice
from Production.Product p



--12.1 List product name, category, subcategory,
--and vendor name for products that have been purchased from vendors.
select p.Name as Product_Name,c.Name as Category_Name,ps.Name as Sub_Category_Name,
v.Name as vendor_Name
from Production.Product p
join Production.ProductSubcategory ps on p.ProductSubcategoryID=ps.ProductSubcategoryID
join Production.ProductCategory c on c.ProductCategoryID=ps.ProductCategoryID
join Purchasing.ProductVendor pv on p.ProductID=pv.ProductID
join Purchasing.Vendor v on v.BusinessEntityID=pv.BusinessEntityID




--12.2 Show order details including order ID, customer name, salesperson name,
--territory name, product name, quantity, and line total.
select soh.SalesOrderID,p.FirstName+' '+p.LastName as Customer_Name,
sp.FirstName+' '+sp.LastName as Salesperson_Name,st.Name as Territory_Name,
pr.Name as Product_Name,sod.OrderQty,sod.LineTotal
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
LEFT JOIN Sales.SalesPerson s ON soh.SalesPersonID = s.BusinessEntityID
LEFT JOIN Person.Person sp ON s.BusinessEntityID = sp.BusinessEntityID
LEFT JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID;




--12.3 List employees with their sales territories, including employee name, 
--job title, territory name, territory group, and sales year-to-date.
select p.FirstName+' '+p.LastName as Employee_Name,
e.JobTitle,st.Name as Territory_Name, st.[Group] as Territory_Group,
st.SalesYTD
from Sales.SalesPerson sp
join HumanResources.Employee e on sp.BusinessEntityID=e.BusinessEntityID
join Person.Person p on e.BusinessEntityID=p.BusinessEntityID
join Sales.SalesTerritory st on st.TerritoryID=sp.TerritoryID




--13.1 List all products with their total sales, including those never sold. 
--Show product name, category, total quantity sold (zero if never sold), 
--and total revenue (zero if never sold).
select p.name as Product_Name,pc.name as Category_Name,
isnull(sum(sod.OrderQty),0) as Total_Quantity,
isnull(sum(sod.LineTotal),0) as Total_Revenue
from Production.Product p
left join Production.ProductSubcategory psc on psc.ProductSubcategoryID=p.ProductSubcategoryID
left join Production.ProductCategory pc on pc.ProductCategoryID=psc.ProductCategoryID
left join sales.SalesOrderDetail sod on sod.ProductID=p.ProductID
group by p.name,pc.Name




--13.2 Show all sales territories with their assigned employees,
--including unassigned territories. Show territory name,
--employee name (null if unassigned), and sales year-to-date.
select st.Name as Territory_Name ,
p.FirstName+' '+p.LastName as Employee_Name,
sp.SalesYTD
from sales.SalesTerritory st
join sales.SalesPerson sp on st.TerritoryID=sp.TerritoryID
join Person.Person p on p.BusinessEntityID=sp.BusinessEntityID



--13.3 Show the relationship between vendors and product categories, 
--including vendors with no products and categories with no vendors.
select  v.Name as VendorName, pc.Name as CategoryName
from Purchasing.Vendor v
LEFT JOIN Purchasing.ProductVendor pv on v.BusinessEntityID = pv.BusinessEntityID
LEFT JOIN Production.Product p on pv.ProductID = p.ProductID
LEFT JOIN Production.ProductSubcategory psc on p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc on psc.ProductCategoryID = pc.ProductCategoryID
group by v.name, pc.name;



--14.1 List products with above-average list price, showing product ID, name, 
--list price, and price difference from the average.
select p.ProductID,p.Name as Product_Name,p.ListPrice,
ListPrice - AVG(ListPrice) OVER () AS PriceDifference
from Production.Product p
where p.listprice >(select avg(ListPrice) from Production.Product)




--14.2 List customers who bought products from the 'Mountain' category, 
--showing customer name, total orders, and total amount spent.
SELECT  p.FirstName + ' ' + ISNULL(p.MiddleName + ' ', '') + p.LastName AS CustomerName,
COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,SUM(sod.LineTotal) AS TotalSpent
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Production.ProductSubcategory psc ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'Mountain'
GROUP BY p.FirstName, p.MiddleName, p.LastName;




--14.3 List products that have been ordered by more than 100 different customers, 
--showing product name, category, and unique customer count.
SELECT p.Name AS ProductName,pc.Name AS Category,
COUNT(DISTINCT soh.CustomerID) AS UniqueCustomerCount
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY p.Name, pc.Name
HAVING COUNT(DISTINCT soh.CustomerID) > 100;
 


--14.4 For each customer, show their order count and their rank among all customers.
select p.FirstName+' '+p.LastName as Full_Name,count(soh.SalesOrderID) as Order_Count,
rank() over(order by count(soh.SalesOrderID) desc) as Customer_Rank
from sales.Customer c
join Person.Person p on p.BusinessEntityID=c.PersonID
join sales.SalesOrderHeader soh on soh.CustomerID=c.CustomerID
group by p.FirstName,p.LastName




--15.1 Create a view named vw_ProductCatalog with product ID, name, product number,
--category, subcategory, list price, standard cost, profit margin percentage,
--inventory level, and status (active/discontinued).
create view vw_ProductCatalog as 
select p.ProductID,p.Name AS ProductName,p.ProductNumber,pc.Name AS Category,
psc.Name AS SubCategory,p.ListPrice,p.StandardCost,
    CASE 
        WHEN p.ListPrice = 0 THEN 0
        ELSE ROUND((p.ListPrice - p.StandardCost) / p.ListPrice * 100, 2)
    END AS ProfitMarginPercent,
    ISNULL(ps.Quantity, 0) AS InventoryLevel,
    CASE 
        WHEN p.SellEndDate IS NULL THEN 'Active'
        ELSE 'Discontinued'
    END AS Status
FROM Production.Product p
LEFT JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN Production.ProductInventory ps ON p.ProductID = ps.ProductID;




--15.2 Create a view named vw_SalesAnalysis with year, month, territory,
--total sales, order count, average order value, and top product name.
create view vw_SalesAnalysis as
select  YEAR(soh.OrderDate) AS SalesYear,MONTH(soh.OrderDate) AS SalesMonth,
st.Name AS Territory,SUM(sod.LineTotal) AS TotalSales,
COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
ROUND(SUM(sod.LineTotal) / COUNT(DISTINCT soh.SalesOrderID), 2) AS AverageOrderValue,
    (
        SELECT TOP 1 p.Name
        FROM Sales.SalesOrderDetail sod2
        JOIN Production.Product p ON sod2.ProductID = p.ProductID
        WHERE sod2.SalesOrderID = soh.SalesOrderID
        ORDER BY sod2.LineTotal DESC
    ) AS TopProduct
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
LEFT JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate), st.Name,soh.SalesOrderID






--15.3 Create a view named vw_EmployeeDirectory with full name, job title, 
--department, manager name, hire date, years of service, email, and phone.
create view vw_EmployeeDirectory as
select
    e.BusinessEntityID,
    p.FirstName + ' ' + ISNULL(p.MiddleName + ' ', '') + p.LastName AS FullName,
    e.JobTitle,
    d.Name AS Department,
    pm.FirstName + ' ' + pm.LastName AS ManagerName,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    ea.EmailAddress,
    pp.PhoneNumber
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID AND edh.EndDate IS NULL
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
LEFT JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
LEFT JOIN Person.Person pm ON m.BusinessEntityID = pm.BusinessEntityID
LEFT JOIN Person.EmailAddress ea ON p.BusinessEntityID = ea.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID;



--15.4 Write three different queries using the views you created, 
--demonstrating practical business scenarios.
SELECT TOP 10 *
FROM vw_ProductCatalog
WHERE Status = 'Active'
ORDER BY ProfitMarginPercent DESC;

SELECT SalesYear, SalesMonth, Territory, TotalSales, OrderCount
FROM vw_SalesAnalysis
WHERE TotalSales > 50000
ORDER BY TotalSales DESC;

SELECT FullName, JobTitle, Department, ManagerName, YearsOfService
FROM vw_EmployeeDirectory
WHERE YearsOfService >= 10
ORDER BY YearsOfService DESC;



--16.1 Classify products by price as 'Premium' (greater than $500), 
--'Standard' ($100 to $500), or 'Budget' (less than $100), 
--and show the count and average price for each category.
select
case
    when p.ListPrice >500 then 'Premium'
    when p.ListPrice between 100 and 500 then 'Standard'
    else 'Budget'
end as Product_Category, count(*) as Product_Count,AVG(p.ListPrice) AVG_Price 
from Production.Product p
where p.ListPrice is not null
group by case
    when p.ListPrice >500 then 'Premium'
    when p.ListPrice between 100 and 500 then 'Standard'
    else 'Budget'
end 



--16.2 Classify employees by years of service as 'Veteran' (10+ years), 
--'Experienced' (5-10 years), 'Regular' (2-5 years), or 'New' (less than 2 years),
--and show salary statistics for each group.
select 
CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 10 THEN 'Veteran'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 5 AND 9 THEN 'Experienced'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 2 AND 4 THEN 'Regular'
        ELSE 'New'
END AS ServiceGroup,
COUNT(*) AS EmployeeCount,
AVG(Rate) AS AvgSalary,
MIN(Rate) AS MinSalary,
MAX(Rate) AS MaxSalary
from HumanResources.Employee e
join HumanResources.EmployeePayHistory eh on eh.BusinessEntityID=e.BusinessEntityID 
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 10 THEN 'Veteran'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 5 AND 9 THEN 'Experienced'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 2 AND 4 THEN 'Regular'
        ELSE 'New'
    END;




--16.3 Classify orders by size as 'Large' (greater than $5000),
--'Medium' ($1000 to $5000), or 'Small' (less than $1000), 
--and show the percentage distribution.
WITH OrderClassified AS (
    SELECT
        SalesOrderID,
        TotalDue,
        CASE 
            WHEN TotalDue > 5000 THEN 'Large'
            WHEN TotalDue BETWEEN 1000 AND 5000 THEN 'Medium'
            ELSE 'Small'
        END AS OrderSize
    FROM Sales.SalesOrderHeader
)
SELECT 
    OrderSize,
    COUNT(*) AS OrderCount,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS PercentageDistribution
FROM OrderClassified
GROUP BY OrderSize;




--17.1 Show products with name, weight (display 'Not Specified' if null),
--size (display 'Standard' if null), and color (display 'Natural' if null).

