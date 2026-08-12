-- Create the table dim_product
CREATE TABLE dim_product (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_title TEXT NOT NULL,
    product_slug TEXT,
    category TEXT
);

-- fill product_title from shopify_sales
INSERT INTO dim_product (product_title)
SELECT DISTINCT product_title FROM shopify_sales;

-- check -> 99 products
SELECT COUNT(*) FROM dim_product;


-- add slugs
UPDATE dim_product
SET product_slug = LOWER(
    REPLACE(REPLACE(REPLACE(product_title, ' ', '-'), ':', ''), '*', '')
);

-- check 
SELECT product_id, product_title, product_slug FROM dim_product LIMIT 10;