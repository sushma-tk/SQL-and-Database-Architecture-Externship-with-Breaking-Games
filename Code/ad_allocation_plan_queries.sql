-- For the Keep pile, start with the cheapest campaigns per result:
SELECT 
    campaign_name,
    delivery_status,
    spend_usd,
    results,
    ROUND(cost_per_result, 2) AS cost_per_result_usd
FROM meta_campaigns
WHERE results IS NOT NULL AND results > 0
  AND delivery_status IN ('active', 'inactive')
ORDER BY cost_per_result ASC
LIMIT 10;

-- Then add the high-volume workhorses. They may cost a little more per result, but they bring in the most overall:
SELECT 
    campaign_name,
    spend_usd,
    results,
    ROUND(cost_per_result, 2) AS cost_per_result_usd
FROM meta_campaigns
WHERE results IS NOT NULL AND results > 0
ORDER BY results DESC
LIMIT 10;

-- For the Cut pile, pull the campaigns that spent real money for poor outcomes:
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