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
