-- check clean_checkouts
SELECT
    (SELECT COUNT(DISTINCT name) FROM shopify_checkouts) AS raw_carts,
    (SELECT COUNT(DISTINCT name) FROM clean_checkouts) AS clean_carts,
    (SELECT COUNT(DISTINCT name) FROM shopify_checkouts) -
    (SELECT COUNT(DISTINCT name) FROM clean_checkouts) AS excluded;

	
-- Look at the carts you threw out 
SELECT lineitem_quantity, COUNT(DISTINCT name) AS carts
FROM shopify_checkouts
WHERE lineitem_quantity > 5
GROUP BY lineitem_quantity
ORDER BY lineitem_quantity DESC;


-- look at what was actually in them
SELECT name, lineitem_name, lineitem_quantity, lineitem_price,
       lineitem_quantity * lineitem_price AS line_total
FROM shopify_checkouts
WHERE name IN (
    SELECT name FROM shopify_checkouts WHERE lineitem_quantity > 5
)
ORDER BY lineitem_quantity DESC, name;



-- 
-- Naive: every cart ever recorded (2016–2025) vs July-only orders
SELECT 
    'Naive (mismatched windows)' AS metric,
    (SELECT COUNT(DISTINCT name) FROM shopify_checkouts) AS carts,
    (SELECT COUNT(DISTINCT order_name) FROM shopify_orders) AS orders,
    ROUND(100.0 * (1 - 
        (SELECT COUNT(DISTINCT order_name) FROM shopify_orders) * 1.0 /
        (SELECT COUNT(DISTINCT name) FROM shopify_checkouts)
    ), 1) AS abandonment_pct
UNION ALL
-- Honest: July 2025 clean carts vs July 2025 orders. This export only
-- holds carts that never finished, so the rate is
-- abandoned / (abandoned + completed).
SELECT 
    'Adjusted (July 2025, clean)',
    (SELECT COUNT(DISTINCT name) FROM clean_checkouts
     WHERE substr(created_at, 1, 7) = '2025-07'),
    (SELECT COUNT(DISTINCT order_name) FROM shopify_orders),
    ROUND(100.0 * 
        (SELECT COUNT(DISTINCT name) FROM clean_checkouts
         WHERE substr(created_at, 1, 7) = '2025-07') /
        ((SELECT COUNT(DISTINCT name) FROM clean_checkouts
          WHERE substr(created_at, 1, 7) = '2025-07') +
         (SELECT COUNT(DISTINCT order_name) FROM shopify_orders)), 1);