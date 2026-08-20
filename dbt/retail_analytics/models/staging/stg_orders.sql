SELECT
    order_id,
    customer_id,
    store_id,
    order_date,
    order_status,
    order_amount
FROM {{ source('raw', 'orders') }}