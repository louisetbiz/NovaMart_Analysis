SELECT 'Negative prices' AS issue, 
COUNT(*) AS count,
GROUP_CONCAT(product_id SEPARATOR ', ') AS affected_id
FROM order_items
WHERE unit_price < 0

UNION ALL

SELECT 'Negative quantities', 
COUNT(*),
GROUP_CONCAT(order_id SEPARATOR ', ') 
FROM order_items
WHERE quantity < 0

UNION ALL

SELECT 'Invalid discounts', 
COUNT(*),
GROUP_CONCAT(order_id SEPARATOR ', ') 
FROM order_items
WHERE discount_pct < 0 OR discount_pct > 100

UNION ALL

SELECT 'Duplicate emails', 
COUNT(*),
GROUP_CONCAT(customer_id SEPARATOR ', ') 
FROM customers
WHERE email IN (
    SELECT email
    FROM customers
    GROUP BY email
    HAVING COUNT(*) > 1
)

UNION ALL

SELECT
    'Incorrect Date Campaign' AS issue,
    COUNT(*) AS count,
    GROUP_CONCAT(campaign_id SEPARATOR ', ') 
FROM marketing_campaigns
WHERE end_date < start_date

UNION ALL

SELECT
    'Null Category' AS issue,
    COUNT(*) AS count,
    GROUP_CONCAT(product_id SEPARATOR ', ') 
FROM products
WHERE category is null;