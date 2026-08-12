--
WITH fb_spend AS (
    SELECT ROUND(SUM(spend_usd), 2) AS total_spend
    FROM meta_campaigns
    WHERE delivery_status IN ('active', 'inactive')  -- ran at some point
),
fb_traffic AS (
    SELECT 
        SUM(r.pageviews) AS pageviews,
        SUM(r.checkout_sessions) AS checkouts
    FROM referrals r
    JOIN dim_referrer dr ON COALESCE(NULLIF(r.referrer, ''), 'direct') = dr.referrer
    WHERE dr.channel = 'Paid Social'
)
SELECT 
    fs.total_spend,
    ft.pageviews,
    ft.checkouts,
    ROUND(fs.total_spend / NULLIF(ft.pageviews, 0), 4) AS cost_per_pageview,
    ROUND(fs.total_spend / NULLIF(ft.checkouts, 0), 2) AS cost_per_checkout_session
FROM fb_spend fs, fb_traffic ft;
