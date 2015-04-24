##Read in data and return a tidy data set
##You should create one R script called run_analysis.
##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names. 
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
###########################################################################################

##Get the data from the correct directory
train <- "/train/X_train.txt"
test <- "/test/X_test.txt"
directory <- getwd()
folder <- "UCI HAR Dataset"
location <- paste(directory,"/",folder,sep="")
##directory <- "C:/Users/olga/Rdev/UCI HAR Dataset"
##filenames <- list.files(path = directory,full.names = TRUE) 
trainset <- paste(location,train,sep="")
testset <- paste(location,test,sep="")
train_label <- read.table(paste(location,"/train/y_train.txt",sep=""))
test_label <- read.table(paste(location,"/test/y_test.txt",sep=""))
features <- read.table(paste(location,"/features.txt",sep=""))
act <- read.table(paste(location,"/activity_labels.txt",sep=""))
train_subject <- read.table(paste(location,"/train/subject_train.txt",sep=""))
test_subject <- read.table(paste(location,"/test/subject_test.txt",sep=""))
train_df <- read.table(trainset)
test_df <- read.table(testset)
##################################################################################
## 1. Merge the data into one dataframe
##################################################################################
## run the following if we want to first create a column to differentiate
## between test and train
##train_df[,length(train_df)+1] <- "train"
##test_df[,length(test_df)+1] <- "test"
data <- rbind(train_df,test_df,header=TRUE)
##install.packages("dplyr")
##library("dplyr")
##install.packages("plyr")
##library("plyr")
##data2 <- join_all(list(train_df,test_df))## different method of merging

##################################################################################
## 2. Extracts only the measurements on the mean and standard deviation for each measurement,
## i.e. if mean() or std() is included in the variable name it is included in the set
## Use grepl to match the mean() and std() strings and return the column numbers.
##################################################################################
m <- grepl("mean()", features$V2, ignore.case = T)
s <- grepl("std()", features$V2, ignore.case = T)
mean_measurements <- features[m,]
std_measurements <- features[s,]
use_var <- sort(c(mean_measurements[,1],std_measurements[,1]))
## If separator train/test used: data_trim <- data[,c(use_var,length(data))]
data_trim <- data[,c(use_var)]

##################################################################################
## 3. Uses descriptive activity names to name the activities in the data set
##################################################################################
library(dplyr);
train_act <- join(train_label,act,by="V1")
test_act <- join(test_label,act,by="V1")
train_act[,2] <- as.character(train_act[,2])
test_act[,2] <- as.character(test_act[,2])
comb_act <- rbind(train_act,test_act,header=TRUE)
## full data set: data[,length(data)+1] <- comb_act[,2]
data_trim[,length(data_trim)+1] <- comb_act[,2]


##################################################################################
## 4. Appropriately labels the data set with descriptive variable names.
##################################################################################
## full data set: names(data)[names(data)=="V563"] <- "Activity"
## full data set: names(data)[names(data)=="V562"] <- "IsTest"
## full data set: names(data)[1:561] <- as.character(features[,2])
names(data_trim)[1:length(use_var)] <- as.character(features[use_var,2])
## skip this column: names(data_trim)[length(use_var)+1] <- "IsTest"
names(data_trim)[length(use_var)+1] <- "Activity"


##################################################################################
## 5. From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.
##################################################################################
comb_sub <- rbind(train_subject,test_subject,header = TRUE)
## full data set: data[,length(data)+1] <- comb_sub
## full data set: names(data)[564]<- "Subject"
data_trim[length(data_trim)+1] <- comb_sub
names(data_trim)[length(data_trim)] <- "Subject"
##mean(data[,"tBodyAcc-mean()-X"],na.rm=TRUE)

tidy_data <- 0
tidy_data <- aggregate(. ~ Activity+Subject,data = data_trim,FUN=function(data_trim) c(mn =mean(data_trim)))
tidy_data[,1:2] <- tidy_data[,2:1]
names(tidy_data)[1:2] <- names(tidy_data)[2:1]

View(tidy_data)
##write.table(tidy_data, file="tidy_data.txt", row.names = FALSE)

## To read in the data:
## data <- read.table(file_path, header = TRUE) #if they used some other way of saving the file than a default write.table, this step will be different
## View(data)

