SELECT
mc.campaign_name,
mc.budget,
DATEDIFF(mc.end_date, mc.start_date) as campaign_duration_days,
ROUND(SUM(ABS(oi.quantity) * ABS(oi.unit_price)*(1-oi.discount_pct/100)), 2) AS net_revenue,
ROUND(SUM(ABS(oi.quantity) * ABS(oi.unit_price)*(1-oi.discount_pct/100))/mc.budget, 2) AS ROI
FROM marketing_campaigns mc
JOIN orders o
ON o.campaign_id = mc.campaign_id
JOIN order_items oi
ON o.order_id = oi.order_id
WHERE 
oi.discount_pct BETWEEN 0 AND 100
AND o.order_status = 'Completed'
AND mc.end_date > mc.start_date
AND oi.quantity>0
GROUP BY mc.campaign_name, 
mc.budget,
mc.start_date,
mc.end_date
ORDER BY net_revenue DESC
;

