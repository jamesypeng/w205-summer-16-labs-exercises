### Best Hospital

#### Process Care Domain
According to CMS website, [Process Care Domain](https://www.medicare.gov/hospitalcompare/data/clinical-process-of-care.html) contains 8 measurements,

* AMI-7a: Heart attack patients given fibrinolytic medication within 30 minutes of arrival
* PN-6: Pneumonia patients given the most appropriate initial antibiotic(s)
* SCIP-Card-2: Surgery patients who were taking heart drugs called beta blockers before coming to the hospital, who were kept on the beta blockers during the period just before and after their surgery
* SCIP-VTE-2: Patients who got treatment at the right time (within 24 hours before or after their surgery) to help prevent blood clots after certain types of surgery
* SCIP–Inf–2: Surgery patients who are given the right kind of antibiotic to help prevent infection
* SCIP–Inf–3: Surgery patients whose preventive antibiotics are stopped at the right time (within 24 hours after surgery)
* SCIP–Inf–9: Surgery patients whose urinary catheters were removed on the first or second day after surgery
* IMM-2: Patients assessed and given influenza vaccination

However, there are only few hospitals having data for the AM_7a procedure, so I use the other 7 measurement scores.

#### Outcome Domain

There are 9 outcome domain measure scores, including MORT-30-AMI, MORT-30-HF, MORT-30-PN, PSI-90, HAI-1, HAI-1_, HAI-2, HAI-3 , HAI-4, and Combined SSI.

I identify the best hospital based on the following criteria
* Most of the hospitals did not report scores on all measurements. I filter the hospitals which have at least report 8 measurements, and none of the measurements has score of zero.
* Sort by average score, then the standard deviation. The standard deviation is a measurement of process and outcome consistency. The lesser the standard deviation is, the more consistency the hospital quality is. 

```
SELECT t.provider_id, h.Hospital_Name, 
        COUNT(measure_id) as score_cnt, 
        SUM(t.score) AS agg_score, AVG(t.score) AS avg_score, 
        STDDEV(t.score) AS sd_score, 
        MIN(t.score) AS min_score, MAX(t.score) AS max_score
FROM hospital_score AS t
LEFT JOIN hospital_info AS h ON t.Provider_ID=h.Provider_ID AND t.score > 0
GROUP BY t.provider_id,  h.Hospital_Name 
HAVING score_cnt >= 8
ORDER BY avg_score DESC, sd_score ASC
LIMIT 10;
```
```{bash}
+----------------+--------------------------------------+------------+------------+-------------+---------------------+------------+------------+--+
| t.provider_id  |           h.hospital_name            | score_cnt  | agg_score  |  avg_score  |      sd_score       | min_score  | max_score  |
+----------------+--------------------------------------+------------+------------+-------------+---------------------+------------+------------+--+
| 390185         | LEHIGH VALLEY HOSPITAL - HAZLETON    | 14         | 140        | 10          | 0.0                 | 10         | 10         |
| 340148         | NOVANT HEALTH MEDICAL PARK HOSPITAL  | 9          | 90         | 10          | 0.0                 | 10         | 10         |
| 050580         | LA PALMA INTERCOMMUNITY HOSPITAL     | 10         | 99         | 9.9         | 0.3                 | 9          | 10         |
| 460015         | LOGAN REGIONAL HOSPITAL              | 10         | 98         | 9.8         | 0.6                 | 8          | 10         |
| 200020         | YORK HOSPITAL                        | 9          | 88         | 9.77777778  | 0.6285393610547089  | 8          | 10         |
| 670025         | THE HEART HOSPITAL BAYLOR PLANO      | 8          | 78         | 9.75        | 0.4330127018922193  | 9          | 10         |
| 170023         | ST CATHERINE HOSPITAL                | 12         | 117        | 9.75        | 0.5951190357119042  | 8          | 10         |
| 110150         | OCONEE REGIONAL MEDICAL CENTER       | 11         | 107        | 9.72727273  | 0.8624393618641034  | 7          | 10         |
| 180127         | FRANKFORT REGIONAL MEDICAL CENTER    | 11         | 106        | 9.63636364  | 0.8813963377120598  | 7          | 10         |
| 100252         | RAULERSON HOSPITAL                   | 11         | 106        | 9.63636364  | 0.8813963377120598  | 7          | 10         |
+----------------+--------------------------------------+------------+------------+-------------+---------------------+------------+------------+--+

```

