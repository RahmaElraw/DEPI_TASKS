use StoreDB

-- Customer activity log
CREATE TABLE sales.customer_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    action VARCHAR(50),
    log_date DATETIME DEFAULT GETDATE()
);

-- Price history tracking
CREATE TABLE production.price_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date DATETIME DEFAULT GETDATE(),
    changed_by VARCHAR(100)
);

-- Order audit trail
CREATE TABLE sales.order_audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    customer_id INT,
    store_id INT,
    staff_id INT,
    order_date DATE,
    audit_timestamp DATETIME DEFAULT GETDATE()
);



--1.Create a non-clustered index on the email column in the sales.
--customers table to improve search performance when looking up customers by email.
create nonclustered index IX_Email
on sales.customers(email)



--2.Create a composite index on the production.products table that includes category_id
--and brand_id columns to optimize searches that filter by both category and brand.
create nonclustered index IX_Cat_Brand
on production.products(category_id,brand_id)



--3.Create an index on sales.orders table for the order_date column and include
--customer_id, store_id, and order_status as included columns to improve reporting queries.
create nonclustered index IX_orders
on sales.orders(order_date)
include (customer_id,store_id,order_status)



--4.Create a trigger that automatically inserts a welcome record into a 
--customer_log table whenever a new customer is added to sales.customers. 
--(First create the log table, then the trigger)
create trigger T_customer
on sales.customers
after insert 
as begin
    insert into sales.customer_log (customer_id,action)
    select customer_id,'Welcome New Customer'
    from inserted
end




--5.Create a trigger on production.products that logs any changes to the list_price
--column into a price_history table, storing the old price, new price, and change date.
create trigger T_products
on production.products 
after update 
as begin
   if update(list_price)
   begin
       insert into production.price_history(product_id, old_price, new_price, change_date, changed_by)
       select 
        i.product_id,
        d.list_price AS old_price,
        i.list_price AS new_price,
        GETDATE(),
        SYSTEM_USER
        from inserted i
        join deleted d ON i.product_id = d.product_id
   end
end




--6.Create an INSTEAD OF DELETE trigger on production.categories that prevents deletion
--of categories that have associated products. Display an appropriate error message.
create trigger T_cat 
on production.categories 
instead of delete 
as begin
    if exists (
    select 1 from production.products p
    join deleted d on p.category_id=d.category_id
    )
    begin
       print('Cannot delete category that has associated products.') 
       return
    end
    else
    begin
        delete from production.categories 
        where category_id in (select category_id from deleted) 
    end
end





--7.Create a trigger on sales.order_items that automatically reduces the quantity in 
--production. stocks when a new order item is inserted.
create trigger T_order
on sales.order_items 
after insert 
as begin
    update s
    set s.quantity =s.quantity -i.quantity
    from production.stocks s 
    join inserted i on s.product_id=i.product_id
end




--8.Create a trigger that logs all new orders into an order_audit table, 
--capturing order details and the date/time when the record was created.
create trigger T_order2
on sales.orders
after insert
as begin
    insert into sales.order_audit(order_id, customer_id, store_id, staff_id, order_date) 
    select order_id, customer_id, store_id, staff_id, order_date
    from inserted 
end




