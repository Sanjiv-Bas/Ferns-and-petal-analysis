create database fernpet_analysis;
use fernpet_analysis;
select * from customers;
select * from Orders;
select * from Products;

alter table customers
modify customer_ID varchar(20);

alter table customers
change column `Name` Cus_name varchar(100);

alter table customers
modify city varchar(50);

alter table customers
Change column contact_Number Con_Number varchar(100);

alter table customers
modify Email varchar(50);

alter table customers
modify Gender varchar(50);

alter table customers
modify Address varchar(250);

alter table orders
modify customer_id varchar(20);

alter table orders
change column Product_id Product_ID varchar(20);

alter table orders
modify Quantity int;

set SQL_SAFE_UPDATES = 0;

update orders
set Order_date = str_to_date(Order_Date,"%d-%m-%Y");

alter table orders
modify Order_Date date;

alter table orders
modify Order_Time Time;


update orders
set Delivery_Date = str_to_date(Delivery_Date, "%d-%m-%Y");

alter table orders
modify Delivery_Date date;

alter table orders
modify Delivery_Time Time;

alter table products
change column Product_ID Product_ID varchar(50);

alter table products
Modify Product_Name varchar(50);

alter table products
Modify Category varchar(50);

alter table products
change column `Price (INR)` Price bigint;

alter table products
modify occasion varchar(50);

alter table products
change `Description` Descr varchar(100);

create view fernpet as 
select customers.customer_ID, customers.Cus_name, customers.city, customers.Con_Number, customers.Email, customers.Gender, customers.Address,
orders.Order_ID,  orders.Quantity, orders.Order_Date, orders. Order_Time, orders.Delivery_Date,
orders.Delivery_Time, orders.Location, products.Product_ID, products.Product_Name, products.Category, products.Price,
products.occasion, products.Descr
from customers
inner join orders on
customers.customer_ID = orders.Customer_ID
inner join products on
orders.Product_ID = products.Product_ID;

select * from fernpet;

-- Identify the overall revenue
select sum(orders.quantity*products.Price)
from orders
inner join products on
orders.Product_ID = products.Product_ID;

-- Evaluate the time taken for orders to be delivered.
select avg(datediff(delivery_date,order_date)) as AverageDelivery
from orders;

-- Examine how sales fluctuate across the months of 2023
select monthname(order_date), sum(orders.quantity*products.price) as Revenue
from orders
join products on 
orders.Product_ID = products.Product_ID
group by monthname(order_date)
order by Revenue desc;


-- 	Determine which products are the top revenue generators.
select products.Product_Name, sum(orders.quantity*products.price) as Revenue
from orders
join products on
orders.Product_ID = products.Product_ID
group by Product_Name
order by sum(orders.quantity*products.price) desc
limit 5;

-- Understand how much customers are spending on average.
select avg(orders.Quantity*products.Price) as Averagespending
from orders
join products on
orders.Product_ID = products.Product_ID;

-- Track the sales performance of top 5 products.
select products.Product_Name, count(orders.order_ID) as OrderCount
from orders
join products on
orders.product_ID = Products.product_ID
group by products.product_Name
order by OrderCount desc
limit 5;

-- Find out which cities are placing the highest number of orders.
select customers.city, count(orders.order_ID)
from customers
join orders on
customers.customer_ID = orders.customer_id
group by customers.city
order by count(orders.order_ID) desc
limit 10;

-- Analyze if higher order quantities impact delivery times
select 
sum(orders.quantity), hour(orders.Order_time) as hours
from orders
group by hours
order by sum(orders.quantity) desc;

-- Compare revenue generated across different occasions.
select 
Products.Occasion, sum(orders.quantity*products.price) as Revenue
from orders
join products on
orders.Product_ID = products.Product_ID
group by Products.Occasion;

-- Identify which products are most popular during specific occasions.
with fern as (
select 
Products.Product_Name, sum(orders.quantity*products.price) as Revenue,Products.occasion
from orders
join products on
orders.Product_ID = products.Product_ID
group by Products.Product_Name,Products.occasion
order by Revenue desc
)
select * from fern 
where occasion = "Diwali";
