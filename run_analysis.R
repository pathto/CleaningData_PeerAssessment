## Create one R script called run_analysis.R that does the following: 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

library(dplyr)
path_train <- './UCI HAR Dataset/train/'
path_test <- './UCI HAR Dataset/test/'

## read data
x_train <- read.table(paste(path_train, 'X_train.txt', sep = ''))
lab_train <- read.table(paste(path_train, 'y_train.txt', sep = ''))
sub_train <- read.table(paste(path_train, 'subject_train.txt', sep = ''))

x_test <- read.table(paste(path_test, 'X_test.txt', sep = ''))
lab_test <- read.table(paste(path_test, 'y_test.txt', sep = ''))
sub_test <- read.table(paste(path_test, 'subject_test.txt', sep = ''))

act_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')
features <- read.table('./UCI HAR Dataset/features.txt')

## rename the column names
cnames <- make.names(as.character(features$V2), unique = TRUE)
colnames(x_test) <- cnames
colnames(x_train) <- cnames

## add the columns of activity and subject
x_test$activity <- lab_test$V1
x_test$subject <- sub_test$V1

x_train$activity <- lab_train$V1
x_train$subject <- sub_train$V1

## Merge the training and the test data sets
df <- rbind(x_train, x_test)

## Extracts only the measurements on the mean and standard deviation for each measurement.
df_meanstd <- select(df, matches('mean|std'))

## Uses descriptive activity names to name the activities in the data set
df$activity <- factor(df$activity, label = act_labels$V2)

## Appropriately labels the data set with descriptive variable names.
names(df)

## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
df_tidy <- summarise_each(group_by(df, activity, subject), funs(mean))

write.table(df_tidy, 'tidy_dataset.txt', row.name = FALSE, quote = FALSE)