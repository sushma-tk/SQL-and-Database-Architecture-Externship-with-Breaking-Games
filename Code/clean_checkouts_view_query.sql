-- clean_checkout VIEW
DROP VIEW IF EXISTS clean_checkouts;

CREATE VIEW clean_checkouts AS
SELECT *
FROM shopify_checkouts
WHERE
    -- Exclude the WHOLE cart if any of its lines has a suspicious quantity
    name NOT IN (
        SELECT name FROM shopify_checkouts
        WHERE lineitem_quantity > 5
    );
	
	
	
-- How to Check That the View Worked
SELECT
    COUNT(DISTINCT name) AS clean_carts,
    -- compare to raw shopify_checkouts
    (SELECT COUNT(DISTINCT name) FROM shopify_checkouts) AS raw_carts
FROM clean_checkouts;
-- Expect 1,034 clean carts vs 1,062 raw. The quantity rule removes 28.