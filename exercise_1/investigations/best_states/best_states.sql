-- #####################################################################################
-- Find out the hospital hAS all the process score
SELECT h.state, 
        COUNT(measure_id) as score_cnt, 
        SUM(t.score) AS agg_score, AVG(t.score) AS avg_score, 
        STDDEV(t.score) AS sd_score, 
        MIN(t.score) AS min_score, MAX(t.score) AS max_score
FROM hospital_score AS t
LEFT JOIN hospital_info AS h ON t.Provider_ID=h.Provider_ID AND t.score > 0
GROUP BY h.state
ORDER BY avg_score DESC, sd_score ASC
LIMIT 10;