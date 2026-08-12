-- Top 25 products by revenue. Include columns for Total sales, units sold, AOV
SELECT 
	product_title, 
	total_sales, 
	net_items_sold, 
	ROUND(total_sales/net_items_sold,2) AS AOV,
	ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS revenue_rank
FROM shopify_sales
WHERE net_items_sold > 0
ORDER BY total_sales DESC
LIMIT 25;