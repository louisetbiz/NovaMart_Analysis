WITH clean_sales AS (
	SELECT
		o.order_id AS order_id, 
        YEAR(o.order_date) AS year,
        MONTH(o.order_date) AS month_number,
		MONTHNAME(o.order_date) AS month,
        p.product_id,
        p.category,
        ABS(oi.quantity) AS quantity,
        ABS(oi.unit_price) AS unit_price,
        oi.discount_pct
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.order_status = 'Completed'
      AND oi.quantity > 0
      AND oi.discount_pct BETWEEN 0 AND 100
      )
SELECT 
    year,
    month_number,
    month,
    order_id,
    product_id,
    category,
    ROUND(SUM(
            quantity
            * unit_price
            * (1-discount_pct/100)),2) AS net_revenue

FROM clean_sales
WHERE category is not null
GROUP BY
	order_id,
    product_id,
    year,
    month,
    month_number,
    category
ORDER BY
    month_number,
    net_revenue DESC;