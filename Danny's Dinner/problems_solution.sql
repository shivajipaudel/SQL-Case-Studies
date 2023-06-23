-- problem statement 1: what is the total amount each customer spent at the restaurant?

SELECT 
    customer_id, SUM(price) AS Total_amount_spent
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY customer_id;

-- problem statement 2: How many days has each customer visited the restaurant? 

SELECT 
    customer_id, COUNT(DISTINCT order_date) AS Number_of_days
FROM
    sales
GROUP BY customer_id;

-- problem statement 3: what was the first item from the menu purchased by each customer? 

with final as(
select s.*, m.product_name,
rank() over (partition by customer_id order by order_date) as rnk
from sales s
join menu m 
on s.product_id = m.product_id)
select * from final where rnk = 1; 

-- problem statement 4:what was the most purchased item on the menu and how many times was it purchased by all customer ? 

SELECT 
    product_name, COUNT(*) AS most_purchased
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY most_purchased DESC
LIMIT 1;


 -- Problem Statement 5 : Which item was the most popular for each customer?
 
 WITH cte_FavItem AS (
     SELECT s.customer_id, m.product_name, COUNT(s.product_id) AS fav_count, 
     DENSE_RANK() OVER(partition by customer_id ORDER BY COUNT(s.product_id) DESC ) AS rnk 
     FROM sales s 
     JOIN menu m 
     ON s.product_id = m.product_id
     GROUP BY s.customer_id,m.product_name)
 
 SELECT customer_id, GROUP_CONCAT(DISTINCT product_name) AS fav_Items FROM cte_FavItem 
 WHERE rnk = 1
 GROUP BY customer_id;

 -- Problem Statement 6 : which item was purchased first by the customer after they become a member?
 
WITH cte_member_sales AS (
    SELECT s.customer_id, s.order_date, s.product_id,
    DENSE_RANK() OVER ( PARTITION BY s.customer_id ORDER BY s.order_date ) AS rnk
    FROM sales s 
    JOIN members mem 
    ON s.customer_id = mem.customer_id 
    WHERE s.order_date >= mem.join_date) 
    
SELECT c.customer_id, c.order_date, m.product_name
FROM cte_member_sales c
JOIN menu m 
ON c.product_id = m.product_id
WHERE rnk = 1
ORDER BY customer_id ;

-- Problem Statement 7 : which item was purchased just before the customer become a member?
 

  WITH cte_member_sales AS (
    SELECT s.customer_id, s.order_date, s.product_id,
    DENSE_RANK() OVER ( PARTITION BY s.customer_id ORDER BY s.order_date ) AS rnk
    FROM sales s 
    JOIN members mem 
    ON s.customer_id = mem.customer_id 
    WHERE s.order_date < mem.join_date) 
    
SELECT c.customer_id, c.order_date, m.product_name
FROM cte_member_sales c
JOIN menu m 
ON c.product_id = m.product_id
WHERE rnk = 1
ORDER BY customer_id ;
    
 -- Problem Statement 8 : what is the total items and amount spent for each member before they become a member?
 
SELECT 
    s.customer_id,
    COUNT(DISTINCT s.product_id) AS Total_items,
    SUM(m.price) AS Total_price
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
        JOIN
    members me ON s.customer_id = me.customer_id
WHERE
    s.order_date < me.join_date
GROUP BY s.customer_id;

 -- Problem Statement 9 : If each $1 spent equates to 10 points and sushi has a 2x points multiplier how many points would each customer have?

WITH cte_points AS (
SELECT * ,
CASE WHEN product_id = 1 THEN price*20
	 ELSE price*10 
	 END AS points
FROM menu)
SELECT s.customer_id, SUM(c.points) AS total_points 
FROM cte_points c
JOIN sales s 
ON s.product_id = c.product_id ;