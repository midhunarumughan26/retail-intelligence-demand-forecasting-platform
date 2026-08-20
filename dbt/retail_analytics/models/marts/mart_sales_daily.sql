{{ config(
    materialized='table'
) }}

SELECT
    o.order_date,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.order_amount) AS total_sales,
    AVG(o.order_amount) AS average_order_value
FROM {{ ref('stg_orders') }} o
WHERE LOWER(o.order_status) = 'completed'
GROUP BY o.order_date
ORDER BY o.order_date