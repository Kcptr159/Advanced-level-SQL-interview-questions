/*
Question: Write a query to calculate the retention rate of users who made their first purchase in the month of January 2022 and made a 
          repeat purchase in the month of February 2022*/
/*
-- Create the sales table
CREATE TABLE sales (
    customer_id INT,
    date_column DATE
);

-- Insert sample data into the sales table for January and February
INSERT INTO sales (customer_id, date_column)
VALUES
    (1, '2022-01-15'),
    (2, '2022-01-20'),
    (3, '2022-02-05'),
    (1, '2022-02-10'),
    (4, '2022-02-25'),
    (2, '2022-03-10'),
    (1, '2022-03-15');
*/



WITH january_customers AS (
    SELECT customer_id
    FROM sales
    WHERE date_column BETWEEN '2022-01-01' AND '2022-01-31'
),
february_customers AS (
    SELECT customer_id
    FROM sales
    WHERE date_column BETWEEN '2022-02-01' AND '2022-02-28'
),
repeat_customers AS (
    SELECT j.customer_id
    FROM january_customers j
    JOIN february_customers f ON j.customer_id = f.customer_id
),
retained_customers AS (
    SELECT customer_id
    FROM sales
    WHERE date_column BETWEEN '2022-03-01' AND '2022-03-31'
)
SELECT 100 * COUNT(DISTINCT r.customer_id) / COUNT(DISTINCT january_customers.customer_id) AS retention_rate
FROM repeat_customers r
JOIN january_customers ON january_customers.customer_id = r.customer_id;


/*
Question: Write a query to find the top 3 categories with the highest sales growth in the 
          last quarter compared to the previous quarter.
*/

/*
CREATE TABLE sales (
    category VARCHAR(50),
    sales DECIMAL(10, 2),
    date_column DATE
);

INSERT INTO sales (category, sales, date_column)
VALUES
    ('Category A', 1500.00, '2022-01-15'),
    ('Category B', 2000.00, '2022-01-20'),
    ('Category A', 1800.00, '2022-02-05'),
    ('Category C', 1200.00, '2022-02-10'),
    ('Category B', 2200.00, '2022-03-25'),
    ('Category C', 1000.00, '2021-10-15'),
    ('Category A', 1600.00, '2021-12-10');
*/

WITH
current_quarter AS (
    SELECT category, SUM(sales) AS current_sales
    FROM sales
    WHERE date_column BETWEEN '2022-01-01' AND '2022-03-31'
    GROUP BY category
),
previous_quarter AS (
    SELECT category, SUM(sales) AS previous_sales
    FROM sales
    WHERE date_column BETWEEN '2021-10-01' AND '2021-12-31'
    GROUP BY category
)
SELECT c.category, 100 * (c.current_sales - p.previous_sales) / p.previous_sales AS growth_percentage
FROM current_quarter c
JOIN previous_quarter p ON c.category = p.category
ORDER BY growth_percentage DESC
LIMIT 3;


/*
Question: Write a query to calculate the total revenue per product category for the month of January 2022.
*/

SELECT category, SUM(price * quantity) AS revenue
FROM sales
WHERE date_column BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY category;


/*Question: Write a query to retrieve the top 5 most frequently occurring values in a column 
            named “colors” from a table named “products”.
*/

SELECT colors, COUNT(*) AS frequency
FROM products
GROUP BY colors
ORDER BY frequency DESC
LIMIT 5;

/*
Question: Find the average revenue per user (ARPU) for each month in the year 2021.
*/

SELECT 
    EXTRACT(MONTH FROM date_column) AS month,
    AVG(revenue) AS arpu
FROM 
    table_name
WHERE 
    EXTRACT(YEAR FROM date_column) = 2021
GROUP BY 
    EXTRACT(MONTH FROM date_column);