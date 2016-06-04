DROP TABLE IF EXISTS Hospital_Info;
CREATE EXTERNAL TABLE Hospital_Info
(Provider_ID string,
Hospital_name string,
Address string,
City string,
state string,
ZipCode string,
County string,
PhoneNumber string,
type string,
Ownership string,
EmerencyService string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/Hospital_Info';

DROP TABLE IF EXISTS Measure_Dates;
CREATE EXTERNAL TABLE Measure_Dates
(measure_name string,
measure_id string,
start_qtr string,
start_date string,
end_qtr string,
end_date string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/Measure_Dates';

DROP TABLE IF EXISTS Timely_and_Effective_Care;
CREATE EXTERNAL TABLE Timely_and_Effective_Care
(Provider_ID string,
Hospital_name string,
Address string,
City string,
state string,
ZipCode string,
County string,
PhoneNumber string,
condition string,
measure_id string,
measure_name string,
sample string,
footnote string,
start_date string,
end_date string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/Timely_and_Effective_Care';



DROP TABLE IF EXISTS Readmissions_and_Deaths;
CREATE EXTERNAL TABLE Readmissions_and_Deaths
(Provider_ID string,
Hospital_name string,
Address string,
City string,
state string,
ZipCode string,
County string,
PhoneNumber string,
measure_name string,
measure_id string,
compared_to_national string,
denominator string,
score string,
lower_estimate string,
higher_estimate string,
footnote string,
start_date string,
end_date string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/Readmissions_and_Deaths';



DROP TABLE IF EXISTS HCAHPS_Hospital;
CREATE EXTERNAL TABLE HCAHPS_Hospital
(Provider_ID string,
Hospital_name string,
Address string,
City string,
state string,
ZipCode string,
County string,
PhoneNumber string,
hcahps_measure_id string,
hcahps_measure_question string,
hcahps_measure_question answer_desc,
patient_survey_start_rating string,
patient_survey_start_rating_footnote string,
hcahps_answer_percent string,
hcahps_answer_percent_footnote string,
hcahps_linear_mean_value string,
number_of_compl_surveys string,
number_of_compl_surveys_footnote string,
survey_resp_rate_percent string,
survey_resp_rate_percent_footnote string,
start_date string,
end_date string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/HCAHPS_Hospital';

DROP TABLE IF EXISTS hvbp_hcahps_02_18_2016;
CREATE EXTERNAL TABLE hvbp_hcahps_02_18_2016
(Provider_ID string,
Hospital_name string,
Address string,
City string,
state string,
ZipCode string,
County string,
comm_with_nurses_ach_pts string,
comm_with_nurses_imp_pts string,
comm_with_nurses_dim_score string,
comm_with_doctors_ach_pts string,
comm_with_doctors_imp_pts string,
comm_with_doctors_dim_score string,
resp_of_staffs_ach_pts string,
resp_of_staffs_imp_pts string,
resp_of_staffs_dim_score string,
pain_mgmt_ach_pts string,
pain_mgmt_imp_pts string,
pain_mgmt_dim_score string,
comm_about_med_ach_pts string,
comm_about_med_imp_pts string,
comm_about_med_dim_score string,
clean_n_quiet_ach_pts string,
clean_n_quiet_imp_pts string,
clean_n_quiet_dim_score string,
discharge_info_ach_pts string,
discharge_info_imp_pts string,
discharge_info_dim_score string,
overall_rating_ach_pts string,
overall_rating_imp_pts string,
overall_rating_dim_score string,
hcahps_base_score string,
hcahps_consistency_score string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/hvbp_hcahps_02_18_2016';



