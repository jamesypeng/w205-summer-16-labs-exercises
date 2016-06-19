-- #####################################################################################
-- calculate correlation between variability and rating, and between avg score and rating,


SELECT corr(Survey_.summary_rating, t.avg_score) AS corr_rating_avgscore
      ,corr(Survey_.summary_rating, t.sd_score) AS corr_rating_sdscore
FROM Survey_ 
INNER JOIN 
(SELECT provider_id, 
        COUNT(measure_id) as score_cnt, 
        SUM(score) AS agg_score, AVG(score) AS avg_score, 
        STDDEV(score) AS sd_score
FROM hospital_score 
WHERE score > 0
GROUP BY provider_id
) as t ON t.Provider_ID=Survey_.Provider_ID 
;


