-- Amazon Sales Data Analysis using SQL (PostgreSQL) 
	

--  business Problems  

 

-- Q1. Retrieve the total number of customers in the database. 
SELECT COUNT(*) AS total_customers
FROM customers;

-- 2. Calculate the total number of sellers registered on Amazon. 

SELECT COUNT(SELLER_ID) AS reg_seller
	FROM SELLERS

-- 3. List all unique product categories available. 

SELECT DISTINCT P.PRODUCT_NAME, O.CATEGORY
FROM PRODUCTS P 
JOIN ORDERS O ON P.PRODUCT_ID = O.PRODUCT_ID;

-- 4. Find the top 5 best-selling products by quantity sold. 

SELECT * FROM ORDERS
SELECT * FROM PRODUCTS

SELECT P.PRODUCT_NAME,
	   SUM(O.QUANTITY) AS TOTAL_QTY
FROM ORDERS O
JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- 5. Determine the total revenue generated from sales. 

SELECT * FROM ORDERS

SELECT CAST(SUM(QUANTITY*SALE)AS NUMERIC (10,2)) AS TOTAL_REVENUE 
	FROM ORDERS
	
	
-- 6. List all customers who have made at least one return. 
SELECT * FROM CUSTOMERS
SELECT * FROM RETURNS
	
	SELECT C.CUSTOMER_ID, C.CUSTOMER_NAME
FROM CUSTOMERS C
JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
JOIN RETURNS R ON O.ORDER_ID = R.ORDER_ID
GROUP BY C.CUSTOMER_ID, C.CUSTOMER_NAME;

	
-- 7. Calculate the average price of products sold. 
SELECT * FROM PRODUCTS
SELECT * FROM ORDERS

SELECT SUM(SALE) / SUM(QUANTITY) AS AVERAGE_PRICE
FROM ORDERS;

-- 8. Identify the top 3 states with the highest total sales. 
SELECT STATE ,
	   SUM(SALE) AS TOTAL_SALE
	FROM ORDERS
	GROUP BY STATE 
	ORDER BY TOTAL_SALE DESC
	LIMIT 3;
	
-- 9. Find the product category with the highest average sale price. 
 SELECT CATEGORY,
	    AVG(SALE) AS avg_sale_$
	 FROM ORDERS 
	 GROUP BY 1
	 ORDER BY 2 DESC
	 LIMIT 1;

-- 10. List all orders with a sale amount greater than $100. 

SELECT *
FROM ORDERS
WHERE SALE > 100;

-- 11. Calculate the total number of returns processed. 

SELECT COUNT(*) AS TOTAL_RETURNS
FROM RETURNS;

	
-- 12. Identify the top-selling seller based on total sales amount.

-- 1.top seller 
-- 2.based on total sales

SELECT s.seller_name,
	   CAST(SUM(o.sale) AS NUMERIC (10,2)) AS TOTAL_AMOUNT
	FROM SELLERS s
	JOIN ORDERS o ON s.seller_id = o.seller_id
	GROUP BY s.seller_name
	ORDER BY 2 DESC 
	LIMIT 3;

-- 13. List the products with the highest quantity sold in each category. 


WITH RankedProducts AS (
    SELECT 
        P.PRODUCT_ID,
        O.CATEGORY,
        P.PRODUCT_NAME,
        O.QUANTITY,
        ROW_NUMBER() OVER (PARTITION BY O.CATEGORY ORDER BY O.QUANTITY DESC) AS rank
    FROM ORDERS O 
    JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
)
SELECT PRODUCT_ID, CATEGORY, PRODUCT_NAME, QUANTITY
FROM RankedProducts
WHERE rank = 1;

14. Determine the average sale amount per order. 

SELECT AVG(SALE) AS AVG_SALE_AMT
FROM ORDERS;	

-- 15. Find the top 5 customers who have spent the most money. 

SELECT C.CUSTOMER_ID,
	CAST(SUM(O.SALE) AS NUMERIC (10,2)) AS MONEY_SPENT
	FROM ORDERS O 
	JOIN CUSTOMERS AS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
	GROUP BY  1
	ORDER BY 2 DESC
	LIMIT 5;

-- 16. Calculate the total number of orders placed in each state. 

SELECT STATE,
	   COUNT(ORDER_ID) AS TOTAL_ORDER
	FROM ORDERS
	GROUP BY 1
	ORDER BY 2 DESC

-- 17. Identify the product sub-category with the highest total sales.

 select category,
	sub_category,
	    CAST(SUM(sale) as numeric (10,2)) as TOTAL_SALE
	from orders
	group by 1,2
	order by 3 desc;

-- 18. List the orders with the highest total sale amount. 

select * from  orders

	SELECT ORDER_ID,
	       SUM(SALE) AS TOTAL_AMT
	FROM ORDERS
	GROUP BY ORDER_ID
	ORDER BY 2 DESC
	LIMIT 5;

-- 19. Calculate the total sales revenue for each seller. 

SELECT * FROM SELLERS
SELECT * FROM ORDERS

	SELECT S.SELLER_NAME,
	       CAST(SUM(SALE) AS NUMERIC (10,2)) AS TOTAL_SALES
	FROM ORDERS O
	JOIN SELLERS S ON O.SELLER_ID = S.SELLER_ID
	GROUP BY S.SELLER_NAME
	ORDER BY TOTAL_SALES DESC

-- SOLVING THROUGH DIFF APPROACH
SELECT S.SELLER_NAME,
	CAST(SUM(O.SALE) AS NUMERIC (10,2)) AS TOTAL,
	RANK() OVER(PARTITION BY SUM(O.SALE) ORDER BY S.SELLER_NAME DESC) AS RN
	FROM ORDERS O
	JOIN SELLERS S ON O.SELLER_ID = S.SELLER_ID
	GROUP BY S.SELLER_NAME
	ORDER BY 2 DESC

-- 20. Find the top 3 states with the highest average sale per order


SELECT STATE,
	    CAST(AVG(SALE) AS NUMERIC (10,2)) AS AVG_SALE_ORDER
FROM ORDERS
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 3 ;

	
-- 21. Identify the product category with the highest total quantity sold. 

SELECT CATEGORY,
	   CAST(SUM(QUANTITY) AS NUMERIC (10,2)) AS TOTAL_QTY_SOLD
	FROM ORDERS
	GROUP BY 1
	ORDER BY 2 DESC;

-- 22. List the orders with the highest quantity of products purchased. 

SELECT *
FROM ORDERS
WHERE QUANTITY = (
    SELECT MAX(QUANTITY)
    FROM ORDERS 
);

	
-- 23. Calculate the average sale amount for each product category.

SELECT CATEGORY,
	   CAST(AVG(SALE) AS NUMERIC (10,2)) AS AVG_SALE_AMT
	FROM ORDERS
	GROUP BY CATEGORY
ORDER BY 2 DESC	

-- 24. Find the top-selling seller based on the number of orders processed. 

SELECT S.SELLER_ID,
	S.SELLER_NAME,
	   COUNT(O.ORDER_ID) AS ORDER_PROCESSED
	FROM ORDERS O
	JOIN SELLERS S ON O.SELLER_ID = S.SELLER_ID
	GROUP BY  S.SELLER_ID,2
	ORDER BY 3 DESC 
	LIMIT 1;

-- 25. Identify the customers who have made returns more than once. 

SELECT CUSTOMER_ID
FROM (
    SELECT ORDER_ID, COUNT(*) AS RETURN_COUNT
    FROM RETURNS
    GROUP BY ORDER_ID
) AS ReturnCounts
WHERE RETURN_COUNT > 1;

       






