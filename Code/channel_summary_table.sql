-- Channel summary table 
WITH meta_spend AS (
    SELECT ROUND(SUM(spend_usd), 2) AS total_spend
    FROM meta_campaigns
)
SELECT
    dr.channel,
    SUM(r.pageviews) AS pageviews,
    SUM(r.checkout_sessions) AS checkouts,
    ROUND(100.0 * SUM(r.checkout_sessions) / NULLIF(SUM(r.pageviews), 0), 3) AS checkout_rate_pct,
    CASE
        WHEN dr.channel = 'Paid Social' THEN (SELECT total_spend FROM meta_spend)
        WHEN dr.channel = 'Other'       THEN NULL   -- holds Google ad networks; spend exists but isn't visible
        ELSE 0                                      -- verified no ad spend
    END AS spend_usd,
    CASE
        WHEN dr.channel = 'Paid Social'
        THEN ROUND((SELECT total_spend FROM meta_spend) * 1.0 / NULLIF(SUM(r.pageviews), 0), 4)
        ELSE NULL
    END AS cost_per_pageview
FROM referrals r
JOIN dim_referrer dr
  ON COALESCE(NULLIF(r.referrer, ''), 'direct') = dr.referrer
GROUP BY dr.channel
ORDER BY pageviews DESC;