# Project-specific FAQ: https://class.coursera.org/getdata-016/forum/thread?thread_id=50
## Note some further details are in the forums (e.g. what constitutes a mean variable)
## Please see associated README and CodeBook for more details.
library(data.table)
##
# Ensure pristine working environment
rm(list=ls())
## However, it has been commented out for submission to ensure no disruptivie side-effets for others

######################## Get data if it doesn't exist... #########################
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## Strictly Speaking this part isn't necessary as directions stated:
##      "The code should have a file run_analysis.R in the main directory that can be run
##                  as long as the Samsung data is in your working directory."

if (! file.exists("data")) {
    dir.create("data")
    data_file <- "./data/data.zip"
    download.file(data_url, mode="wb", destfile=data_file, method="curl")
    dateDownloaded <- date()
}

if ( file.exists("data/data.zip")) {
    ## Data should end up extracted to a "UCI HAR Dataset" directory in the current working directory
    unzip("./data/data.zip")    
}
## Again the above is not strictly necessary, but included for completeness
##################################################################################
##
## BEGIN ACTUAL ASSIGNMENT ACTIVITY
## This script is one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
##              with the average of each variable for each activity and each subject.
##
############################## STEP 1 - Merge Training and Testing Datasets #############
## Prep Work so we can clean as we go, and filter later
## Load Feature Mapping
features <- read.table("UCI HAR Dataset/features.txt")
colnames(features) <- c("Value", "Name")

## Prune Features to -std() and -mean() names
feature_indexes = which(
        grepl("-std\\(\\)", features$Name, ignore.case=TRUE) |
        grepl("-mean\\(\\)", features$Name, ignore.case=TRUE)
)
## Note this also removes 13 values ending in *-meanFreq()
## Please see README and CodeBooks for the explicit assumption.
## There should be 66 values remaining.
## If you would like the others included add another OR clause to which(...)
## Specifically: grepl("-meanFreq\\(\\)", features$Name, ignore.case=TRUE)
##
## This should yield dim(feature_subset) of 66x2, which matches documented assumptions (33 each)
feature_subset = features[feature_indexes, ]
## These will be used for pruning the desired columns later.
## End Prep Work
##
## Step 1: Merging Training and Testing Datasets
####################### LOADING TEST DATA ############################
## Read Test Data
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
## Convert Column Names to Feature Names
colnames(test_data) <- features[, 'Name']

## Read Test Subjects
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
## Merge them in, with descriptive column name, SubjectID
test_data$SubjectID <- test_subjects[,]

## Read Test Labels
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
## Merge them in, with descriptive column name, ActivityID
test_data$ActivityID <- test_labels[,]
####################### TEST DATA LOADED ############################

####################### LOADING TRAINING DATA ############################
## Read Training Data
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
## Convert Column Names to Feature Names
colnames(train_data) <- features[, 'Name']

## Read Training Subjects
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
## Merge them in, with descriptive column name, SubjectID
train_data$SubjectID <- train_subjects[,]

## Read Training Labels
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
## Merge them into test_data, with descriptive column name, ActivityID
train_data$ActivityID <- train_labels[,]

## End Step 1 with merged data
merged_data <- rbind(test_data, train_data)
####################### TRAINING DATA LOADED ############################

####################### Step 2 - FILTER DATASET MEASUREMENTS ########################
##
## Prune the Data to just the columns we're interested in
## Ensure our SubjectID and ActivityID fields are also included
truncated_data <- merged_data[, 
            (names(merged_data) %in% c( as.character(feature_subset$Name), "SubjectID", "ActivityID")) ]
######################################################################################

####################### Step 3 - Add Descriptive Activity Names #######################
##
## Load Activity Map
activity_map <- read.table("UCI HAR Dataset/activity_labels.txt")
# Set NA for Activity Name
truncated_data$ActivityName = NA
# Loop through all the Names in the Activity Labels
for (activity_name in activity_map[,"V2"]) {
    # Looks up Activity Code
    activity_code <- activity_map[activity_map$V2 == activity_name, "V1"]

    # Find all instances of ActivityID that equals activity_code and set name.
    truncated_data[ truncated_data$ActivityID == activity_code, "ActivityName"] <- activity_name
}
## Loops seem straightforward to me, but perhaps match would have been more R-like?
## Eg: http://stackoverflow.com/questions/14417612/r-replace-an-id-value-with-a-name
##
## At this point we should have a cleaned data set, will just remove un-needed column
truncated_data$ActivityID <- NULL
## This yields the original 66 columns plus the two we added: SubjectID and ActivityName
################################### END Step 3 #######################################

####################### Step 4 - Appropriately Label DataSet #######################
## I think "Descriptive Variable Names" is amibguious or misleading.
## professionally I would leave the column names the same as the original dataset, as:
##  1. I think they're already fairly clear
##  2. It shows continuity with the original dataset
##  3. The descriptions are already written.
## However, since assignment suggests a mandatory change this is included below
##
## Note, while this seems like "brute force" it's less fragile than regexps
##       an alternative would be: names(truncated_data) <- gdub("Acc", "Acceleration", names(truncated_data))
## identifiers "t" -> Time and "f" -> Factor are kept

new_colnames <- c(
    "mean-X-tBodyAcceleration", "mean-Y-tBodyAcceleration", "mean-Z-tBodyAcceleration",
    "std-X-tBodyAcceleration", "std-Y-tBodyAcceleration", "std-Z-tBodyAcceleration",
    "mean-X-tGravityAcceleration", "mean-Y-tGravityAcceleration", "mean-Z-tGravityAcceleration",
    "std-X-tGravityAcceleration", "std-Y-tGravityAcceleration", "std-Z-tGravityAcceleration",
    "mean-X-tBodyAccelerationJerk", "mean-Y-tBodyAccelerationJerk", "mean-Z-tBodyAccelerationJerk",
    "std-X-tBodyAccelerationJerk", "std-Y-tBodyAccelerationJerk", "std-Z-tBodyAccelerationJerk",
    "mean-X-tBodyGyroscope", "mean-Y-tBodyGyroscope", "mean-Z-tBodyGyroscope",
    "std-X-tBodyGyroscope", "std-Y-tBodyGyroscope", "std-Z-tBodyGyroscope",
    "mean-X-tBodyGyroscopeJerk", "mean-Y-tBodyGyroscopeJerk", "mean-Z-tBodyGyroscopeJerk",
    "std-X-tBodyGyroscopeJerk", "std-Y-tBodyGyroscopeJerk", "std-Z-tBodyGyroscopeJerk",
    "mean-tBodyAccelerationMagnitude", "std-tBodyAccelerationMagnitude", "mean-tGravityAccelerationMagnitude",
    "std-tGravityAccelerationMagnitude", "mean-tBodyAccelerationJerkMagnitude", "std-tBodyAccelerationJerkMagnitude",
    "mean-tBodyGyroscopeMagnitude", "std-tBodyGyroscopeMagnitude", "mean-tBodyGyroscopeJerkMagnitude",
    "std-tBodyGyroscopeJerkMagnitude", "mean-X-fBodyAcceleration", "mean-Y-fBodyAcceleration",
    "mean-Z-fBodyAcceleration", "std-X-fBodyAcceleration", "std-Y-fBodyAcceleration",
    "std-Z-fBodyAcceleration", "mean-X-fBodyAccelerationJerk", "mean-Y-fBodyAccelerationJerk",
    "mean-Z-fBodyAccelerationJerk", "std-X-fBodyAccelerationJerk", "std-Y-fBodyAccelerationJerk",
    "std-Z-fBodyAccelerationJerk", "mean-X-fBodyGyroscope", "mean-Y-fBodyGyroscope",
    "mean-Z-fBodyGyroscope", "std-X-fBodyGyroscope", "std-Y-fBodyGyroscope",
    "std-Z-fBodyGyroscope", "mean-fBodyAccelerationMagnitude", "std-fBodyAccelerationMagnitude",
    "mean-fBodyAccelerationJerkMagnitude", "std-fBodyAccelerationJerkMagnitude", "mean-fBodyGyroscopeMagnitude",
    "std-fBodyGyroscopeMagnitude-std", "mean-fBodyGyroscopeJerkMagnitude", "std-fBodyGyroscopeJerkMagnitude",
    "SubjectID", "ActivityName"
)

colnames(truncated_data) <- new_colnames
################################### END Step 4 #######################################

############################## Step 5 - Create 2nd Dataset #############################
## So far we have "truncated_data" where each row is an observation spanning multiple participants 
## (multiple rows for a single subject) and various activity types.
##
## The goal of this section is to produce one data frame where each row in the data frame is 
## the average of all the entries for a given subject, their activities, and the measured variables.
##
## ################################################################################### ##
## I defaulted to using a data table from an earlier assignment / class
## Alternatives would be dplyr (seems overkill) or some combination of *apply (I tried, it was painful)
##
tidy_table <- data.table(truncated_data)
tidy_data <- tidy_table[, lapply(.SD, mean), by="SubjectID,ActivityName"]
################################### END Step 5 ########################################

############################## Step 6 - Saving 2nd Dataset #############################
##
## Saving data per instructions: 
##          upload your data set as a txt file created with write.table() using row.name=FALSE
##
filename <- "tidy_data.txt"
write.table(tidy_data, file=filename, row.name=FALSE)
## This should be loadable with: data <- read.table(file_path, header = TRUE) 
##
################################### END Step 6 ########################################