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


-- Time-of-Day Distribution
SELECT
    substr(created_at, 12, 2) AS hour,
    COUNT(DISTINCT name) AS carts
FROM shopify_checkouts
GROUP BY hour
ORDER BY hour;


-- Day of week
SELECT strftime('%w', substr(created_at, 1, 10)) AS dow,
       COUNT(DISTINCT name) AS carts
FROM shopify_checkouts GROUP BY dow ORDER BY dow;
 
-- Top 10 billing countries
SELECT billing_country, COUNT(DISTINCT name) AS carts
FROM shopify_checkouts
WHERE billing_country IS NOT NULL
GROUP BY billing_country
ORDER BY carts DESC LIMIT 10;

-- Cart size: line items per cart
SELECT n_lines, COUNT(*) AS carts FROM (
    SELECT name, COUNT(*) AS n_lines FROM shopify_checkouts GROUP BY name
)
GROUP BY n_lines ORDER BY n_lines;

-- Discount usage
SELECT CASE WHEN discount_code IS NULL THEN 'no code' ELSE 'code' END AS discount,
       COUNT(DISTINCT name) AS carts
FROM shopify_checkouts
GROUP BY discount;
