-- Here are some of the exercises for which you can write SQL queries to self evaluate using all the concepts we have learnt to write SQL Queries.
-- * All the exercises are based on retail tables.
-- * We have already setup the tables and also populated the data.
-- * We will use all the 6 tables in retail database as part of these exercises.

-- Here are the commands to validate the tables
SELECT count(*) FROM departments;
SELECT count(*) FROM categories;
SELECT count(*) FROM products;
SELECT count(*) FROM orders;
SELECT count(*) FROM order_items;
SELECT count(*) FROM customers;

-- ### Exercise 1 - Customer order count

-- Get order count per customer for the month of 2014 January.

-- * Tables - `orders` and `customers`
-- * Data should be sorted in descending order by count and ascending order by customer id.
-- * Output should contain `customer_id`, `customer_fname`, `customer_lname` and `customer_order_count`.
SELECT count(*) FROM customers;

SELECT count(*) 
FROM orders
WHERE to_char(order_date, 'yyyy-MM') = '2014-01';

SELECT count(DISTINCT order_customer_id) 
FROM orders
WHERE to_char(order_date, 'yyyy-MM') = '2014-01';

SELECT c.customer_id,
    c.customer_fname,
    c.customer_lname,
    o.order_id,
    o.order_date
FROM orders AS o
    JOIN customers AS c
        ON o.order_customer_id = c.customer_id
WHERE to_char(order_date, 'yyyy-MM') = '2014-01'
ORDER BY 1
LIMIT 10;

SELECT count(*)
FROM (
    SELECT customer_id,
        customer_fname,
        customer_lname
    FROM orders AS o
        JOIN customers AS c
            ON o.order_customer_id = c.customer_id
    WHERE to_char(order_date, 'yyyy-MM') = '2014-01'
) AS q;

SELECT c.customer_id,
    c.customer_fname,
    c.customer_lname,
    count(*) AS customer_order_count
FROM orders AS o
    JOIN customers AS c
        ON o.order_customer_id = c.customer_id
WHERE to_char(order_date, 'yyyy-MM') = '2014-01'
GROUP BY 1, 2, 3
ORDER BY 4 DESC, 1
LIMIT 10;

SELECT count(*)
FROM (
    SELECT customer_id,
        customer_fname,
        customer_lname,
        count(*) AS customer_order_count
    FROM orders AS o
        JOIN customers AS c
            ON o.order_customer_id = c.customer_id
    WHERE to_char(order_date, 'yyyy-MM') = '2014-01'
    GROUP BY 1, 2, 3
) AS q;

-- ### Exercise 2 - Dormant Customers

-- Get the customer details who have not placed any order for the month of 2014 January.
-- * Tables - `orders` and `customers`
-- * Output Columns - **All columns from customers as is**
-- * Data should be sorted in ascending order by `customer_id`
-- * Output should contain all the fields from `customers`
-- * Make sure to run below provided validation queries and validate the output.

SELECT count(DISTINCT order_customer_id)
FROM orders
WHERE to_char(order_date, 'yyyy-MM') = '2014-01';

SELECT count(*)
FROM customers;

-- Get the difference
-- Get the count using solution query, both the difference and this count should match

-- * Hint: You can use `NOT IN` or `NOT EXISTS` or `OUTER JOIN` to solve this problem.

SELECT 12435 - 4696;

SELECT c.*
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
ORDER BY 1
LIMIT 10;

SELECT count(*)
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01';

SELECT count(DISTINCT c.customer_id)
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01';

SELECT c.*
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
WHERE o.order_customer_id IS NULL
ORDER BY 1
LIMIT 10;

SELECT count(*)
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
WHERE o.order_customer_id IS NULL;

-- Using NOT IN
SELECT c.*
FROM customers AS c
WHERE c.customer_id NOT IN (
    SELECT o.order_customer_id
    FROM orders AS o
    WHERE o.order_customer_id = c.customer_id
        AND to_char(order_date, 'yyyy-MM') = '2014-01'
)
ORDER BY 1
LIMIT 10;

SELECT count(*)
FROM customers AS c
WHERE c.customer_id NOT IN (
    SELECT o.order_customer_id
    FROM orders AS o
    WHERE o.order_customer_id = c.customer_id
        AND to_char(order_date, 'yyyy-MM') = '2014-01'
);

-- using NOT EXISTS
SELECT c.*
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders AS o
    WHERE o.order_customer_id = c.customer_id
        AND to_char(order_date, 'yyyy-MM') = '2014-01'
)
ORDER BY 1
LIMIT 10;

SELECT count(*)
FROM customers AS c
WHERE NOT EXISTS (
    SELECT o.order_customer_id
    FROM orders AS o
    WHERE o.order_customer_id = c.customer_id
        AND to_char(order_date, 'yyyy-MM') = '2014-01'
)
ORDER BY 1
LIMIT 10;

-- ### Exercise 3 - Revenue Per Customer

-- Get the revenue generated by each customer for the month of 2014 January
-- * Tables - `orders`, `order_items` and `customers`
-- * Data should be sorted in descending order by revenue and then ascending order by `customer_id`
-- * Output should contain `customer_id`, `customer_fname`, `customer_lname`, `customer_revenue`.
-- * If there are no orders placed by customer, then the corresponding revenue for a given customer should be 0.
-- * Consider only `COMPLETE` and `CLOSED` orders

SELECT count(*) FROM customers;

SELECT c.*
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
            AND o.order_status IN ('COMPLETE', 'CLOSED')
ORDER BY 1
LIMIT 10;

SELECT count(*)
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
            AND o.order_status IN ('COMPLETE', 'CLOSED')
ORDER BY 1
LIMIT 10;

SELECT count(DISTINCT c.customer_id)
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
            AND o.order_status IN ('COMPLETE', 'CLOSED')
ORDER BY 1
LIMIT 10;

SELECT c.customer_id,
    c.customer_fname,
    c.customer_lname,
    round(sum(oi.order_item_subtotal)::numeric, 2) AS customer_revenue
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
            AND o.order_status IN ('COMPLETE', 'CLOSED')
    LEFT OUTER JOIN order_items AS oi
        ON o.order_id = oi.order_item_order_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC, 1
LIMIT 10;

SELECT count(*) FROM (
    SELECT c.customer_id,
        c.customer_fname,
        c.customer_lname,
        round(sum(oi.order_item_subtotal)::numeric, 2) AS customer_revenue
    FROM customers AS c
        LEFT OUTER JOIN orders AS o
            ON o.order_customer_id = c.customer_id
                AND to_char(order_date, 'yyyy-MM') = '2014-01'
                AND o.order_status IN ('COMPLETE', 'CLOSED')
        LEFT OUTER JOIN order_items AS oi
            ON o.order_id = oi.order_item_order_id
    GROUP BY 1, 2, 3
) AS q;

SELECT c.customer_id,
    c.customer_fname,
    c.customer_lname,
    coalesce(round(sum(oi.order_item_subtotal)::numeric, 2), 0) AS customer_revenue
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
            AND o.order_status IN ('COMPLETE', 'CLOSED')
    LEFT OUTER JOIN order_items AS oi
        ON o.order_id = oi.order_item_order_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC, 1
LIMIT 10;

SELECT count(*) FROM (
    SELECT c.customer_id,
        c.customer_fname,
        c.customer_lname,
        coalesce(round(sum(oi.order_item_subtotal)::numeric, 2), 0) AS customer_revenue
    FROM customers AS c
        LEFT OUTER JOIN orders AS o
            ON o.order_customer_id = c.customer_id
                AND to_char(order_date, 'yyyy-MM') = '2014-01'
                AND o.order_status IN ('COMPLETE', 'CLOSED')
        LEFT OUTER JOIN order_items AS oi
            ON o.order_id = oi.order_item_order_id
    GROUP BY 1, 2, 3
) AS q;

-- ### Exercise 4 - Revenue Per Category

-- Get the revenue generated for each category for the month of 2014 January
-- * Tables - `orders`, `order_items`, `products` and `categories`
-- * Data should be sorted in ascending order by `category_id`.
-- * Output should contain all the fields from `categories` along with the revenue as `category_revenue`.
-- * Consider only `COMPLETE` and `CLOSED` orders

SELECT count(*) FROM categories;

SELECT c.category_id,
    c.category_department_id,
    c.category_name,
    round(sum(oi.order_item_subtotal)::numeric, 2) AS category_revenue
FROM categories AS c
    JOIN products AS p
        ON c.category_id = p.product_category_id
    JOIN order_items AS oi
        ON p.product_id = oi.order_item_product_id
    JOIN orders AS o
        ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
    AND to_char(o.order_date, 'yyyy-MM') = '2014-01'
GROUP BY 1, 2, 3
ORDER BY 1;

SELECT c.category_id,
    c.category_department_id,
    c.category_name,
    round(sum(oi.order_item_subtotal)::numeric, 2) AS category_revenue
FROM categories AS c
    JOIN products AS p
        ON c.category_id = p.product_category_id
    JOIN order_items AS oi
        ON p.product_id = oi.order_item_product_id
    JOIN orders AS o
        ON o.order_id = oi.order_item_order_id
        AND o.order_status IN ('COMPLETE', 'CLOSED')
        AND to_char(o.order_date, 'yyyy-MM') = '2014-01'
GROUP BY 1, 2, 3
ORDER BY 1;

SELECT count(DISTINCT product_category_id)
FROM products AS p
    JOIN order_items AS oi
        ON p.product_id = oi.order_item_product_id
    JOIN orders AS o
        ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
    AND to_char(o.order_date, 'yyyy-MM') = '2014-01';

-- ### Exercise 5 - Product Count Per Department

-- Get the count of products for each department.
-- * Tables - `departments`, `categories`, `products`
-- * Data should be sorted in ascending order by `department_id`
-- * Output should contain all the fields from `departments` and the product count as `product_count`

SELECT * FROM departments;

SELECT d.department_id,
    d.department_name
FROM departments AS d
    JOIN categories AS c
        ON d.department_id = c.category_department_id
    JOIN products AS p
        ON c.category_id = p.product_category_id
ORDER BY 1
LIMIT 10;

SELECT count(*) FROM products;

SELECT count(*)
FROM (
    SELECT d.department_id,
        d.department_name
    FROM departments AS d
        JOIN categories AS c
            ON d.department_id = c.category_department_id
        JOIN products AS p
            ON c.category_id = p.product_category_id
) AS q;

SELECT count(*) FROM categories AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM departments AS d
    WHERE d.department_id = c.category_department_id
);

SELECT * FROM categories AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM departments AS d
    WHERE d.department_id = c.category_department_id
);

SELECT count(*) FROM products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM categories AS c
        JOIN departments AS d
            ON d.department_id = c.category_department_id
    WHERE c.category_id = p.product_category_id
);

SELECT d.department_id,
    d.department_name,
    count(*) AS department_count
FROM departments AS d
    JOIN categories AS c
        ON d.department_id = c.category_department_id
    JOIN products AS p
        ON c.category_id = p.product_category_id
GROUP BY 1, 2
ORDER BY 1;