-- drop fact_product_performance table if existis
DROP TABLE IF EXISTS fact_product_performance;


-- create fact_product_performance table
CREATE TABLE fact_product_performance AS
SELECT
    dp.product_id,
    dp.product_title,
    COALESCE(ss.total_sales, 0) AS total_sales,
    COALESCE(ss.net_items_sold, 0) AS net_items_sold,
    CASE
        WHEN COALESCE(ss.net_items_sold, 0) > 0
        THEN ROUND(ss.total_sales * 1.0 / ss.net_items_sold, 2)
        ELSE 0
    END AS aov,
    COALESCE((
        SELECT SUM(r.pageviews) 
		FROM referrals r
        WHERE r.landing_page = '/products/' || dp.product_slug
    ), 0) AS total_pageviews
FROM dim_product dp
LEFT JOIN shopify_sales ss ON ss.product_id = dp.product_id;



-- check 
SELECT COUNT(*) FROM fact_product_performance;  -- expected: 99
SELECT * FROM fact_product_performance ORDER BY total_sales DESC LIMIT 3;