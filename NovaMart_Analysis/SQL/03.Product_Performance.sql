WITH table_ref AS (
SELECT 
p.product_id,
p.product_name,
p.category,
p.unit_cost AS unit_cost,
oi.quantity AS quantity,
SUM(ABS(oi.quantity)) AS units_sold,
ROUND(SUM((ABS(p.unit_price) - p.unit_cost) / ABS(oi.unit_price) * 100),2)  AS unit_profit_margin,
ROUND(SUM(ABS(oi.unit_price) * (oi.quantity) * ((1 - oi.discount_pct/100))),2) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
JOIN orders o
ON o.order_id = oi.order_id
WHERE product_status = 'Active'
AND oi.quantity > 0
AND oi.discount_pct BETWEEN 0 AND 100
AND p.category IS NOT NULL
GROUP BY
p.product_id,
p.product_name,
p.category,
quantity,
unit_cost
ORDER BY revenue DESC)

SELECT
product_id, 
product_name,
category,
revenue,
SUM(unit_cost * quantity) AS total_cost
FROM table_ref
GROUP BY
product_id, 
product_name,
category,
revenue
;
