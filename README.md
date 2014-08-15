GetDataProject
==============

Repository for the Course Project on the Getting and Cleaning Data course from Coursera (getdata-006)

The objective of this script is to extract information from the UCI HAR Dataset (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and apply transformations to it in order to generate a tidy dataset;

This repository contains a single R script `run_analysis.R`. In order to download and generate the tidy dataset, one should source the `run_analysis.R` and then run the `buildTidyDataSet()` function. The script is able to download and extract the dataSet by itself. But you can also manually download and extract the information to the `/data` directory.

More information on the resulting tidy dataset can be found on the `CodeBook.md` file


#Objectives

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 



#The UCI HAR Dataset

The UCI HAR Dataset contains both a training dataset and a test dataset. Each set has 3 files. 

- One that contains the measurements
- A second one that contains the subject id
- A third one that contains the activity ID. 

Also, on the root directory, there is a file `features.txt` that contains the features descriptions and `activity_labels.txt` that contains the activity descriptions.


#Loading the UCI Dataset

As we need only the mean and standart deviation for each measurement, we load the the "features.txt" file in order to extract which field names contain the words `-mean()` and `-std()`. The result is a list containing 66 features (33 with standard deviations and 33 with means)

The next step is to load the load the train and test dataset. The measurements file has 561 fields, each one with 16 characters, so, we can read it with as a fixed file. 

In order save memory, we can use the information extracted from the features file to select which fields to load. The next steps are to load the subjects and activity ids from the dataset and combine them with the measurements.

After loading both the train and test datasets, the next step is joining them together.

Next, we give descriptive column names for the information loaded from the datasets    

With the full dataset ready, we load the activity descriptions and join them with the full dataset. 

The last step for generating the full dataset is dropping the activity id column.
    
#Generating the Tidy dataset.

With the full dataset ready, we use the 'plyr' package to generate the means for each mesurement column, grouped by the "Activity" and "Subject" columns. Then we save the dataset to a file on `/data/tidy.txt`



