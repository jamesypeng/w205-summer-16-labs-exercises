-- #####################################################################################
-- Find out the hospital hAS all the process score
SELECT t.provider_id, h.Hospital_Name, 
        COUNT(measure_id) as score_cnt, 
        SUM(t.score) AS agg_score, AVG(t.score) AS avg_score, 
        STDDEV(t.score) AS sd_score, 
        MIN(t.score) AS min_score, MAX(t.score) AS max_score
FROM hospital_score AS t
LEFT JOIN hospital_info AS h ON t.Provider_ID=h.Provider_ID AND t.score > 0
GROUP BY t.provider_id,  h.Hospital_Name 
HAVING score_cnt >= 10
ORDER BY avg_score DESC, agg_score DESC
LIMIT 10;