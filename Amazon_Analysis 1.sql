-- ASSIGNMENT QUESTIONS


--Q1- Retrieve all columns from the "orders" table.

select * from 
orders 

/*	
Q2- list the names and the price of all products 
    from the "products"table.
*/

select product_name,
	   price
	from products

/* Q3-find orders with a sale amount greater 
   than $100 from the "orders" table.
*/


select order_id ,sale
from orders
where sale >'100'
order by 1 desc
	limit 5;

/* Q4-calculate the total number of customers 
   from the "customers" table.
*/

select count(distinct customer_id)
from customers

/*Q5-list the product in ascending order of their prices 
     from the "products" table.
*/ 

select product_name,price
from products
order by product_name asc;


/*Q6-find total count of orders and total sales by seller_id
*/
select * from orders

select seller_id ,count(order_id)as Total_Ord_id,sum(sale) as Total_Sales
from orders 
group by 1 
	order by 1 desc
	limit 5;


/*Q7-find out total count of products from "products" table
*/

select count(distinct product_id)
from products


/*Q8-find the total count of orders and total sales for category 'furniture'
     and 'Technology'
*/
select * from orders

	
select category,
	            count(distinct order_id) as Total_order_id,
	            sum(sale) as Total_sales
 from orders
where category in ('Furniture','Technology')
group by category ;

/*Q9-find the total number of returns?
*/

select count(*) 
	from returns

/*Q10-find the top 5 product_id and the quantity sold and the revenue genrated
-- Top 5 product_id
-- count of quantity 
-- */
select * from orders

SELECT 
    product_id,
    SUM(quantity) AS total_quantity_sold,
    SUM(quantity * price_per_unit) AS total_revenue_generated
FROM 
    orders
GROUP BY 
    product_id
ORDER BY 
    total_quantity_sold DESC
LIMIT 5;

/* find the top 3 states and the revenue generated having revenue>3000
*/
select 
	state,
	 sum(quantity*price_per_unit)as revenue
from 
	orders
group by 
	state
having sum(quantity*price_per_unit) >'3000'
order  by state desc
limit 3;



-- Analysis day 1 Done


