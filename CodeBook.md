## CodeBook

This document describes the data, the variables, and any transformations or work performed to clean up the data.

**Note:** This content was created with data downloaded on: `Sat. Dec 20 12:42:26 2014`, which is approximately **60M** zipped. 

The data included in this repository is intended to adhere to the philosophy of [Tidy Data] (http://vita.had.co.nz/papers/tidy-data.pdf) with some class-specific nuances (such as removing rowNames when saving the file).

The stages in this `CodeBook` are broken down into:

1. **Data Acqusition** _(optional)_ 

2. **Data Extraction** _(optional)_ 

3. **Data Processing** _(descriptive)_ 

    This is the primary purpose of this document, to outline the processing steps.

4. **Data Definition** _(informational)_ 

5. **Data Acqusition** _(informational)_


### Data Acqusition:

The **run_analysis.R** script can obtain the data itself, however this is not always desirable, as the file is very large and the process time consuming.

Therefore, we recommend creating a `data` subdirectory and manually placing the data file, which should be named `data.zip`

As sample command to do this, assuming you are in the working directory, is:
```
mkdir data && wget -O data/data.zip https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
```
Please note, this comment will **fail** if the `data` subdirectory already exists.

### Data Extraction:

The **run_analysis.R** script will automatically extract the data from the `data.zip` file, assuming it is in a `./data` subdirectory of the working environment.

This creates a subdirectory `UCI HAR Dataset` in the current working directory reported by `getwd()`.

Within that Directory are the following files and subdirectories:

* `README.txt`
* `activity_labels.txt`
* `features.txt`
* `features_info.txt`
* `test/`
* `train/`

Each of the `test` and `train` subdirectories have similar a structure and files:
```
$ ls test
Inertial Signals  X_test.txt  subject_test.txt	y_test.txt

$ ls train/
Inertial Signals  X_train.txt  subject_train.txt  y_train.txt
```

### Data Processing:
In order to create the resultant tidy dataset, the following steps are executed:

1. Read in the Training Data.

2. Read in the Testing Data.

3. Merge the training and the test sets to create a unified data set.

4. Extracts only the measurements on the mean and standard deviation for each measurement.

    **Note: For this assignment mean and standard deviation measurements are assumed to be those explicitly marked as `-mean()` or `-std()`.**

5. Uses descriptive activity names to rename the activities in the data set.

6. Appropriately label the data set with descriptive variable names. 

7. Create a second tidy data set, with the average of each variable for each activity and each subject.

8. Write this resultant tidy data set out to a file.


### Data Definition:

The raw data contains information on experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years.

Each person performed six activities wearing a smartphone (Samsung Galaxy S II) on the waist.

Those activities (and values) are broken down into the following categories (also defined in `activity_labels.txt` from the original data file):

* **WALKING**

* **WALKING_UPSTAIRS**

* **WALKING_DOWNSTAIRS**

* **SITTING**

* **STANDING**

* **LAYING**

For the purposes of extraction we are only interested in data with a *-mean() or *-std() value.

Of those measures, there are _33_ mentions of either `-std()` or `-mean()` as measured by a quick grep:
```
$ cat features.txt | grep "\-std()" | wc -l
33

$ cat features.txt | grep "\-mean()" | wc -l
33
```

From further review of the features.txt file, the following issues were found:

The following fields have three separate instances (e.g. for `-mean()` there is `-mean()-X`, `-mean()-Y`, `-mean()-Z`

* tBodyAcc-XYZ

* tGravityAcc-XYZ

* tBodyAccJerk-XYZ

* tBodyGyro-XYZ

* tBodyGyroJerk-XYZ

* fBodyAcc-XYZ

* fBodyAccJerk-XYZ

* fBodyGyro-XYZ

The following fields only have a single instance (e.g. one `-mean()`)

* tBodyAccMag

* tGravityAccMag

* tBodyAccJerkMag

* tBodyGyroMag

* tBodyGyroJerkMag

* fBodyAccMag

* fBodyBodyAccJerkMag (Note: this was refered to as fBodyAccJerkMag in other material)

* fBodyBodyGyroMag (Note: this was refered to as fBodyGyroMag in other material)

* fBodyBodyGyroJerkMag (Note: this was refered to as fBodyGyroJerkMag in other material)

```
These can be tested with something similar to:
$ cat features.txt | grep -E "fBodyGyro-[XYZ]?" | grep "\-mean()"
424 fBodyGyro-mean()-X
425 fBodyGyro-mean()-Y
426 fBodyGyro-mean()-Z
````

#### Attribute Information:

For each record in the dataset the following information is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.

* Triaxial Angular velocity from the gyroscope.

* A 561-feature vector with time and frequency domain variables.

* Its activity label.

* An identifier of the subject who carried out the experiment.

For more detailed information, please check out `features.txt` and `features_info.txt` for more information on the  features from the original data set. 

#### Collection Information:
Using the phone's embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of **50Hz**.

The experiments were also video-recorded to label the data manually. The obtained dataset was been randomly partitioned into **two sets**, where **70%** of the volunteers was selected for generating the _training data_ and **30%** the _test data_.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in **fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window)**.

The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore **a filter with 0.3 Hz cutoff** frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.
