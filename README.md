# TidyData
Programming Assignment for Getting and Cleaning Data

This code run.analysis.R reads in mobile data from the web, a training set and a test set
and merges to create one data set (data frame)

- The code extracts only the measurements on the mean and standard deviation for each measurement,
i.e. if mean() or std() is included in the variable name it is included in the set
- We use grepl to match the mean() and std() strings and return the column numbers.
- All activities are named with descriptive activities and labelled with descriptive variable names. 
- Finally an independent tidy data set is returned where the average of each variable
has been calculated for each activity and each subject. 


