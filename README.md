# 📊 SQL Business Data Analysis: Superstore Dataset (PostgreSQL)

## 📝 Overview & Highlights
**Ladder Challenge:** Completed a progressive SQL challenge simulating real-world business queries, focusing on data cleaning, filtering, aggregation, joins, and subqueries. Demonstrated advanced proficiency in querying relational databases to extract insights and support data-driven decisions.

This project focuses on analyzing sales performance, customer trends, product categories, and temporal patterns from a retail database (**Superstore**) using **PostgreSQL** and **pgAdmin 4**. 

---

## 🛠️ Key SQL Concepts & Techniques Applied

* **Temporal Analysis & Date Functions:** `EXTRACT()`, `DATE_TRUNC()`, handling Quarters, Months, and Days of the week (`DOW`).
* **Data Aggregation:** `SUM()`, `AVG()`, `COUNT(DISTINCT)` combined with multi-level `GROUP BY` and `ORDER BY` clauses.
* **Relational Joins:** `INNER JOIN` across `orders`, `products`, `customers`, and `regions` tables using foreign key relationships (`USING` syntax).
* **Conditional Logic:** `CASE WHEN` statements to transform numeric values into business-friendly categorical names (e.g., Days of the Week, Month Names).
* **Case-Insensitive Pattern Matching:** `ILIKE` for text filtering across product categories and regions.

---

## 🔍 Key Business Questions Addressed

-------------------------------------------------------------------------------
-- PROJECT: PostgreSQL Data Analysis (Ladder Challenge)
-- DATABASE: PostgreSQL
-------------------------------------------------------------------------------
```sql
SELECT *
FROM public.orders 
LIMIT 10;
```
<img width="1547" height="357" alt="Screenshot 2026-07-29 222046" src="https://github.com/user-attachments/assets/a2921a55-a766-4385-8d6c-5e12eed81023" />

-- 1. Question: Calculate the total Sales for each year based on OrderDate.
```sql
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    ROUND(SUM(sales)::numeric, 2) AS total_sales
FROM public.orders
GROUP BY 1
ORDER BY year ASC;
```
<img width="1552" height="392" alt="Screenshot 2026-07-29 223419" src="https://github.com/user-attachments/assets/9afbf1d3-e034-49bf-926a-de8595d595f2" />




-- 2. Question: What is the average Profit for each month (regardless of year) based on OrderDate?
```sql
SELECT EXTRACT(month from order_date) AS Month, AVG(profit) AS avg_profit
FROM public.orders
GROUP BY 1
```
<img width="1552" height="390" alt="Screenshot 2026-07-29 222120" src="https://github.com/user-attachments/assets/5c7db495-e811-4647-8038-2522c38df1fc" />



-- 3. Question: Find the total Quantity of products sold for each quarter of the year based on OrderDate.
```sql
SELECT DATE_TRUNC('YEAR', order_date) AS Year, SUM(quantity) AS total_quantity
FROM public.orders
GROUP BY 1
ORDER BY 1; 
```
<img width="1547" height="385" alt="Screenshot 2026-07-29 222140" src="https://github.com/user-attachments/assets/dddf155b-fac9-4e58-aee5-2181a951001c" />


-- 4. Question: List the Category and the total Sales for each month-year combination based on OrderDate.
```sql
SELECT p.category, DATE_TRUNC('MONTH', order_date) AS Month_Year, SUM(o.sales) AS total_sales
FROM public.orders o INNER JOIN public.products p
USING(product_id)
GROUP BY 1,2
ORDER BY 2 DESC; 
```
<img width="1556" height="392" alt="Screenshot 2026-07-29 222156" src="https://github.com/user-attachments/assets/4fb05590-5cbf-450e-ac23-a9d1395fcfcd" />



-- 5. Question: What is the number of distinct Customers who placed orders in each day of the week (e.g., Monday, Tuesday, etc.)?
```sql
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
```
<img width="1547" height="387" alt="Screenshot 2026-07-29 222239" src="https://github.com/user-attachments/assets/70ae557e-545f-4315-aa2c-5c0b8f6c8d32" />


-- 6. Question: Calculate the total Profit from 'Technology' products for each year they were ordered.
```sql
SELECT p.product_id, SUM(profit) AS total_profit, EXTRACT(YEAR FROM o.order_date) AS year_of_ordering
FROM public.products p INNER JOIN public.orders o 
USING(product_id)
WHERE product_id ILIKE 'TEC%'
GROUP BY 1,3
ORDER BY 3;
```
<img width="1548" height="388" alt="Screenshot 2026-07-29 222256" src="https://github.com/user-attachments/assets/3fe28725-66ed-4251-9442-73ed7900ab42" />


-- 7. Question: Show the total Sales for each quarter of the OrderDate in the 'South' Region.
```sql
SELECT r.sub_region, SUM(sales) AS total_sales, EXTRACT(QUARTER FROM o.order_date) AS quarter_of_order_date
FROM public.orders o INNER JOIN public.regions r
USING(region_id)
WHERE r.sub_region ILIKE 'South%' 
GROUP BY 1,3
ORDER BY 3;
```
<img width="1551" height="392" alt="Screenshot 2026-07-29 222317" src="https://github.com/user-attachments/assets/d3021c5f-3809-4996-ab50-6521f8d99c6f" />


-- 8. Question: Retrieve all orders (OrderID, OrderDate) that were placed in March 2023.
```sql
SELECT order_id, order_date
FROM public.orders
WHERE EXTRACT(MONTH FROM order_date) = 3 AND EXTRACT(YEAR FROM order_date) = 2023;
```
<img width="1552" height="395" alt="Screenshot 2026-07-29 223403" src="https://github.com/user-attachments/assets/13d931c8-b43f-430b-a455-c41580a6b601" />



-- 9. Question: List all CustomerName and their OrderDate for orders placed on a Sunday.
```sql
SELECT c.customer_name, o.order_date,
CASE EXTRACT(DOW FROM o.order_date) 
WHEN 0 THEN 'Sunday' 
END AS Orders_placed_on_Sunday
FROM public.orders o INNER JOIN public.customers c 
USING(customer_id)
GROUP BY c.customer_name, o.order_date
ORDER BY  EXTRACT(DOW FROM order_date);
```
<img width="1552" height="400" alt="Screenshot 2026-07-29 222406" src="https://github.com/user-attachments/assets/574b87f9-261e-4bac-9829-404719063701" />


-- 10. Question: Find the ProductName and Sales for all products that were ordered in the first half of any year (January to June).
```sql
SELECT p.product_name, o.sales
CASE WHEN 1 THEN 'January'
WHEN 2 THEN 'February'
WHEN 3 THEN 'March'
WHEN 4 THEN 'April'
WHEN 5 THEN 'May'
WHEN 6 THEN 'June'
END AS first_half_of_year
FROM public.orders o INNER JOIN public.products p 
USING (product_id)
WHERE EXTRACT(MONTH FROM o.order_date) BETWEEN 1 AND 6;
```
<img width="1545" height="392" alt="Screenshot 2026-07-29 222717" src="https://github.com/user-attachments/assets/4b8ceded-c9d7-4582-81c1-119260904f57" />

---

## 📂 Repository Structure

```text
├── README.md
├── scripts/
│   └── postgres_superstore_analysis.sql   # Complete SQL queries
└── data_outputs/
    └── annual_sales.csv          # Exported CSV query results
```

---

## 🚀 How to Run the Queries
1. Open your PostgreSQL environment (e.g., **pgAdmin** or **DBeaver**).
2. Connect to the database containing the `orders`, `products`, `customers`, and `regions` tables.
3. Execute `superstore_analysis_queries.sql` to run the analysis and reproduce the key metrics.
