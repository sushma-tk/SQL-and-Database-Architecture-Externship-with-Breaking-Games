-- referrer and page views
SELECT 
    COALESCE(NULLIF(referrer, ''), 'direct') AS referrer,
    SUM(pageviews) AS pageviews
FROM referrals
GROUP BY referrer
ORDER BY pageviews DESC
LIMIT 15;

SELECT COUNT(DISTINCT referrer) FROM referrals