-- Products Got the Facebook Traffic
SELECT 
    dp.product_title,
    COALESCE(SUM(CASE WHEN dr.channel = 'Paid Social' THEN r.pageviews END), 0) AS fb_pageviews,
    COALESCE(ss.net_items_sold, 0) AS units_sold,
    COALESCE(ROUND(ss.total_sales, 2), 0) AS revenue
FROM dim_product dp
LEFT JOIN referrals r ON r.landing_page LIKE '%' || dp.product_slug || '%'
LEFT JOIN dim_referrer dr ON COALESCE(NULLIF(r.referrer, ''), 'direct') = dr.referrer
LEFT JOIN shopify_sales ss ON ss.product_id = dp.product_id
GROUP BY dp.product_id, dp.product_title, ss.net_items_sold, ss.total_sales
HAVING fb_pageviews > 100
ORDER BY fb_pageviews DESC
LIMIT 15;