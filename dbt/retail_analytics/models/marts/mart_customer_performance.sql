{{ config(
    materialized='table'
) }}

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_spend,
    AVG(o.order_amount) AS average_order_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date
FROM {{ ref('stg_customers') }} c
JOIN {{ ref('stg_orders') }} o
    ON c.customer_id = o.customer_id
WHERE LOWER(o.order_status) = 'completed'
GROUP BY
    c.customer_id
ORDER BY total_spend DESC