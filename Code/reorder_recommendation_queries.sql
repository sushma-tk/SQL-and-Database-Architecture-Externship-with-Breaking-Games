-- Print heavy. Your flagships: the top sellers you reorder confidently.
SELECT product_title, total_sales, net_items_sold, aov, total_pageviews
FROM fact_product_performance
WHERE total_sales > 0
ORDER BY total_sales DESC
LIMIT 10;


-- Print light. The next tier: ranks 11–15 by revenue — proven sellers that didn't make the flagship list.
SELECT product_title, total_sales, net_items_sold, aov, total_pageviews
FROM fact_product_performance
WHERE total_sales > 0
ORDER BY total_sales DESC
LIMIT 5 OFFSET 10;



-- Don't print. Your clear cuts: the weakest revenue lines of the whole period.
SELECT product_title, total_sales, net_items_sold, total_pageviews
FROM fact_product_performance
ORDER BY total_sales ASC
LIMIT 10;



-- Which Games Get Clicks But Don't Sell?
SELECT product_title,
       total_pageviews,
       net_items_sold,
       total_sales,
       ROUND(total_pageviews * 1.0 / net_items_sold, 0) AS views_per_unit
FROM fact_product_performance
WHERE total_pageviews > 0
  AND net_items_sold > 0
ORDER BY views_per_unit DESC
LIMIT 15;

-- sells fine, no traffic recorded
SELECT product_title, total_sales, net_items_sold, total_pageviews
FROM fact_product_performance
WHERE total_pageviews = 0
  AND total_sales > 500
ORDER BY total_sales DESC;