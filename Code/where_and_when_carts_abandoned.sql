--  Step 1: Find the Most Abandoned Products
SELECT
    sc.lineitem_name,
    COUNT(DISTINCT sc.name) AS carts_with_product,
    -- Count of orders in shopify_orders where product_title matches
    (SELECT COUNT(DISTINCT order_name)
     FROM shopify_orders so
     WHERE so.product_title = sc.lineitem_name) AS orders_with_product
FROM shopify_checkouts sc
WHERE sc.lineitem_name IS NOT NULL
GROUP BY sc.lineitem_name
ORDER BY carts_with_product DESC
LIMIT 20;
