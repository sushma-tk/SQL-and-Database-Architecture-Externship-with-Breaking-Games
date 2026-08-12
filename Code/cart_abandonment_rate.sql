-- Cart Abandonment Rate
SELECT 
    (SELECT COUNT(DISTINCT name) FROM shopify_checkouts) AS carts_started,
    (SELECT COUNT(DISTINCT order_name) FROM shopify_orders) AS completed_orders,
    ROUND(100.0 * (1 - 
        (SELECT COUNT(DISTINCT order_name) FROM shopify_orders) * 1.0 /
        (SELECT COUNT(DISTINCT name) FROM shopify_checkouts)
    ), 1) AS abandonment_pct;
	
	
	
-- date check on shopify orders
SELECT MIN(day) AS min_date_orders, MAX(day) AS max_date_orders
FROM shopify_orders;

-- date check on shopify checkouts
SELECT MIN(created_at) AS min_date_checkouts, MAX(created_at) AS max_date_checkouts
FROM shopify_checkouts;



-- shopify_checkouts 
SELECT 
    COUNT(DISTINCT name) AS unique_carts,
    COUNT(*) AS line_items,
    COUNT(DISTINCT email) AS unique_emails,
    ROUND(AVG(lineitem_quantity), 2) AS avg_qty_per_line,
    MAX(lineitem_quantity) AS max_qty,
    COUNT(DISTINCT billing_country) AS countries
FROM shopify_checkouts;

