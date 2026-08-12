
-- link shopify_sales table to the dim_product table
ALTER TABLE shopify_sales ADD COLUMN product_id INTEGER;

UPDATE shopify_sales
SET product_id = (
    SELECT product_id FROM dim_product
    WHERE dim_product.product_title = shopify_sales.product_title
);


-- check
SELECT ss.product_id, dp.product_title, ss.net_items_sold, ss.total_sales
FROM shopify_sales ss
INNER JOIN dim_product dp ON ss.product_id = dp.product_id
ORDER BY ss.total_sales DESC
LIMIT 5;