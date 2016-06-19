
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

-- ####################
-- Outcome Domain
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
