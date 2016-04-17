#libraries
library(dplyr)
library(tidyr)

# Get all the files for the test data
testpath1<-"./UCI HAR Dataset/test/X_test.txt"
testpath2<-"./UCI HAR Dataset/test/y_test.txt"
testpath3<-"./UCI HAR Dataset/test/subject_test.txt"
x_test<-read.table(testpath1,header=FALSE,sep="")
y_test<-read.table(testpath2,header=FALSE,sep="")
sub_test<-read.table(testpath3,header=FALSE,sep="")

# Get all the files for the training data
trainpath1<-"./UCI HAR Dataset/train/X_train.txt"
trainpath2<-"./UCI HAR Dataset/train/y_train.txt"
trainpath3<-"./UCI HAR Dataset/train/subject_train.txt"
x_train<-read.table(trainpath1,header=FALSE,sep="")
y_train<-read.table(trainpath2,header=FALSE,sep="")
sub_train<-read.table(trainpath3,header=FALSE,sep="")

# Get the features and activity referential table
activity<-read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep=" ")
features<-read.table("./UCI HAR Dataset/features.txt", header=FALSE, sep=" ")

# Add the colnames to test and training data
names(x_test)<-features$V2
names(y_test)<-"activityId"
names(sub_test)<-"subjectId"

names(x_train)<-features$V2
names(y_train)<-"activityId"
names(sub_train)<-"subjectId"

names(features)<-c("id","featureName")
names(activity)<-c("activityId","activityName")


# Convert all to table format
x_test_tb<-tbl_df(x_test)
y_test_tb<-tbl_df(y_test)
sub_test_tb<-tbl_df(sub_test)

x_train_tb<-tbl_df(x_train)
y_train_tb<-tbl_df(y_train)
sub_train_tb<-tbl_df(sub_train)

features_tb<-tbl_df(features)
activity_tb<-tbl_df(activity)

# Add the activity and subject data to the test and training dataset
x_test_all<-bind_cols(y_test_tb,sub_test_tb,x_test_tb)
x_train_all<-bind_cols(y_train_tb,sub_train_tb,x_train_tb)

# Since there are duplicated columns, remove them
x_test_all<-x_test_all[,!duplicated(colnames(x_test_all))]
x_train_all<-x_train_all[,!duplicated(colnames(x_train_all))]

# Merge train and test into one table
all_data<-bind_rows(x_test_all,x_train_all)

# Keep only the mean and stdv
all_data_sub<-select(all_data,activityId,subjectId,contains("mean()"),contains("std()"))

# Add the activity names
all_data_acy<-inner_join(activity,all_data_sub,by="activityId")

# Improve field names to add descriptive names
columnas<-names(all_data_acy)
columnas<-gsub("mean","Mean",columnas)
columnas<-gsub("std","Std",columnas)
columnas<-sub("^t","Time",columnas)
columnas<-sub("^f","Freq",columnas)
columnas<-gsub("-|\\()","",columnas)

names(all_data_acy)<-columnas
all_data_acy<-tbl_df(all_data_acy)

# Generate txt file with tidy dataset
write.table(all_data_acy,"./human_act_samsumg.txt", quote=FALSE, sep=" ",row.names=FALSE)

# Generate second dataset with the averages by activity and subject
all_data<-select(all_data_acy,-activityId)
all_data_group<-group_by(all_data, activityName, subjectId)
sum_dataset<-summarize_each(all_data_group,funs(mean))

write.table(sum_dataset,"./human_act_samsumg_avg.txt", quote=FALSE, sep=" ",row.names=FALSE)








