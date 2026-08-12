-- Meta campaigns Spend Breakdown
SELECT 
    delivery_status,
    COUNT(*) AS n_campaigns,
    ROUND(SUM(spend_usd), 2) AS total_spend
FROM meta_campaigns
GROUP BY delivery_status
ORDER BY total_spend DESC;



-- results column check for type of vlaues inside
SELECT typeof(results), COUNT(*)
FROM meta_campaigns
GROUP BY typeof(results);

