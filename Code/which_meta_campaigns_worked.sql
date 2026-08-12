-- Most Efficient (Lowest Cost Per Result)
SELECT 
    campaign_name,
    delivery_status,
    spend_usd,
    results,
    ROUND(cost_per_result, 2) AS cost_per_result_usd
FROM meta_campaigns
WHERE results IS NOT NULL AND results > 0
  AND delivery_status IN ('active', 'inactive')
ORDER BY cost_per_result ASC;

-- Highest CTR (Most Engaging)
SELECT 
    campaign_name,
    impressions,
    link_clicks,
    ROUND(ctr_link * 100, 3) AS ctr_pct,
    spend_usd
FROM meta_campaigns
WHERE impressions > 1000   -- exclude noise from low-volume campaigns
  AND ctr_link IS NOT NULL
ORDER BY ctr_link DESC
LIMIT 10;

-- Highest Volume (Most Results)
SELECT 
    campaign_name,
    spend_usd,
    results,
    ROUND(cost_per_result, 2) AS cost_per_result_usd
FROM meta_campaigns
WHERE results IS NOT NULL AND results > 0
ORDER BY results DESC
LIMIT 10;


-- The Bottom (Campaigns to Cut)
SELECT 
    campaign_name,
    delivery_status,
    spend_usd,
    impressions,
    link_clicks,
    results,
    ROUND(cost_per_result, 2) AS cost_per_result_usd
FROM meta_campaigns
WHERE spend_usd > 100   -- ignore campaigns that barely ran
  AND (
       (results IS NULL OR results = 0)            -- no conversions
    OR (cost_per_result > 100)                     -- absurdly expensive
    OR (ctr_link < 0.001 AND impressions > 10000)  -- weak CTR at scale
  )
ORDER BY spend_usd DESC;



-- result_indicator column
SELECT 
    result_indicator,
    COUNT(*) AS n_campaigns,
    ROUND(SUM(spend_usd), 2) AS total_spend
FROM meta_campaigns
GROUP BY result_indicator;