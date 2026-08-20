SELECT
    o.order_id,
    o.order_date,
    o.customer_id,
    o.store_id,
    oi.product_id,
    p.product_name,

    oi.quantity,
    p.selling_price,
    p.cost_price,

    oi.line_total AS revenue,

    (oi.quantity * p.cost_price) AS cost,

    oi.line_total - (oi.quantity * p.cost_price) AS profit

FROM {{ ref('stg_orders') }} o

JOIN {{ source('raw', 'order_items') }} oi
    ON o.order_id = oi.order_id

JOIN {{ ref('stg_products') }} p
    ON oi.product_id = p.product_id