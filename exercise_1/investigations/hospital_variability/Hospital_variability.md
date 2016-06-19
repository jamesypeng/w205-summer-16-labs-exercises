### Process Variability

HAI_4 process has the highest variability.

I identify the process that has highest variability by 
* Sort then the standard deviation. The standard deviation is a measurement of process and outcome consistency. The larger the standard deviation is, the more variation the process quality is. 

```
SELECT measure_id, 
        COUNT(score) as score_cnt, 
        AVG(score) AS avg_score, 
        STDDEV(score) AS sd_score, 
        MIN(score) AS min_score, MAX(score) AS max_score
FROM hospital_score 
GROUP BY measure_id
ORDER BY sd_score DESC
LIMIT 10;
```
```{bash}
+---------------+------------+-------------+---------------------+------------+------------+--+
|  measure_id   | score_cnt  |  avg_score  |      sd_score       | min_score  | max_score  |
+---------------+------------+-------------+---------------------+------------+------------+--+
| HAI_4         | 838        | 4.07159905  | 4.075320690674145   | 0          | 10         |
| HAI_1         | 1913       | 4.42603241  | 3.9191904965761757  | 0          | 10         |
| SCIP_CARD_2   | 2723       | 5.67719427  | 3.8296087217265815  | 0          | 10         |
| HAI_3         | 1983       | 3.09631871  | 3.8174826179517902  | 0          | 10         |
| SCIP_INF_2    | 2860       | 3.70174825  | 3.8132356568123393  | 0          | 10         |
| PN_6          | 2883       | 4.78113077  | 3.7663687618527875  | 0          | 10         |
| HAI_2         | 2172       | 3.303407    | 3.7098405045445224  | 0          | 10         |
| Combined_SSI  | 2006       | 3.32402792  | 3.662573901570444   | 0          | 10         |
| SCIP_INF_3    | 2852       | 4.82713885  | 3.6454826824075455  | 0          | 10         |
| MORT_30_PN    | 2786       | 4.21572146  | 3.4683137216428372  | 0          | 10         |
+---------------+------------+-------------+---------------------+------------+------------+--+

```

