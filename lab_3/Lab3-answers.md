### 1 List the execution time of the weblog aggregation query for Hive, SparkSQL, and SparkSQL on Parquet.

##### Hive Query Time: 99.56 seconds
```bash
hive> SELECT user_id, COUNT(user_id) AS log_count
    > FROM weblogs_schema GROUP BY user_id
    > ORDER BY log_count DESC
    > LIMIT 50;
Query ID = w205_20160526023434_13cea121-227b-42c5-b416-b20c572fc5e0
Total jobs = 2
Launching Job 1 out of 2
Number of reduce tasks not specified. Estimated from input data size: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Starting Job = job_1464226726820_0007, Tracking URL = http://ip-172-31-59-141.ec2.internal:8088/proxy/application_1464226726820_0007/
Kill Command = /usr/lib/hadoop/bin/hadoop job  -kill job_1464226726820_0007
Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
2016-05-26 02:34:42,218 Stage-1 map = 0%,  reduce = 0%
2016-05-26 02:34:55,385 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 3.13 sec
2016-05-26 02:35:12,577 Stage-1 map = 100%,  reduce = 100%, Cumulative CPU 6.51 sec
MapReduce Total cumulative CPU time: 6 seconds 510 msec
Ended Job = job_1464226726820_0007
Launching Job 2 out of 2
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Starting Job = job_1464226726820_0008, Tracking URL = http://ip-172-31-59-141.ec2.internal:8088/proxy/application_1464226726820_0008/
Kill Command = /usr/lib/hadoop/bin/hadoop job  -kill job_1464226726820_0008
Hadoop job information for Stage-2: number of mappers: 1; number of reducers: 1
2016-05-26 02:35:29,458 Stage-2 map = 0%,  reduce = 0%
2016-05-26 02:35:40,890 Stage-2 map = 100%,  reduce = 0%, Cumulative CPU 2.74 sec
2016-05-26 02:35:54,456 Stage-2 map = 100%,  reduce = 100%, Cumulative CPU 5.2 sec
MapReduce Total cumulative CPU time: 5 seconds 200 msec
Ended Job = job_1464226726820_0008
MapReduce Jobs Launched: 
Stage-Stage-1: Map: 1  Reduce: 1   Cumulative CPU: 6.51 sec   HDFS Read: 5199465 HDFS Write: 867513 SUCCESS
Stage-Stage-2: Map: 1  Reduce: 1   Cumulative CPU: 5.2 sec   HDFS Read: 871961 HDFS Write: 2001 SUCCESS
Total MapReduce CPU Time Spent: 11 seconds 710 msec
OK
__RequestVerificationToken_Lw__=2C2DB   10
__RequestVerificationToken_Lw__=3DDC1   9
__RequestVerificationToken_Lw__=A1BC3   9
__RequestVerificationToken_Lw__=111AA   9
__RequestVerificationToken_Lw__=233C3   9
__RequestVerificationToken_Lw__=A223D   9
__RequestVerificationToken_Lw__=B2CC1   9
__RequestVerificationToken_Lw__=113B3   9
__RequestVerificationToken_Lw__=2BDC3   9
__RequestVerificationToken_Lw__=D13BD   9
__RequestVerificationToken_Lw__=3BB1C   9
__RequestVerificationToken_Lw__=32B2B   9
__RequestVerificationToken_Lw__=21DCC   9
__RequestVerificationToken_Lw__=A31AB   9
__RequestVerificationToken_Lw__=DBBC1   8
__RequestVerificationToken_Lw__=2A2C1   8
__RequestVerificationToken_Lw__=B2B32   8
__RequestVerificationToken_Lw__=B32C2   8
__RequestVerificationToken_Lw__=BD11A   8
__RequestVerificationToken_Lw__=33ABD   8
__RequestVerificationToken_Lw__=CBCD3   8
__RequestVerificationToken_Lw__=B13AB   8
__RequestVerificationToken_Lw__=AAABA   8
__RequestVerificationToken_Lw__=D1DBD   8
__RequestVerificationToken_Lw__=DAD1D   8
__RequestVerificationToken_Lw__=3AA3C   8
__RequestVerificationToken_Lw__=A1D22   8
__RequestVerificationToken_Lw__=CA22C   8
__RequestVerificationToken_Lw__=AA1D3   8
__RequestVerificationToken_Lw__=B232C   8
__RequestVerificationToken_Lw__=DA1D2   8
__RequestVerificationToken_Lw__=1133C   8
__RequestVerificationToken_Lw__=2CD1D   8
__RequestVerificationToken_Lw__=CB1BC   8
__RequestVerificationToken_Lw__=2A231   8
__RequestVerificationToken_Lw__=C2221   8
__RequestVerificationToken_Lw__=1221A   8
__RequestVerificationToken_Lw__=CA3DD   8
__RequestVerificationToken_Lw__=1A2CA   8
__RequestVerificationToken_Lw__=31A2B   8
__RequestVerificationToken_Lw__=11B3B   8
__RequestVerificationToken_Lw__=B2CCB   8
__RequestVerificationToken_Lw__=11DBC   8
__RequestVerificationToken_Lw__=B1ADC   8
__RequestVerificationToken_Lw__=1A2C1   8
__RequestVerificationToken_Lw__=A1ABB   8
__RequestVerificationToken_Lw__=12CD1   8
__RequestVerificationToken_Lw__=D3DA2   7
__RequestVerificationToken_Lw__=DD2AB   7
__RequestVerificationToken_Lw__=C22C2   7
Time taken: 99.56 seconds, Fetched: 50 row(s)
```

##### Spark SQL Query Time:  9.288
```bash
spark-sql> 
         > SELECT user_id, COUNT(user_id) AS log_count
         > FROM weblogs_schema GROUP BY user_id
         > ORDER BY log_count DESC
         > LIMIT 50;
__RequestVerificationToken_Lw__=2C2DB   10                                      
__RequestVerificationToken_Lw__=32B2B   9
__RequestVerificationToken_Lw__=A1BC3   9
__RequestVerificationToken_Lw__=B2CC1   9
__RequestVerificationToken_Lw__=3BB1C   9
__RequestVerificationToken_Lw__=111AA   9
__RequestVerificationToken_Lw__=21DCC   9
__RequestVerificationToken_Lw__=D13BD   9
__RequestVerificationToken_Lw__=113B3   9
__RequestVerificationToken_Lw__=A223D   9
__RequestVerificationToken_Lw__=2BDC3   9
__RequestVerificationToken_Lw__=3DDC1   9
__RequestVerificationToken_Lw__=233C3   9
__RequestVerificationToken_Lw__=A31AB   9
__RequestVerificationToken_Lw__=2A231   8
__RequestVerificationToken_Lw__=C2221   8
__RequestVerificationToken_Lw__=1A2CA   8
__RequestVerificationToken_Lw__=11B3B   8
__RequestVerificationToken_Lw__=B2CCB   8
__RequestVerificationToken_Lw__=B32C2   8
__RequestVerificationToken_Lw__=CB1BC   8
__RequestVerificationToken_Lw__=1A2C1   8
__RequestVerificationToken_Lw__=1133C   8
__RequestVerificationToken_Lw__=A1D22   8
__RequestVerificationToken_Lw__=DAD1D   8
__RequestVerificationToken_Lw__=2CD1D   8
__RequestVerificationToken_Lw__=AAABA   8
__RequestVerificationToken_Lw__=CBCD3   8
__RequestVerificationToken_Lw__=33ABD   8
__RequestVerificationToken_Lw__=31A2B   8
__RequestVerificationToken_Lw__=CA22C   8
__RequestVerificationToken_Lw__=1221A   8
__RequestVerificationToken_Lw__=12CD1   8
__RequestVerificationToken_Lw__=AA1D3   8
__RequestVerificationToken_Lw__=B13AB   8
__RequestVerificationToken_Lw__=11DBC   8
__RequestVerificationToken_Lw__=B232C   8
__RequestVerificationToken_Lw__=D1DBD   8
__RequestVerificationToken_Lw__=BD11A   8
__RequestVerificationToken_Lw__=DBBC1   8
__RequestVerificationToken_Lw__=B2B32   8
__RequestVerificationToken_Lw__=DA1D2   8
__RequestVerificationToken_Lw__=3AA3C   8
__RequestVerificationToken_Lw__=CA3DD   8
__RequestVerificationToken_Lw__=A1ABB   8
__RequestVerificationToken_Lw__=2A2C1   8
__RequestVerificationToken_Lw__=B1ADC   8
__RequestVerificationToken_Lw__=C23DD   7
__RequestVerificationToken_Lw__=BC1DA   7
__RequestVerificationToken_Lw__=AC3DA   7
Time taken: 9.288 seconds, Fetched 50 row(s)
```

##### SparkSQL on Parquet Query Time: 8.044 seconds 
```bash
spark-sql> SELECT user_id, COUNT(user_id) AS log_count
         > FROM weblogs_parquet GROUP BY user_id
         > ORDER BY log_count DESC
         > LIMIT 50;
__RequestVerificationToken_Lw__=2C2DB   10                                      
__RequestVerificationToken_Lw__=32B2B   9
__RequestVerificationToken_Lw__=A1BC3   9
__RequestVerificationToken_Lw__=B2CC1   9
__RequestVerificationToken_Lw__=3BB1C   9
__RequestVerificationToken_Lw__=111AA   9
__RequestVerificationToken_Lw__=21DCC   9
__RequestVerificationToken_Lw__=D13BD   9
__RequestVerificationToken_Lw__=113B3   9
__RequestVerificationToken_Lw__=A223D   9
__RequestVerificationToken_Lw__=2BDC3   9
__RequestVerificationToken_Lw__=3DDC1   9
__RequestVerificationToken_Lw__=233C3   9
__RequestVerificationToken_Lw__=A31AB   9
__RequestVerificationToken_Lw__=2A231   8
__RequestVerificationToken_Lw__=C2221   8
__RequestVerificationToken_Lw__=1A2CA   8
__RequestVerificationToken_Lw__=11B3B   8
__RequestVerificationToken_Lw__=B2CCB   8
__RequestVerificationToken_Lw__=B32C2   8
__RequestVerificationToken_Lw__=CB1BC   8
__RequestVerificationToken_Lw__=1A2C1   8
__RequestVerificationToken_Lw__=1133C   8
__RequestVerificationToken_Lw__=A1D22   8
__RequestVerificationToken_Lw__=DAD1D   8
__RequestVerificationToken_Lw__=2CD1D   8
__RequestVerificationToken_Lw__=AAABA   8
__RequestVerificationToken_Lw__=CBCD3   8
__RequestVerificationToken_Lw__=33ABD   8
__RequestVerificationToken_Lw__=31A2B   8
__RequestVerificationToken_Lw__=CA22C   8
__RequestVerificationToken_Lw__=1221A   8
__RequestVerificationToken_Lw__=12CD1   8
__RequestVerificationToken_Lw__=AA1D3   8
__RequestVerificationToken_Lw__=B13AB   8
__RequestVerificationToken_Lw__=11DBC   8
__RequestVerificationToken_Lw__=B232C   8
__RequestVerificationToken_Lw__=D1DBD   8
__RequestVerificationToken_Lw__=BD11A   8
__RequestVerificationToken_Lw__=DBBC1   8
__RequestVerificationToken_Lw__=B2B32   8
__RequestVerificationToken_Lw__=DA1D2   8
__RequestVerificationToken_Lw__=3AA3C   8
__RequestVerificationToken_Lw__=CA3DD   8
__RequestVerificationToken_Lw__=A1ABB   8
__RequestVerificationToken_Lw__=2A2C1   8
__RequestVerificationToken_Lw__=B1ADC   8
__RequestVerificationToken_Lw__=C23DD   7
__RequestVerificationToken_Lw__=BC1DA   7
__RequestVerificationToken_Lw__=AC3DA   7
Time taken: 8.044 seconds, Fetched 50 row(s)
```
#### SparkSQL on Parquet is the fastest, while Spark-SQL is about 15% slower. Give is the slowest, about 12x slower than SparkSQL on Parquet 

### 2 - How many jobs does Hive launch? Does SparkSQL launch jobs?

> From the log in Q1, Hive launched 2 jobs. My query ran as a single job on SparkSQL.

### 3 - Write a query which joins weblogs_parquet to user_info and counts the top 5 locations. List the locations.

```bash
spark-sql> describe weblogs_parquet;
datetime        string  NULL
user_id string  NULL
session_id      string  NULL
product_id      string  NULL
referrer        string  NULL
Time taken: 0.075 seconds, Fetched 5 row(s)
spark-sql> describe user_info;
datetime        string  NULL
user_id string  NULL
first_name      string  NULL
last_name       string  NULL
location        string  NULL
Time taken: 0.079 seconds, Fetched 5 row(s)

spark-sql> SELECT count(*) as location_count, location FROM weblogs_parquet 
         > RIGHT JOIN user_info on weblogs_parquet.user_id = user_info.user_id
         > group by location 
         > order by location_count DESC
         > limit 10
         > ;
50      La Fayette                                                              
48      Blountsville
48      Leeds
46      Hayden
45      Hamilton
45      Chapman
44      Angoon
43      Hazel Green
43      Greensboro
42      Adger
Time taken: 5.252 seconds, Fetched 10 row(s)
```