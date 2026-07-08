WITH table_ref AS (
    SELECT SUM(ABS(oi.quantity)) AS units_sold,
	ROUND(SUM(ABS(oi.unit_price) * ABS(oi.quantity) * (1 - oi.discount_pct / 100)),2) AS total_net_revenue,
	ROUND(SUM(p.unit_cost * ABS(oi.quantity)),2) AS total_cost,
	ROUND(SUM(ABS(oi.quantity) * (ABS(oi.unit_price) * (1 - oi.discount_pct / 100) - p.unit_cost)), 2) AS profit,
	ROUND(SUM(ABS(oi.quantity) * (ABS(oi.unit_price) * (1 - oi.discount_pct / 100) - p.unit_cost))/
            SUM(ABS(oi.unit_price) * ABS(oi.quantity) * (1 - oi.discount_pct / 100)) * 100,2) AS margin_pct,
	COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(oi.discount_pct), 2) AS avg_discount_pct,
    ROUND(SUM(ABS(oi.quantity) * ABS(oi.unit_price) * (1 - oi.discount_pct / 100))
    / COUNT(DISTINCT o.order_id),2) AS avg_order_value
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON o.order_id = oi.order_id
	JOIN customers c
		ON c.customer_id = o.customer_id
    WHERE p.product_status = 'Active'
      AND o.order_status = 'Completed'
      AND oi.quantity > 0
      AND oi.discount_pct BETWEEN 0 AND 100
      AND p.category IS NOT NULL


)

SELECT *
FROM table_ref
ORDER BY total_net_revenue DESC;