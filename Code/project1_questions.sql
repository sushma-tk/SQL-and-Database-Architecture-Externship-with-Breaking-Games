-- Top 10 products by units sold this period.
SELECT product_title,
       SUM(net_items_sold) AS total_units_sold
FROM shopify_sales
GROUP BY product_title
ORDER BY total_units_sold DESC
LIMIT 10;



-- Top 10 products by total revenue.
SELECT product_title,
       SUM(total_sales) AS total_revenue
FROM shopify_sales
GROUP BY product_title
ORDER BY total_revenue DESC
LIMIT 10;



--  How many products are in the catalog?
SELECT COUNT(DISTINCT product_title) AS products_count
FROM shopify_sales;



-- What was the total Meta ad spend?
SELECT SUM(spend_usd) AS total_spentOn_meta_ads
FROM meta_campaigns;


-- How many unique checkout sessions started?
SELECT COUNT(DISTINCT name) AS unique_checkout_sessions
FROM shopify_checkouts;

