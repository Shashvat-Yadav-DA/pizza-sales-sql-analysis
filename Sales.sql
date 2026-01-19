--**TABLE CREATION**--

--CREATING TABLE pizza_types
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50),
    pizza_name VARCHAR(100),
    category VARCHAR(50),
    ingredients VARCHAR(255)
);

--CREATING TABLE pizzas
CREATE TABLE pizzas (
    pizza_id VARCHAR(50),
    pizza_type_id VARCHAR(50),
    pizza_size VARCHAR(10),
    price NUMERIC(10, 2)
);

--CREATING TABLE orders
CREATE TABLE orders (
    order_id INT,
    order_date DATE,
    order_time TIME
);

--CREATING TABLE order_details
CREATE TABLE order_details (
    order_details_id INT,
    order_id INT,
    pizza_id VARCHAR(50),
    quantity INT
);

--**DATA EXPLORATION**--

-- ROW COUNT
SELECT COUNT(*) FROM pizza_types;
SELECT COUNT(*) FROM pizzas;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_details;

--PREVIEW DATA
SELECT * FROM pizza_types LIMIT 5;
SELECT * FROM pizzas LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_details LIMIT 5;

--DATE RANGE
SELECT
	MIN(order_date) AS start_date,
	MAX(order_date) AS end_date
FROM orders;

--UNIQUE CATEGORY
SELECT DISTINCT(category) FROM pizza_types;
SELECT COUNT(DISTINCT(category)) FROM pizza_types;

--**DATA CLEANING**--

-- CHECKING NULL VALUES

--pizza_types TABLE
SELECT * 
FROM pizza_types
WHERE pizza_type_id IS NULL
	OR pizza_name IS NULL
	OR category IS NULL
	OR ingredients IS NULL;
--NO NULL VALUE FOUND

-- pizzas TABLE
SELECT * 
FROM pizzas
WHERE pizza_id IS NULL
	OR pizza_type_id IS NULL
	OR pizza_size IS NULL
	OR price IS NULL;
--NO NULL VALUE FOUND

--orders TABLE
SELECT * 
FROM orders
WHERE order_id IS NULL
	OR order_date IS NULL
	OR order_time IS NULL;
--NO NULL VALUE FOUND

--order_details TABLE
SELECT * 
FROM order_details
WHERE order_details_id IS NULL
	OR order_id IS NULL
	OR pizza_id IS NULL
	OR quantity IS NULL;
--NO NULL VALUE FOUND

--CHECKING INVALID QUANTITY
SELECT *
FROM order_details
WHERE quantity<=0;

SELECT *
FROM pizzas
WHERE price<=0;

--CHECKING ORPHAN RECORD
SELECT *
FROM order_details od
LEFT JOIN orders o
USING(order_id)
WHERE o.order_id IS NULL;

SELECT *
FROM pizzas p
LEFT JOIN pizza_types pt
USING(pizza_type_id)
WHERE pt.pizza_type_id is NULL;

-- CHECKING DUPLICATES
SELECT pizza_type_id,count(*) 
FROM pizza_types
GROUP BY pizza_type_id
HAVING COUNT(*)>1;

SELECT order_id,count(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*)>1;

--**BUSINESS INSIGHT QUESTIONS**--
--  1️ Show all orders placed on 2015-01-01,
-- sorted by order time from latest to earliest.
SELECT *
FROM orders
WHERE order_date ='2015-01-01'
ORDER BY order_time DESC;

-- 2️ What are the distinct pizza categories available
-- in the menu?
SELECT 
	DISTINCT(category)
FROM pizza_types;

-- 3 How many unique orders were placed on each day, and list
-- only the days with more than 100 orders?
SELECT 
    order_date,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_date
HAVING COUNT(order_id) > 100;

-- 4️ What is the total revenue generated and the average revenue
-- per order for the entire year?
SELECT
    SUM(order_revenue) AS total_revenue,
    AVG(order_revenue) AS avg_revenue_per_order
FROM (
    SELECT
        od.order_id,
        SUM(p.price * od.quantity) AS order_revenue
    FROM order_details od
    JOIN pizzas p
    USING (pizza_id)
    GROUP BY od.order_id
) t;

-- 5️ Which pizza categories generated more than ₹50,000 in revenue,
-- ordered from highest to lowest revenue?

SELECT 
	pt.category,
	SUM(p.price*od.quantity) AS total_revenue
FROM pizza_types pt
JOIN pizzas p USING(pizza_type_id)
JOIN order_details od USING(pizza_id)
GROUP BY pt.category
HAVING SUM(p.price*od.quantity)>50000
ORDER BY total_revenue DESC;


-- 6 List the top 5 best-selling pizzas by total quantity sold, including 
-- pizza name and total units sold.
SELECT 
	pt.pizza_name,
	SUM(od.quantity) AS total_units_sold
FROM pizza_types pt
join pizzas p USING(pizza_type_id)
join order_details od USING(pizza_id)
GROUP BY pt.pizza_name
ORDER BY total_units_sold DESC
LIMIT 5;

-- 7 Identify pizza types that were never ordered by customers.
SELECT 
	DISTINCT(pt.pizza_name)
FROM pizza_types pt
LEFT JOIN pizzas p USING(pizza_type_id)
LEFT JOIN order_details od USING(pizza_id)
WHERE od.order_id IS NULL;

-- 8 Which pizza names rank in the top 3 by total revenue within each pizza category?
SELECT
    category,
    pizza_name
FROM (
    SELECT 
        pt.category,
        pt.pizza_name,
        DENSE_RANK() OVER (
            PARTITION BY pt.category 
            ORDER BY SUM(p.price * od.quantity) DESC
        ) AS rnk
    FROM pizza_types pt
    JOIN pizzas p USING (pizza_type_id)
    JOIN order_details od USING (pizza_id)
    GROUP BY pt.category, pt.pizza_name
) t
WHERE rnk <= 3;


-- 9 For each pizza category, assign a rank to pizzas based on total
-- quantity sold, and show only the highest-selling pizza per category.

SELECT
	category,
	pizza_name
FROM(
	SELECT
		pt.category,
		pt.pizza_name,
		DENSE_RANK() OVER(PARTITION BY pt.category ORDER BY SUM(od.quantity) DESC) AS rnk
	FROM pizza_types pt
	JOIN pizzas p USING(pizza_type_id)
	JOIN order_details od USING(pizza_id)
    GROUP BY pt.category, pt.pizza_name
)t
WHERE rnk =1;

-- 10 Rank all pizzas by average revenue per order, and return the top 5 
-- pizzas, allowing ties.


SELECT
    pizza_name,
    average_revenue
FROM (
    SELECT
        pt.pizza_name,
        AVG(p.price * od.quantity) AS average_revenue,
        RANK() OVER (
            ORDER BY AVG(p.price * od.quantity) DESC
        ) AS rnk
    FROM pizza_types pt
    JOIN pizzas p USING (pizza_type_id)
    JOIN order_details od USING (pizza_id)
    GROUP BY pt.pizza_name
) t
WHERE rnk <= 5;

	

	
	
	
	



 

















	






