SELECT * FROM csat_analytics.csat_interactions;
SELECT * FROM csat_interactions LIMIT 10;

-- 1. Total interactions and overall data quality rate
SELECT
COUNT(*) AS total_interactions,
SUM(CASE WHEN csat_score = 0 THEN 1 ELSE 0 END) AS missing_score_count,
ROUND(SUM(CASE WHEN csat_score = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS
missing_score_pct
FROM csat_interactions;

-- 2. Average CSAT score by channel (excluding invalid zero scores)
SELECT channel,
ROUND(AVG(csat_score), 1) AS avg_csat,
COUNT(*) AS valid_responses
FROM csat_interactions
WHERE csat_score > 0
GROUP BY channel
ORDER BY avg_csat DESC;

-- 3. Average CSAT score by SLA / response_time
SELECT response_time,
ROUND(AVG(csat_score), 1) AS avg_csat,
COUNT(*) AS valid_responses
FROM csat_interactions
WHERE csat_score > 0
GROUP BY response_time
ORDER BY avg_csat DESC;

-- 4. Average CSAT score by contact reason
SELECT reason,
ROUND(AVG(csat_score), 1) AS avg_csat,
COUNT(*) AS valid_responses
FROM csat_interactions
WHERE csat_score > 0
GROUP BY reason
ORDER BY avg_csat DESC;

-- 5. Average CSAT score by call center
SELECT call_center_city,
ROUND(AVG(csat_score), 1) AS avg_csat,
COUNT(*) AS valid_responses
FROM csat_interactions
WHERE csat_score > 0
GROUP BY call_center_city;

-- 6. Sentiment distribution overall
SELECT sentiment,
COUNT(*) AS total,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM csat_interactions), 1) AS pct,
AVG(csat_score) AS avg_csat
FROM csat_interactions
GROUP BY sentiment
ORDER BY total DESC, avg_csat DESC;

-- 7. Interaction volume by channel
SELECT channel, COUNT(*) AS total_interactions
FROM csat_interactions
GROUP BY channel
ORDER BY total_interactions DESC;

-- 8. Interaction volume by contact reason
SELECT reason, COUNT(*) AS total_interactions
FROM csat_interactions
GROUP BY reason
ORDER BY total_interactions DESC;

-- 9. Daily call volume trend 
SELECT Call_Day, COUNT(*) AS total_calls
FROM csat_interactions
GROUP BY Call_Day
ORDER BY Call_Day;

-- 10. SLA performance distribution
SELECT response_time,
COUNT(*) AS total,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM csat_interactions), 1) AS pct
FROM csat_interactions
GROUP BY response_time
ORDER BY total DESC;