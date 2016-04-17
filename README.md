####################################################################################### 
Coursera Getting and Cleaning Data Course Project
#######################################################################################
Gabriela Bazan
April 2016
#######################################################################################
The files in the Course Project are:
run_analysis.R  : Scrip with all the steps to generate 2 datasets.
Codebook.md     : Codebook that describes all the variables in the dataset.
README.md       : Read me file with the project and step description.
########################################################################################

----------------------------------------------------------------------------------------
run_analysis.R script
----------------------------------------------------------------------------------------
For the script to run you have to download and unzip the following file to your working directory:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

After that, just source the code in the script and two files will be generated in your working directory:
human_act_samsumg.txt
human_act_samsumg_avg.txt

----------------------------------------------------------------------------------------
How does the script work?
----------------------------------------------------------------------------------------
First Dataset
1. Set the libraries we are going to use in the script.
2. Set the paths to all the 'Human Activity Recognition Using Smartphones Dataset' files.
  For the test and train groups we have 3 files:
  - x_ : observation data
  - y_ : activity data
  - subject : subjects data
  We also have to set the path for the activity and features files to find comprehensive names for the activities and the data columns.
3. Read the text files to get them into R using read.table
4. Add the column names to the observation data and the activity and subject data using the features file.
5. Convert the dataframes to table format to use the dplyr library and fuctions, and get a better view of the data.
6. Add the activity and subject data to the observation data.
7. Using the features files, we obtain some duplicated columns, therefore we have to get rid of these columns to continue working.
8. Before merging the training and test data, we add a group column in order to be able to identify them later
9. We merge both datasets (train and test) into one.
10. We keep only the mean and standard deviation columns.
11. To improve the description of the columns, we use sub and gsub with some Regular Expressions and rename all the columns.
12. We write the dataset to the working directory using write.table.

Second Dataset
1. We group the dataset by activityName and subjectId.
2. We use summarize_each to get the mean of all the variables.
3. We write the dataset to the working directory using write.table.



