{{ config(
    materialized='table'
) }}

SELECT
    p.product_id,
    p.product_name,
    p.category_id,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    SUM(oi.quantity) AS units_sold,

    SUM(oi.line_total) AS total_sales,

    AVG(p.selling_price) AS average_selling_price

FROM {{ ref('stg_products') }} p

JOIN {{ source('raw', 'order_items') }} oi
    ON p.product_id = oi.product_id

JOIN {{ ref('stg_orders') }} o
    ON oi.order_id = o.order_id

WHERE LOWER(o.order_status) = 'completed'

GROUP BY
    p.product_id,
    p.product_name,
    p.category_id

ORDER BY total_sales DESC