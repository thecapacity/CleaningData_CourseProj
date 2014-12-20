# Project-specific FAQ: https://class.coursera.org/getdata-016/forum/thread?thread_id=50
## Note further details are in the forums (e.g. what constitutes a mean variable)

# Ensure pristine working environment
rm(list=ls())

#Get data if it doesn't exist...
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

## Load Feature Mapping
features <- read.table("UCI HAR Dataset/features.txt")
colnames(features) <- c("Value", "Name")

## Prune Features to -std() and -mean() names
feature_indexes = which(
        grepl("-std\\(\\)", features$Name, ignore.case=TRUE) |
        grepl("-mean\\(\\)", features$Name, ignore.case=TRUE)
)
## Note this also removes 13 values ending in *-meanFreq()
## Please see README and CodeBooks for the explicit assumption
## There should be 66 values remaining.
## If you would like the others included add another OR clause to which(...)
## Specifically: grepl("-meanFreq\\(\\)", features$Name, ignore.case=TRUE)

## This should yield dim(feature_subset) of 66x2, which matches documented assumptions (33 each)
feature_subset = features[feature_indexes, ]
## These will be used for pruning the desired columns later.

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
####################### TRAINING DATA LOADED ############################

####################### MERGE and CLEAN DATASETS ########################
merged_data <- rbind(test_data, train_data)

### Prune the Data to just the columns we're interested in
## Ensure our SubjectID and ActivityID fields are also included
truncated_data <- merged_data[, 
            (names(merged_data) %in% c( as.character(feature_subset$Name), "SubjectID", "ActivityID")) ]
######################### END MERGE and CLEAN ############################



################ NOT CERTAIN PAST THE ABOVE!!!! 

## This has produced one data frame where each data cell in the data frame is 
## the grouped data of all the entries of the intersection of (a particular subject &
## a particular activity & a particular variable)

## Saving data per instructions: 
##          upload your data set as a txt file created with write.table() using row.name=FALSE
##
filename <- "tidy_data.csv.txt"
write.table(tidy_data, file=filename, row.name=FALSE)