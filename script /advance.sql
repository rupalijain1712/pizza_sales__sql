/*
===========================================================
🍕 Pizza Sales SQL Project
===========================================================

This script contains SQL solutions for the **Advanced Level** 
questions in the Pizza Sales Analysis project.

Contents:
1. Calculate the percentage contribution of each pizza type to total revenue
2. Analyze the cumulative revenue generated over time
3. Determine the top 3 most ordered pizza types based on revenue for each pizza category

===========================================================
*/


-- 1.Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_Sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS percentage
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY percentage DESC
;

-- 2.Analyze the cumulative revenue generated over time.
-- day1 200 200
-- day2 300 500
-- day3 400 900

SELECT
  order_date, 
  sum(revenue) over(order by order_date ) as cum_revenue
from
(SELECT 
    orders.order_date,
    ROUND(SUM(order_details.quantity * pizzas.price),2) AS revenue 
FROM
    order_details
        JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
        JOIN orders ON order_details.order_id = orders.order_id
GROUP BY orders.order_date) as sales;
 
 -- 3.Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT
     name,
     revenue 
FROM
 (SELECT
      category, 
      name, 
      revenue,
      RANK() over (partition by category order by revenue desc)as rn
FROM
 (SELECT 
    pizza_types.category,
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category , pizza_types.name) as a) as b
where rn<=3;

