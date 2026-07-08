WITH stores_clean AS (
SELECT
o.order_id,
o.customer_id,
p.product_name,
ABS(oi.quantity) as quantity,
ABS(oi.unit_price) as unit_price,
oi.discount_pct,
s.store_id,
s.store_name,
s.region
FROM stores s
JOIN orders o
ON s.store_id = o.store_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON p.product_id = oi.product_id
WHERE discount_pct BETWEEN 0 AND 100
AND p.category is not null
AND o.order_status = 'Completed'
AND oi.quantity > 0
AND p.category IS NOT NULL
)

SELECT
store_id,
store_name,
region,
COUNT(DISTINCT order_id) AS orders,
COUNT(DISTINCT customer_id) AS customers,
ROUND(SUM(quantity * unit_price * (1 - discount_pct / 100)),2) AS net_revenue
FROM stores_clean
GROUP BY store_id, store_name, region
ORDER BY net_revenue DESC
;



