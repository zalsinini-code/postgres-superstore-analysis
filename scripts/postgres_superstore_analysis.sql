SELECT *
FROM public.orders 
LIMIT 10;

-- 1. Question: Calculate the total Sales for each year based on OrderDate.
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    ROUND(SUM(sales)::numeric, 2) AS total_sales
FROM public.orders
GROUP BY 1
ORDER BY year ASC;

-- 2. Question: What is the average Profit for each month (regardless of year) based on OrderDate?
SELECT EXTRACT(month from order_date) AS Month, AVG(profit) AS avg_profit
FROM public.orders
GROUP BY 1

-- 3. Question: Find the total Quantity of products sold for each quarter of the year based on OrderDate.
SELECT DATE_TRUNC('YEAR', order_date) AS Year, SUM(quantity) AS total_quantity
FROM public.orders
GROUP BY 1
ORDER BY 1; 

-- 4. Question: List the Category and the total Sales for each month-year combination based on OrderDate.
SELECT p.category, DATE_TRUNC('MONTH', order_date) AS Month_Year, SUM(o.sales) AS total_sales
FROM public.orders o INNER JOIN public.products p
USING(product_id)
GROUP BY 1,2
ORDER BY 2 DESC; 


-- 5. Question: What is the number of distinct Customers who placed orders in each day of the week (e.g., Monday, Tuesday, etc.)?
SELECT CASE EXTRACT(DOW FROM o.order_date)
WHEN 0 THEN 'Sunday'
WHEN 1 THEN 'Monday'
WHEN 2 THEN 'Tuesday'
WHEN 3 THEN 'Wednesday'
WHEN 4 THEN 'Thursday'
WHEN 5 THEN 'Friday'
WHEN 6 THEN 'Saturday'
END AS day_of_week,
COUNT(DISTINCT customer_id) AS distinct_customers
FROM public.orders o
INNER JOIN public.customers c USING (customer_id)
GROUP BY o.order_date
ORDER BY  EXTRACT(DOW FROM order_date);


-- 6. Question: Calculate the total Profit from 'Technology' products for each year they were ordered.
SELECT p.product_id, SUM(profit) AS total_profit, EXTRACT(YEAR FROM o.order_date) AS year_of_ordering
FROM public.products p INNER JOIN public.orders o 
USING(product_id)
WHERE product_id ILIKE 'TEC%'
GROUP BY 1,3
ORDER BY 3;

-- 7. Question: Show the total Sales for each quarter of the OrderDate in the 'South' Region.
SELECT r.sub_region, SUM(sales) AS total_sales, EXTRACT(QUARTER FROM o.order_date) AS quarter_of_order_date
FROM public.orders o INNER JOIN public.regions r
USING(region_id)
WHERE r.sub_region ILIKE 'South%' 
GROUP BY 1,3
ORDER BY 3;


-- 8. Question: Retrieve all orders (OrderID, OrderDate) that were placed in March 2023.
SELECT order_id, order_date
FROM public.orders
WHERE EXTRACT(MONTH FROM order_date) = 3 AND EXTRACT(YEAR FROM order_date) = 2023;
-- 9. Question: List all CustomerName and their OrderDate for orders placed on a Sunday.
SELECT c.customer_name, o.order_date,
CASE EXTRACT(DOW FROM o.order_date) 
WHEN 0 THEN 'Sunday' 
END AS Orders_placed_on_Sunday
FROM public.orders o INNER JOIN public.customers c 
USING(customer_id)
GROUP BY c.customer_name, o.order_date
ORDER BY  EXTRACT(DOW FROM order_date);
-- 10. Question: Find the ProductName and Sales for all products that were ordered in the first half of any year (January to June).
SELECT 
    p.product_name, 
    o.sales,
    CASE EXTRACT(MONTH FROM o.order_date)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
    END AS first_half_of_year
FROM public.orders o 
INNER JOIN public.products p USING (product_id)
WHERE EXTRACT(MONTH FROM o.order_date) BETWEEN 1 AND 6;
