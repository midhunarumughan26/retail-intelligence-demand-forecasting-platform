SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    city,
    state,
    country
FROM {{ source('raw', 'customers') }}