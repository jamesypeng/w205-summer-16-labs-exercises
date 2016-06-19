### Process Variability


* The correlation between suvey rating and hospital process average score is 0.17. The Practical Significance is small (between 0.1 ~ 0.3). 
* The correlation between suvey rating and hospital process standard  is -0.13. The Practical Significance is small (between 0.1 ~ 0.3)
* It makes business sense that the average process score has positive correlation with patient survey rating, and standard deviation of process score has negative correlation with rating. In other words, customers are less satisfied when the process has higher variation and are more satisfied when the overall health care procesdures are better performed. 


```
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
```
```{bash}
+-----------------------+-----------------------+--+
| corr_rating_avgscore  |  corr_rating_sdscore  |
+-----------------------+-----------------------+--+
| 0.17488306737953485   | -0.13551478734094513  |
+-----------------------+-----------------------+--+

```

