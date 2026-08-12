-- Time of the day patterns
SELECT
    substr(created_at, 12, 2) AS hour_of_day,
    COUNT(DISTINCT name) AS carts_started
FROM shopify_checkouts
GROUP BY hour_of_day
ORDER BY hour_of_day;


-- Day of week paterns 
SELECT
    CASE strftime('%w', substr(created_at, 1, 10))
        WHEN '0' THEN 'Sun'
        WHEN '1' THEN 'Mon'
        WHEN '2' THEN 'Tue'
        WHEN '3' THEN 'Wed'
        WHEN '4' THEN 'Thu'
        WHEN '5' THEN 'Fri'
        WHEN '6' THEN 'Sat'
    END AS day_of_week,
    COUNT(DISTINCT name) AS carts
FROM shopify_checkouts
GROUP BY day_of_week
ORDER BY strftime('%w', substr(created_at, 1, 10));


-- Which products are getting added to carts the most?
SELECT
    lineitem_name,
    COUNT(DISTINCT name) AS carts_containing,
    SUM(lineitem_quantity) AS total_units_added
FROM shopify_checkouts
WHERE lineitem_name IS NOT NULL
GROUP BY lineitem_name
ORDER BY carts_containing DESC
LIMIT 20;


-- Geography of carts
SELECT
    billing_country,
    COUNT(DISTINCT name) AS carts
FROM shopify_checkouts
GROUP BY billing_country
ORDER BY carts DESC
LIMIT 15;

-- Shipping Cost as a Driver
SELECT
    CASE
        WHEN shipping = 0 THEN '0 (free)'
        WHEN shipping / NULLIF(subtotal, 0) < 0.10 THEN '1: <10%'
        WHEN shipping / NULLIF(subtotal, 0) < 0.25 THEN '2: 10-25%'
        WHEN shipping / NULLIF(subtotal, 0) < 0.50 THEN '3: 25-50%'
        ELSE '4: >50%'
    END AS shipping_ratio_bucket,
    COUNT(DISTINCT name) AS carts
FROM shopify_checkouts
WHERE subtotal > 0
GROUP BY shipping_ratio_bucket
ORDER BY shipping_ratio_bucket;


-- email
SELECT 
    email,
    COUNT(DISTINCT name) AS cart_count
FROM shopify_checkouts
WHERE email IS NOT NULL
GROUP BY email
HAVING cart_count > 5
ORDER BY cart_count DESC
LIMIT 20;


-- Carts with extreme lineitem_quantity
SELECT 
    name, email, lineitem_name, lineitem_quantity, total
FROM shopify_checkouts
WHERE lineitem_quantity > 5
ORDER BY lineitem_quantity DESC;


-- A single email tied to multiple billing countries
SELECT
    email,
    COUNT(DISTINCT billing_country) AS countries,
    COUNT(DISTINCT name) AS carts
FROM shopify_checkouts
WHERE email IS NOT NULL
GROUP BY email
HAVING countries > 1
ORDER BY countries DESC;

--  Carts by year
SELECT substr(created_at, 1, 4) AS year, COUNT(DISTINCT name) AS carts
FROM shopify_checkouts
GROUP BY year
ORDER BY year;



--------------- Forensic 3-step template -------------------
-- Step 1: How widespread is the pattern?
SELECT COUNT(*) FROM shopify_checkouts WHERE lineitem_quantity > 5;

-- Step 2: Who exhibits it?
SELECT email, COUNT(*) AS line_items, MAX(lineitem_quantity) AS max_qty FROM shopify_checkouts WHERE lineitem_quantity > 5
GROUP BY email ORDER BY 2 DESC;

-- Step 3: What's the impact if we exclude it?
SELECT COUNT(DISTINCT name)  AS carts_remaining
FROM shopify_checkouts 
WHERE name NOT IN (
    SELECT name FROM shopify_checkouts WHERE lineitem_quantity > 5
);








