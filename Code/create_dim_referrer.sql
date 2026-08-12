-- Step 1: Look at the Actual Data
SELECT 
    COALESCE(NULLIF(referrer, ''), 'direct') AS referrer,
    SUM(pageviews) AS pageviews
FROM referrals
GROUP BY referrer
ORDER BY pageviews DESC
LIMIT 50;

-- Step 2: Build dim_referrer
DROP TABLE IF EXISTS dim_referrer;
CREATE TABLE dim_referrer (
    referrer TEXT PRIMARY KEY,
    channel TEXT,
    channel_type TEXT
);

INSERT INTO dim_referrer (referrer)
SELECT DISTINCT COALESCE(NULLIF(referrer, ''), 'direct') FROM referrals;

-- Paid Social
UPDATE dim_referrer SET channel = 'Paid Social', channel_type = 'Paid'
WHERE referrer IN ('facebook', 'instagram', 'meta');

-- Organic Search
UPDATE dim_referrer SET channel = 'Organic Search', channel_type = 'Organic'
WHERE referrer IN ('google', 'bing', 'duckduckgo', 'yahoo!', 'yandex',
                   'brave', 'ecosia', 'baidu', 'chatgpt', 'perplexity');

-- Direct
UPDATE dim_referrer SET channel = 'Direct', channel_type = 'Owned'
WHERE referrer = 'direct';

-- Community
UPDATE dim_referrer SET channel = 'Community', channel_type = 'Organic'
WHERE referrer IN ('boardgamegeek', 'boardgamearena', 'reddit', 'kickstarter',
                   'gencon', 'paxsite', 'mensamindgames', 'printplaygames',
                   'boardlife', 'megacatstudios', 'spieletastisch', 'mapyourshow',
                   'youtube', 'tiktok', 'pinterest', 'nextdoor', 'linkedin',
                   'nytimes', 'rafalreyzer', 'brokescholar');

-- Email
UPDATE dim_referrer SET channel = 'Email', channel_type = 'Owned'
WHERE referrer IN ('klaviyo', 'gmail', 'deref-gmx', 'office', 'live');

-- Catch-all (always last)
UPDATE dim_referrer SET channel = 'Other', channel_type = 'Other'
WHERE channel IS NULL;



-- verify 
SELECT channel, channel_type, COUNT(*) AS n_referrers
FROM dim_referrer
GROUP BY channel, channel_type
ORDER BY n_referrers DESC;


-- check 
SELECT d.referrer, SUM(r.pageviews) AS pageviews
FROM dim_referrer d
JOIN referrals r ON d.referrer = COALESCE(NULLIF(r.referrer, ''), 'direct')
WHERE d.channel = 'Other'
GROUP BY d.referrer
ORDER BY pageviews DESC
LIMIT 20;