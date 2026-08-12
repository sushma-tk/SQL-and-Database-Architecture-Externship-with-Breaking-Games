-- Rank Channels by Checkout Efficiency
SELECT 
    dr.channel,
    SUM(r.pageviews) AS pageviews,
    SUM(r.checkout_sessions) AS checkouts,
    ROUND(100.0 * SUM(r.checkout_sessions) / NULLIF(SUM(r.pageviews), 0), 3) AS conv_pct
FROM referrals r
JOIN dim_referrer dr ON COALESCE(NULLIF(r.referrer, ''), 'direct') = dr.referrer
GROUP BY dr.channel
HAVING SUM(r.pageviews) > 100
ORDER BY conv_pct DESC;