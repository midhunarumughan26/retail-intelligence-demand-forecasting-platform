SELECT
    product_id,
    product_name,
    brand_id,
    category_id,
    supplier_id,
    selling_price,
    cost_price,
    quantity_in_stock,
    manufactured_date,
    expiry_date
FROM {{ source('raw', 'products') }}