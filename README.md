## Purpose

The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set.
**The goal is to prepare tidy data that can be used for later analysis.**

The following items are includes in this repository for submission:

1. This [README.md](https://github.com/thecapacity/CleaningData_CourseProj/blob/master/README.md) to explain how all of the scripts work and how  are connected.

2. A script, [run_analysis.R](https://github.com/thecapacity/CleaningData_CourseProj/blob/master/run_analysis.R), for performing the analysis.

3. A code book, [CodeBook.md](https://github.com/thecapacity/CleaningData_CourseProj/blob/master/CodeBook.md), that describes the variables, the data, and any transformations or work that you performed to clean up the data.

4. The resultant [tidy data set](https://github.com/thecapacity/CleaningData_CourseProj/blob/master/tidy_data.txt), with the average of each variable for each activity and each subject.

**Note: Raw Dataset is here: https://raw.githubusercontent.com/thecapacity/CleaningData_CourseProj/master/tidy_data.txt**

### Requirements

The contents of this repository were created on a Macbook running **OSX 10.9.5** and **RStudio Version 0.98.1087**

The only library requirement is `data.table`

It is not strictly necessary to re-run all elements of this repository, the tidy data included (from step #4) can be read directly into an R script with the command:
```
data <- read.table(file_path, header = TRUE) 
```

### Usage

[This repository](https://github.com/thecapacity/CleaningData_CourseProj) includes an R script called **run_analysis.R** that does the following:

1. Merges the training and the test sets to create a unified, temporary, data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. **Note: For this assignment mean and standard deviation measurements are assumed to be those explicitly marked as -mean() or -std().**

3. Uses descriptive activity names to name the activities in the data set.

4. Appropriately labels the data set with descriptive variable names.

5. Creates a second independent tidy data set, with the average of each variable for each activity and each subject.

To run this script it is recommended, but not required, that you have unzipped the original dataset (see below) into the working directory. More details are in the [CodeBook](https://github.com/thecapacity/CleaningData_CourseProj/blob/master/CodeBook.md) also included in this repository.

Assuming the data is available, the script **run_analysis.R** can be executed via normal R-means (e.g. source() or Cmd-Enter in R-Studio on a Mac).

### Background

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). 

Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.

* A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

* Here is the URL of the data for this project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
