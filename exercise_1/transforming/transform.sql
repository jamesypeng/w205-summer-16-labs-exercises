
-- #################################################
-- Process Score
DROP TABLE  IF EXISTS hospital_score;
CREATE TABLE hospital_score
(
    Provider_ID string,
    domain STRING,
    measure_id string,
    score DECIMAL(8,4)
);
INSERT INTO TABLE hospital_score
SELECT provider_id, 'Process' ,'SCIP_INF_2', CAST(regexp_extract(SCIP_INF_2, '[0-9]*', 0) AS DECIMAL(8,4)) 
FROM hvbp_hai
WHERE CAST(regexp_extract(SCIP_INF_2, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
;

INSERT INTO TABLE hospital_score
SELECT provider_id,'Process' , 'SCIP_INF_3', CAST(regexp_extract(SCIP_INF_3, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_hai
WHERE CAST(regexp_extract(SCIP_INF_3, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
;

INSERT INTO TABLE hospital_score
SELECT provider_id, 'Process' ,'SCIP_INF_9', CAST(regexp_extract(SCIP_INF_9, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_hai
WHERE CAST(regexp_extract(SCIP_INF_9, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
;

INSERT INTO TABLE hospital_score
SELECT provider_id, 'Process' , 'PN_6', CAST(regexp_extract(PN_6, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_pn
WHERE CAST(regexp_extract(PN_6, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
;

INSERT INTO TABLE hospital_score
SELECT provider_id, 'Process' , 'IMM_2', CAST(regexp_extract(IMM_2, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_imm2
WHERE CAST(regexp_extract(IMM_2, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
;

INSERT INTO TABLE hospital_score
SELECT provider_id, 'Process' , 'SCIP_CARD_2', CAST(regexp_extract(SCIP_CARD_2, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_scip
WHERE CAST(regexp_extract(SCIP_CARD_2, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
;

INSERT INTO TABLE hospital_score
SELECT provider_id,'Process' ,  'SCIP_VTE_2', CAST(regexp_extract(SCIP_VTE_2, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_scip
WHERE CAST(regexp_extract(SCIP_VTE_2, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
;


INSERT INTO TABLE hospital_score
SELECT provider_id, 'Outcome', 'MORT_30_AMI', CAST(regexp_extract(MORT_30_AMI, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_outcome
WHERE CAST(regexp_extract(MORT_30_AMI, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
; 

INSERT INTO TABLE hospital_score
SELECT provider_id, 'Outcome', 'MORT_30_HF', CAST(regexp_extract(MORT_30_HF, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_outcome
WHERE CAST(regexp_extract(MORT_30_HF, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
; 


INSERT INTO TABLE hospital_score
SELECT provider_id, 'Outcome',  'MORT_30_PN', CAST(regexp_extract(MORT_30_PN, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_outcome
WHERE CAST(regexp_extract(MORT_30_PN, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
; 

INSERT INTO TABLE hospital_score
SELECT provider_id, 'Outcome', 'PSI_90', CAST(regexp_extract(PSI_90, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_outcome
WHERE CAST(regexp_extract(PSI_90, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
; 

INSERT INTO TABLE hospital_score
SELECT provider_id, 'Outcome', 'Combined_SSI', CAST(regexp_extract(Combined_SSI, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_outcome
WHERE CAST(regexp_extract(Combined_SSI, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
; 

------------------------------------------------------------------------------
INSERT INTO TABLE hospital_score
SELECT provider_id, 'Outcome', 'HAI_1', CAST(regexp_extract(HAI_1, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_outcome
WHERE CAST(regexp_extract(HAI_1, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
; 

INSERT INTO TABLE hospital_score
SELECT provider_id, 'Outcome', 'HAI_2', CAST(regexp_extract(HAI_2, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_outcome
WHERE CAST(regexp_extract(HAI_2, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
; 

INSERT INTO TABLE hospital_score
SELECT provider_id, 'Outcome', 'HAI_3', CAST(regexp_extract(HAI_3, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_outcome
WHERE CAST(regexp_extract(HAI_3, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
; 
INSERT INTO TABLE hospital_score
SELECT provider_id, 'Outcome', 'HAI_4', CAST(regexp_extract(HAI_4, '[0-9]*', 0) AS DECIMAL(8,4))
FROM hvbp_outcome
WHERE CAST(regexp_extract(HAI_4, '[0-9]*', 0) AS DECIMAL(8,4)) IS NOT NULL
; 

-- #####################################################################################
-- Find out the hospital has all the process score

SELECT provider_id, COUNT(measure_id) AS cnt
FROM Process_score_
WHERE score > 0
GROUP BY provider_id
HAVING cnt >= 7
;


SELECT provider_id, COUNT(measure_id) AS cnt
FROM Outcome_score_
WHERE score > 0
GROUP BY provider_id
HAVING cnt >= 8
;





-- #####################################
-- # Survey Result
DROP TABLE IF EXISTS Survey_;
CREATE TABLE Survey_
(
    Provider_ID STRING,
    summary_rating  DECIMAL(8,4)
);

INSERT INTO TABLE Survey_
SELECT provider_id, CAST(patient_survey_star_rating AS DECIMAL) AS summary_rating
FROM hcahps_hospital
WHERE  hcahps_measure_id ='H_STAR_RATING'  
AND CAST(patient_survey_star_rating AS DECIMAL) IS NOT NULL
;


-- #########################################################333
-- How many measure_id
-- SELECT COUNT(DISTINCT measure_id) AS measure_id_cnt
-- FROM Procedure_
-- ;
-- 54 Measurement ID


-------------------
-- Calculate the mean (of the score) and stddev (of the score) for each measurement ID 
-- Then calculate the z-score for each measurement of each hospital
-- Then find the average z-score and stddev of the measurements for the hospital 
DROP TABLE IF EXISTS Hospital_zscore;
CREATE TABLE hospital_zscore
(
    Provider_ID STRING,
    procedure_cnt INT,
    avg_zscore DECIMAL(8,4),
    sd_zscore DECIMAL(8,4),
    cv_zscore DECIMAL(8,4),
    min_zscore DECIMAL(8,4),
    max_zscore DECIMAL(8,4)    
);

INSERT INTO TABLE hospital_zscore
SELECT Provider_ID, COUNT(z_score) AS proc_cnt, AVG(z_score) AS avg_zscore, STDDEV(z_score) AS sd_zscore,
    STDDEV(z_score)/AVG(z_score) AS cv_zscore, 
    MIN(z_score) as min_zscore, MAX(z_score) AS max_zscore
FROM (
    SELECT Provider_ID, Procedure_.measure_id, score, avg_score, sd_score,
        CASE 
            WHEN higher_better = '1' THEN
                (score-avg_score)/sd_score 
            ELSE
                (avg_score-score)/sd_score 
        END AS z_score
    FROM Procedure_   
    LEFT JOIN (
        SELECT measure_id, 
        COUNT(score) AS hospital_cnt,  
        AVG(score) AS avg_score, 
        STDDEV(score) AS sd_score, 
        STDDEV(score)/AVG(score) AS cv_score,
        SUM(higher_better),
        MAX(score) AS max,
        MIN(score) AS min
    FROM Procedure_
    GROUP BY measure_id
    )
    AS tbl_mean_std on (tbl_mean_std.measure_id = Procedure_.measure_id)
) AS c 
GROUP BY Provider_ID
;

-- ###########################
-- Outcome
DROP TABLE IF EXISTS outcome_;
CREATE TABLE outcome
(
    Provider_ID STRING,
    
)

---
SELECT  Hospital_.Hospital_name AS name, state , hospital_zscore.procedure_cnt AS proc_cnt,
        hospital_zscore.avg_zscore,
        hospital_zscore.sd_zscore, 
        (hospital_zscore.avg_zscore)/(hospital_zscore.sd_zscore) AS quality_ratio,
        Survey_.summary_rating AS rating
FROM hospital_zscore
INNER JOIN  Survey_ ON hospital_zscore.provider_id = Survey_.provider_id
LEFT JOIN Hospital_ ON hospital_zscore.provider_id  = Hospital_.provider_id
WHERE  Survey_.summary_rating IS NOT NULL
AND hospital_zscore.procedure_cnt >= 6
ORDER BY quality_ratio DESC
LIMIT 30
;
---------------------------------------
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/YourTableDir'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
SELECT * FROM table WHERE id > 100;



