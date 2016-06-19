DROP TABLE IF EXISTS Hospital_Info;
CREATE EXTERNAL TABLE Hospital_Info
(Provider_ID string,
Hospital_name string,

state string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ":",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/Hospital_Info';



DROP TABLE IF EXISTS hvbp_hai;
CREATE EXTERNAL TABLE hvbp_hai
(Provider_ID string,
SCIP_INF_2 STRING,
SCIP_INF_3 STRING,
SCIP_INF_9 STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ":",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/hvbp_hai';



DROP TABLE IF EXISTS hvbp_imm2;
CREATE EXTERNAL TABLE hvbp_imm2
(Provider_ID string,
IMM_2 STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ":",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/hvbp_imm2';


DROP TABLE IF EXISTS hvbp_outcome;
CREATE EXTERNAL TABLE hvbp_outcome
(Provider_ID string,
MORT_30_AMI STRING,
MORT_30_HF STRING,
MORT_30_PN STRING,
PSI_90 STRING,
HAI_1 STRING,
HAI_2 STRING,
Combined_SSI STRING,
HAI_3 STRING,
HAI_4 STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ":",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/hvbp_outcome';


DROP TABLE IF EXISTS hvbp_pn;
CREATE EXTERNAL TABLE hvbp_pn
(Provider_ID string,
PN_6 STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ":",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/hvbp_pn';


DROP TABLE IF EXISTS hvbp_scip;
CREATE EXTERNAL TABLE hvbp_scip
(Provider_ID string,
SCIP_CARD_2 STRING,
SCIP_VTE_2 STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ":",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/hvbp_scip';

-- #########################################################################


DROP TABLE IF EXISTS HCAHPS_Hospital;
CREATE EXTERNAL TABLE HCAHPS_Hospital
(
Provider_ID string,
Hospital_Name string,
Address string,
City string,
State string,
ZIP string,
County  string,
Phone  string,
HCAHPS_Measure_ID  string,
HCAHPS_Question  string,
HCAHPS_Answer_Description string,
Patient_Survey_Star_Rating  string,
Patient_Survey_Star_Rating_Footnote  string,
HCAHPS_Answer_Percent  string,
HCAHPS_Answer_Percent_Footnote  string,
HCAHPS_Linear_Mean_Value  string,
Number_of_Completed_Surveys  string,
Number_of_Completed_Surveys_Footnote  string,
Survey_Response_Rate_Percent  string,
Survey_Response_Rate_Percent_Footnote  string,
Start_Date  string,
End_Date string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/HCAHPS_Hospital';


