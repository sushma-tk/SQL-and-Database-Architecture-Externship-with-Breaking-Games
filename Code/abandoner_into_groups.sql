-- Sorts Customers into These Groups
WITH email_stats AS (
    SELECT
        email,
        COUNT(DISTINCT name) AS cart_count,
        MAX(lineitem_quantity) AS max_qty,
        COUNT(DISTINCT billing_country) AS country_count
    FROM shopify_checkouts
    WHERE email IS NOT NULL
    GROUP BY email
)
SELECT
    email,
    cart_count,
    max_qty,
    CASE
        WHEN max_qty > 5 OR cart_count > 5 OR country_count > 1 THEN 'Risky'
        WHEN cart_count >= 2 THEN 'Repeat real'
        ELSE 'Real (one-time)'
    END AS segment
FROM email_stats
ORDER BY cart_count DESC
LIMIT 20;




-- Counts Each Group
WITH email_stats AS (
    SELECT
        email,
        COUNT(DISTINCT name) AS cart_count,
        MAX(lineitem_quantity) AS max_qty,
        COUNT(DISTINCT billing_country) AS country_count
    FROM shopify_checkouts
    WHERE email IS NOT NULL
    GROUP BY email
),
segmented AS (
    SELECT
        email,
        cart_count,
        CASE
            WHEN max_qty > 5 OR cart_count > 5 OR country_count > 1 THEN 'Risky'
            WHEN cart_count >= 2 THEN 'Repeat real'
            ELSE 'Real (one-time)'
        END AS segment
    FROM email_stats
)
SELECT
    segment,
    COUNT(*) AS customers,
    SUM(cart_count) AS carts,
    ROUND(100.0 * SUM(cart_count) /
        (SELECT COUNT(DISTINCT name) FROM shopify_checkouts), 1) AS pct_of_all_carts
FROM segmented
GROUP BY segment
ORDER BY customers DESC;