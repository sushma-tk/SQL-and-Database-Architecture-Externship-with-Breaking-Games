-- Three queries that connect traffic to sales across the catalog. Paste each query and a one-line summary of what it returned.

-- Query 1 — Products with sales but mysterious origins. Products with sales rows but no referral traffic matching their slug.
SELECT COUNT(*) AS products_with_no_traffic
FROM dim_product dp
INNER JOIN shopify_sales ss ON dp.product_id = ss.product_id
LEFT JOIN referrals r ON r.landing_page LIKE '%' || dp.product_slug || '%'
WHERE r.landing_page IS NULL;

-- Query 2 — Products with traffic but no sales. Traffic comes in, nobody buys.
SELECT COUNT(DISTINCT dp.product_id) AS products_traffic_no_sales-
FROM dim_product dp
INNER JOIN referrals r ON r.landing_page LIKE '%' || dp.product_slug || '%'
LEFT JOIN shopify_sales ss ON dp.product_id = ss.product_id
WHERE ss.product_id IS NULL;

-- Query 3 — The full story. Every product with total_sales, total_pageviews, and a pageviews-per-unit-sold ratio.
SELECT dp.product_title,
       ss.total_sales,
       ss.net_items_sold,
       SUM(r.pageviews) AS total_pageviews,
       CASE
           WHEN ss.net_items_sold > 0
           THEN ROUND(SUM(r.pageviews) * 1.0 / ss.net_items_sold, 1)
           ELSE NULL
       END AS pageviews_per_unit
FROM dim_product dp
LEFT JOIN shopify_sales ss ON dp.product_id = ss.product_id
LEFT JOIN referrals r ON r.landing_page LIKE '%' || dp.product_slug || '%'
GROUP BY dp.product_title
ORDER BY ss.total_sales DESC;
