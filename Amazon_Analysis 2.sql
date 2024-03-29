-- Day 02 of SQL Workshop

-- create a new database load the script and press run button

-- JUST PRESS RUN BUTTON

-- first import into products,
-- import into customers
-- import into sellers
-- import into orders
-- import into returns


-- creating customers table 
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
						    customer_id VARCHAR(25) PRIMARY KEY,
						    customer_name VARCHAR(25),
						    state VARCHAR(25)
);

-- creating sellers table 
DROP TABLE IF EXISTS sellers;
CREATE TABLE sellers (
					    seller_id VARCHAR(25) PRIMARY KEY,
					    seller_name VARCHAR(25)
);


-- creating products table 
DROP TABLE IF EXISTS products;
CREATE TABLE products (
					    product_id VARCHAR(25) PRIMARY KEY,
					    product_name VARCHAR(255),
					    Price FLOAT,
					    cogs FLOAT
);



-- creating orders table 
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
					    order_id VARCHAR(25) PRIMARY KEY,
					    order_date DATE,
					    customer_id VARCHAR(25),  -- this is a foreign key from customers(customer_id)
					    state VARCHAR(25),
					    category VARCHAR(25),
					    sub_category VARCHAR(25),
					    product_id VARCHAR(25),   -- this is a foreign key from products(product_id)
					    price_per_unit FLOAT,
					    quantity INT,
					    sale FLOAT,
						seller_id VARCHAR(25),    -- this is a foreign key from sellers(seller_id)
	
					    CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
					    CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),    
					    CONSTRAINT fk_sellers FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);



-- creating returns table 
DROP TABLE IF EXISTS returns;
CREATE TABLE returns (
					    order_id VARCHAR(25),
					    return_id VARCHAR(25),
					    CONSTRAINT pk_returns PRIMARY KEY (order_id), -- Primary key constraint
					    CONSTRAINT fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

select * from orders




-- Q1-Find out the top 5 customers who made the highest profits.

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.sale - (o.price_per_unit * o.quantity)) AS total_profit -- profit finding
FROM 
    orders AS o
JOIN 
    products AS p ON o.product_id = p.product_id
JOIN 
    customers AS c ON o.customer_id = c.customer_id
GROUP BY 
    c.customer_id,
    c.customer_name
ORDER BY 
    total_profit DESC
LIMIT 5;


-- Q2-Find out the average quantity ordered per category.
select category,
    AVG(distinct quantity)as Average_quantity
from orders
group by 1
	order by 2 desc;

-- Q3-Identify the top 5 products that have generated the highest revenue.

select p.product_id,
       p.product_name,
       sum(o.sale) as Revenue
from orders as o
join products as p on o.product_id=p.product_id
group by 1,2
order by 3 desc
limit 5;

-- Q4- detemine the top 5 products whose revenue has decreased compared to the pervious year,

WITH py1 AS (
    SELECT
        p.product_name,
        SUM(o.sale) AS revenue
    FROM 
        orders AS o
    JOIN 
        products AS p ON o.product_id = p.product_id
    WHERE 
        o.order_date >= '2023-01-01' AND o.order_date <= '2023-12-31'
    GROUP BY 
        p.product_name
),
py2 AS (
    SELECT
        p.product_name,
        SUM(o.sale) AS revenue
    FROM 
        orders AS o
    JOIN 
        products AS p ON o.product_id = p.product_id
    WHERE 
        o.order_date >= '2022-01-01' AND o.order_date <= '2022-12-31'
    GROUP BY 
        p.product_name
)
SELECT
    py1.product_name,
    py1.revenue AS current_revenue,
    py2.revenue AS prev_revenue,
    (py1.revenue / py2.revenue) AS revenue_decreased_ratio
FROM 
    py1
JOIN 
    py2 ON py1.product_name = py2.product_name
WHERE 
    py1.revenue < py2.revenue
ORDER BY 
    py1.revenue DESC
LIMIT 5;


-- Q5-Identify the highest profitable sub-category.
select category,
        SUM(sale - (price_per_unit * quantity)) AS total_profit 
       from orders
group by 1
order by 2 desc;

-- Q6-Find out the states with the highest total orders.

select state,
      count(order_id) as Total_orders
from orders
group by 1
order by 2 desc
limit 5;

--Q7-Determine the month with the highest number of orders.

SELECT 
    TO_CHAR(order_date, 'Month') AS month_name,
    COUNT(order_id) AS total_orders
FROM 
    orders
GROUP BY 
    TO_CHAR(order_date, 'Month')
ORDER BY 
    total_orders DESC
LIMIT 3;

-- Q8-Calculate the profit margin percentage for each sale (Profit divided by Sales).


SELECT 
    sale,
    SUM((sale - (price_per_unit * quantity)) / sale) AS profit_margin
FROM 
    orders
GROUP BY 
    sale
ORDER BY 
    2 DESC;

-- Q9-Calculate the percentage contribution of each sub-category.

SELECT 
    sub_category,
    SUM(sale) AS total_sales,
    CAST(SUM(sale) * 100.0 / (SELECT SUM(sale) FROM orders) AS numeric(10,2)) AS percentage_contribution
FROM 
    orders
GROUP BY 
    sub_category;



-- Q10.Identify top 2 category that has received maximum returns and their return %

WITH return_summary AS (
    SELECT 
        o.category,
        CAST(SUM(r.return_id) AS numeric) AS total_returns,
        CAST(SUM(r.return_id) * 100.0 / (SELECT SUM(return_id) FROM returns) AS numeric(10,2)) AS return_percentage
    FROM 
        orders o
    JOIN 
        returns r ON o.order_id = r.order_id
    GROUP BY 
        o.category
    ORDER BY 
        total_returns DESC
    LIMIT 2
)
SELECT 
    category,
    total_returns,
    return_percentage
FROM 
    return_summary;





