/*
===========================================================
🍕 Pizza Sales SQL Project
===========================================================

This script contains SQL solutions for the **Intermediate Level** 
questions in the Pizza Sales Analysis project.

Contents:
1. Join the necessary tables to find the total quantity of each pizza category ordered
2. Determine the distribution of orders by hour of the day
3. Join relevant tables to find the category-wise distribution of pizzas
4. Group the orders by date and calculate the average number of pizzas ordered per day
5. Determine the top 3 most ordered pizza types based on revenue

===========================================================
*/

-- 1.Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pizza_types.category, SUM(order_details.quantity)
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY SUM(order_details.quantity);

-- 2.Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(orders.order_time) as hour, COUNT(order_id) as order_quantity
FROM
    orders
GROUP BY HOUR(orders.order_time);

-- 3.Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    pizza_types.category, COUNT(pizza_types.name)
FROM
    pizza_types
GROUP BY pizza_types.category
ORDER BY COUNT(pizza_types.name);

-- 4.Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0) AS avg
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    
  --  5. Determine the top 3 most ordered pizza types based on revenue.

 SELECT 
    pizza_types.name,
    sum(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY  revenue DESC
LIMIT 3; 
