-- #####################################################################################
-- Find out the hospital hAS all the process score
SELECT measure_id, 
        COUNT(score) as score_cnt, 
        AVG(score) AS avg_score, 
        STDDEV(score) AS sd_score, 
        MIN(score) AS min_score, MAX(score) AS max_score
FROM hospital_score 
GROUP BY measure_id
ORDER BY sd_score DESC
LIMIT 10;