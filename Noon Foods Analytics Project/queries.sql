-- Find top 1 outlets by cuisine type without using limit and top function
with cte as(
select cuisine, restaurant_id, count(*) no_of_orders from orders
group by cuisine, restaurant_id
)
select * from (
select *,
ROW_NUMBER() over ( partition by cuisine order by no_of_orders desc ) as RN
 from cte ) a
 where RN = 1;
 
 
 
 -- Find the daily new customers count from the launch date ( everyday how many new customers are acquired )
 with cte as (
 select Customer_code, CAST(min(placed_at) AS DATE) order_date
 from orders
 group by Customer_code )
select order_date, count(1) no_of_customers_added from CTE 
group by order_date
order by order_date;



-- Count all the users who were acquired in JAN 2025 and only placed one order in JAN and did not placed any other order
select Customer_code, count(1) no_of_orders from orders
where MONTH(placed_at) = 1 and YEAR(Placed_at) = 2025 and Customer_code NOT IN 
( select distinct customer_code from orders
where NOT ( MONTH(placed_at) = 1 and YEAR(Placed_at) = 2025 ) )
group by Customer_code
having no_of_orders = 1;


-- List all the customers with no orders in the last 7 days but were acquired one month ago with their 
-- first order on promo code
WITH cte AS (
    SELECT 
        Customer_code, 
        MIN(Placed_at) AS first_order_date,
        MAX(Placed_at) AS latest_order_date 
    FROM orders
    GROUP BY Customer_code
)
SELECT 
    cte.*, 
    o.promo_code_name AS first_order_promo 
FROM cte 
INNER JOIN orders o 
    ON cte.Customer_code = o.Customer_code 
    AND cte.first_order_date = o.Placed_at
WHERE 
    latest_order_date < DATE_SUB(NOW(), INTERVAL 7 DAY)  -- Orders older than 7 days
    AND first_order_date < DATE_SUB(NOW(), INTERVAL 1 MONTH)  -- First order older than 1 month
    AND o.promo_code_name IS NOT NULL;  -- First order used a promo code
    

-- Growth team is planning to create a trigger that will target customer after their every third order
-- with a personalized communication and they have asked you to create a query for this
with cte as (
select *,
row_number() over( partition by customer_code order by placed_at) as order_number
from orders )
select * from cte 
where order_number % 3 = 0 and DATE(placed_at) = DATE( sysdate()); 



-- List customers who placed more than 1 order and all the orders in promo only
select Customer_code, count(1) order_count, count(Promo_code_Name) promo_orders from orders
group by Customer_code
having order_count > 1 and promo_orders = order_count;



-- What percentage of customers are organically acquired. ( Placed their 1st order without promo code)
with cte as (
select 
*,
ROW_NUMBER() over( partition by customer_code order by placed_at) rn
from orders
where MONTH(placed_at) = 1 and YEAR(placed_at) = 2025 )
select count( CASE WHEN rn =1 and promo_code_name IS NULL then customer_code end)*100.0/count(distinct customer_code) percentage
from cte;