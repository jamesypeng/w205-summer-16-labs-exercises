#!/bin/bash


# wget the hospital files

HOSPITAL_PATH=$HOME/hospital_compare
ORIGINAL_FILE_PATH=$HOSPITAL_PATH/old
NEW_FILE_PATH=$HOSPITAL_PATH/new


if [[ -d $HOSPITAL_PATH ]]
then
	echo "deleting $HOSPITAL_PATH directory"
	rm -rf $HOSPITAL_PATH
else
	echo "$HOSPITAL_PATH directory does not exists"
fi

# if [[ -d $ORIGINAL_FILE_PATH ]]
# then
	# echo "deleting $ORIGINAL_FILE_PATH directory"
	# rm -rf $ORIGINAL_FILE_PATH
# else
	# echo "$ORIGINAL_FILE_PATH directory does not exists"
# fi

# if [[ -d $NEW_FILE_PATH ]]
# then
	# echo "deleting $NEW_FILE_PATH directory"
	# rm -rf  $NEW_FILE_PATH
# else
	# echo "$NEW_FILE_PATH directory does not exists"
# fi

mkdir $HOSPITAL_PATH
mkdir $ORIGINAL_FILE_PATH
mkdir $NEW_FILE_PATH

cd $ORIGINAL_FILE_PATH 


HOSPITAL_FLATFILES=Hospital_Revised_Flatfiles.zip

#
# wget -O HOSPITAL_FLATFILES https://data.medicare.gov/views/bg9k-emty/files/7825b9e4-e595-4f25-86e0-32a68d7ac7a4?content_type=application%2Fzip%3B%20charset%3Dbinary&filename=Hospital_Revised_Flatfiles.zip
#

wget -O HOSPITAL_FLATFILES https://downloads.cms.gov/medicare/Hospital_Revised_flatfiles.zip

# http://medicare.gov/download/HospitalCompare/2015/December/HOSArchive_Revised_FlatFiles_20151210.zip
# https://downloads.cms.gov/medicare/Hospital_Revised_flatfiles.zip

wait
# unzip files

unzip HOSPITAL_FLATFILES


# Hospital General Information.csv
# Ambulatory Surgical Measures-Facility.csv
# Complications - Hospital.csv
# HCAHPS - Hospital.csv
# Healthcare Associated Infections - Hospital.csv
#
# hvbp_Efficiency_02_18_2016.csv
# hvbp_hai_02_18_2016.csv
# hvbp_hcahps_02_18_2016.csv
# hvbp_imm2_02_18_2016.csv
# hvbp_outcome_02_18_2016.csv
# hvbp_pn_02_18_2016.csv
# hvbp_scip_02_18_2016.csv
# hvbp_tps_02_18_2016.csv
#
# Timely and Effective Care - Hospital.csv

# Readmissions and Deaths - Hospital.csv
# Structural Measures - Hospital.csv

echo "Removing header for the flatted CSV files"
###############################################
# General Hospital Information
#
# filename: 
#		Hospital_Info.csv
tail -n +2 $ORIGINAL_FILE_PATH/"Hospital General Information.csv" > $NEW_FILE_PATH/"Hospital_Info.csv"



###############################################
# Procedure data 
# filename: 
#		Timely_and_Effective_Care.csv
#		Readmissions_and_Deaths.csv
tail -n +2 $ORIGINAL_FILE_PATH/"Timely and Effective Care - Hospital.csv" > $NEW_FILE_PATH/"Timely_and_Effective_Care.csv"	
tail -n +2 $ORIGINAL_FILE_PATH/"Readmissions and Deaths - Hospital.csv" > $NEW_FILE_PATH/"Readmissions_and_Deaths.csv"

# --complement: to remove the specified columns
# remove='1,5,7'
# cut -d, -f$remove --complement $NEW_FILE_PATH/"Hospital_Info.csv"


###############################################
# Mapping of measures to codes 
# filename: 
#		Measure Dates.csv
#
tail -n +2 $ORIGINAL_FILE_PATH/"Measure Dates.csv" > $NEW_FILE_PATH/"Measure_Dates.csv"

###############################################
# Survey Result
# filename: 

  # inflating: hvbp_ami_05_28_2015.csv  
  # inflating: hvbp_Efficiency_05_20_2015.csv  
  # inflating: hvbp_hai_05_28_2015.csv  
  # inflating: hvbp_hcahps_05_28_2015.csv  
  # inflating: hvbp_hf_05_28_2015.csv  
  # inflating: hvbp_outcome_05_18_2015.csv  
  # inflating: hvbp_pn_05_28_2015.csv  
  # inflating: hvbp_quarters.csv       
  # inflating: hvbp_scip_05_28_2015.csv  
  # inflating: hvbp_tps_05_28_2015.csv  

HVBP_AMI="hvbp_ami_05_28_2015.csv"
HVBP_EFFICIENCY="hvbp_Efficiency_05_20_2015.csv"
HVBP_HAI="hvbp_hai_05_28_2015.csv"
HVBP_HCAHPS="hvbp_hcahps_05_28_2015.csv"
HVBP_HF="hvbp_hf_05_28_2015.csv"
HVBP_OUTCOME="hvbp_outcome_05_18_2015.csv"
HVBP_PN="hvbp_pn_05_28_2015.csv"
HVBP_QUARTERS="hvbp_quarters.csv"
HVBP_SCIP="hvbp_scip_05_28_2015.csv"
HVBP_TPS="hvbp_tps_05_28_2015.csv" 

tail -n +2 $ORIGINAL_FILE_PATH/"HCAHPS - Hospital.csv" > $NEW_FILE_PATH/"HCAHPS_Hospital.csv"

tail -n +2 $ORIGINAL_FILE_PATH/$HVBP_AMI > $NEW_FILE_PATH/$HVBP_AMI
tail -n +2 $ORIGINAL_FILE_PATH/$HVBP_EFFICIENCY > $NEW_FILE_PATH/$HVBP_EFFICIENCY
tail -n +2 $ORIGINAL_FILE_PATH/$HVBP_HAI > $NEW_FILE_PATH/$HVBP_HAI
tail -n +2 $ORIGINAL_FILE_PATH/$HVBP_HCAHPS> $NEW_FILE_PATH/$HVBP_HCAHPS
tail -n +2 $ORIGINAL_FILE_PATH/$HVBP_HF > $NEW_FILE_PATH/$HVBP_HF
tail -n +2 $ORIGINAL_FILE_PATH/$HVBP_OUTCOME > $NEW_FILE_PATH/$HVBP_OUTCOME
tail -n +2 $ORIGINAL_FILE_PATH/$HVBP_PN > $NEW_FILE_PATH/$HVBP_PN
tail -n +2 $ORIGINAL_FILE_PATH/$HVBP_QUARTERS > $NEW_FILE_PATH/$HVBP_QUARTERS
tail -n +2 $ORIGINAL_FILE_PATH/$HVBP_SCIP > $NEW_FILE_PATH/$HVBP_SCIP
tail -n +2 $ORIGINAL_FILE_PATH/$HVBP_TPS > $NEW_FILE_PATH/$HVBP_TPS


###############################################
# Structural Measures
# filename: Structural_Measures.csv
tail -n +2 $ORIGINAL_FILE_PATH/"Structural Measures - Hospital.csv" > $NEW_FILE_PATH/"Structural_Measures.csv"


#######################################
# Copy the file to HDFS
echo "Copy the file to HDFS"

HDFS_HOME=/user/w205
HDFS_EX1_PATH=$HDFS_HOME/hospital_compare

echo "Delete" $HDFS_EX1_PATH
hdfs dfs -rm -R $HDFS_EX1_PATH

hdfs dfs -ls $HDFS_HOME
hdfs dfs -mkdir $HDFS_EX1_PATH
hdfs dfs -ls $HDFS_HOME


FILE_NAME=Hospital_Info.csv
FILE_DIR=Hospital_Info
hdfs dfs -mkdir $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -put $NEW_FILE_PATH/$FILE_NAME $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -ls $HDFS_EX1_PATH/$FILE_DIR


FILE_NAME=Measure_Dates.csv
FILE_DIR=Measure_Dates
hdfs dfs -mkdir $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -put $NEW_FILE_PATH/$FILE_NAME $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -ls $HDFS_EX1_PATH/$FILE_DIR


FILE_NAME=Timely_and_Effective_Care.csv
FILE_DIR=Timely_and_Effective_Care
hdfs dfs -mkdir $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -put $NEW_FILE_PATH/$FILE_NAME $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -ls $HDFS_EX1_PATH/$FILE_DIR

FILE_NAME=Readmissions_and_Deaths.csv
FILE_DIR=Readmissions_and_Deaths
hdfs dfs -mkdir $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -put $NEW_FILE_PATH/$FILE_NAME $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -ls $HDFS_EX1_PATH/$FILE_DIR


FILE_NAME=HCAHPS_Hospital.csv
FILE_DIR=HCAHPS_Hospital
hdfs dfs -mkdir $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -put $NEW_FILE_PATH/$FILE_NAME $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -ls $HDFS_EX1_PATH/$FILE_DIR


FILE_NAME=$HVBP_HCAHPS
FILE_DIR=hvbp_hcahps
hdfs dfs -mkdir $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -put $NEW_FILE_PATH/$FILE_NAME $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -ls $HDFS_EX1_PATH/$FILE_DIR


FILE_NAME=$HVBP_OUTCOME
FILE_DIR=hvbp_outcome
hdfs dfs -mkdir $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -put $NEW_FILE_PATH/$FILE_NAME $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -ls $HDFS_EX1_PATH/$FILE_DIR

FILE_NAME=Structural_Measures.csv
FILE_DIR=Structural_Measures
hdfs dfs -mkdir $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -put $NEW_FILE_PATH/$FILE_NAME $HDFS_EX1_PATH/$FILE_DIR
hdfs dfs -ls $HDFS_EX1_PATH/$FILE_DIR


hdfs dfs -ls -R $HDFS_EX1_PATH


# hdfs dfs -put $NEW_FILE_PATH/hvbp_Efficiency_02_18_2016.csv $HDFS_EX1_PATH
# hdfs dfs -put $NEW_FILE_PATH/hvbp_hai_02_18_2016.csv $HDFS_EX1_PATH

# hdfs dfs -put $NEW_FILE_PATH/hvbp_imm2_02_18_2016.csv $HDFS_EX1_PATH
# hdfs dfs -put $NEW_FILE_PATH/hvbp_outcome_02_18_2016.csv $HDFS_EX1_PATH
# hdfs dfs -put $NEW_FILE_PATH/hvbp_pn_02_18_2016.csv $HDFS_EX1_PATH
# hdfs dfs -put $NEW_FILE_PATH/hvbp_scip_02_18_2016.csv $HDFS_EX1_PATH
# hdfs dfs -put $NEW_FILE_PATH/hvbp_tps_02_18_2016.csv $HDFS_EX1_PATH

# hdfs dfs -ls $HDFS_EX1_PATH



