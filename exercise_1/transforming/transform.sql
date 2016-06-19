-- #######################################
-- Hospital Entity
DROP TABLE  IF EXISTS Hospital_;
CREATE TABLE Hospital_
(
    Provider_ID string,
    Hospital_name string,
    state string
);
INSERT OVERWRITE TABLE Hospital_    
SELECT Provider_ID, Hospital_name, state
FROM  Hospital_Info;

-- #######################################
-- # Process Care Entity
DROP TABLE  IF EXISTS Process_domain_;
CREATE TABLE Process_domain_
(
    Provider_ID string,
    Hospital_name string,
    state string,
    measure_id string,
    measure_name string,
    score DECIMAL(8,4),
    higher_better string
);
DROP VIEW IF EXISTS vProcess_domain_;
CREATE VIEW vProcess_domain_ AS
SELECT Provider_ID, Hospital_name, state, measure_id, measure_name, CAST(score AS DECIMAL(8,4)), 
    CASE  
        WHEN measure_id IN ('ED_1b', 'ED_2b', 'OP_1', 'OP_3b', 'OP_5', 
                            'OP_18b', 'OP_20', 'OP_21', 'OP_22',
                            'PC_01','VTE_6'
                            ) THEN '0' 
        ELSE '1' 
    END as higher_better 
FROM Timely_and_Effective_Care
-- WHERE measure_id NOT IN ('EDV')
WHERE measure_id IN (--'AMI_7a', 
'PN_6', 
'SCIP_CARD_2',
'SCIP_VTE_2',
'SCIP_INF_2',
'SCIP_INF_3',
'SCIP_INF_9',
'IMM_2')
;
INSERT INTO TABLE Process_domain_
SELECT vProcess_domain_.*  
FROM vProcess_domain_
INNER JOIN
(
SELECT provider_id, COUNT(score) as score_cnt
FROM vProcess_domain_
WHERE score IS NOT NULL
GROUP BY provider_id
HAVING score_cnt >= 7
) AS c on vProcess_domain_.Provider_ID = c.provider_id
;
DROP VIEW IF EXISTS vProcess_domain_;




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
AND  CAST(patient_survey_star_rating AS DECIMAL) IS NOT NULL
;


-- #########################################################333
-- How many measure_id
SELECT COUNT(DISTINCT measure_id) AS measure_id_cnt
FROM Procedure_
;
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



