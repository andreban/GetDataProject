#This scripts downloads an process data from the UCI HAR Dataset in order to generate a new tidy datase

library(plyr)
#This method downloads the data file an extracts it to the .data directory
fetchData <- function() {
    #checks if the .data directory exists. If not, create it
    if (!file.exists("./data")) {
        dir.create("./data")
    }
    
    #checks if the UC HAR Dataset folder exists. If not , create it!
    if (!file.exists("./data/UCI HAR Dataset")) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"                            
        zipfile <- "./data/UCI_HAR_data.zip"
        download.file(fileURL, destfile=zipfile, method="curl")
        unzip(zipfile, exdir="./data")
    }
}

#This method reads data from the measurements file, subjects file and activities file and merges them in a single data frame
readData <- function(subjectsFileName, featuresFileName, activitiesFilename, columnIds) {
    #The measurements files have 561 fields, each one with a length of 16 characters
    fields <- rep(-16, 561) 
    fields[columnIds] <- fields[columnIds] * -1
    testSet <- read.fwf(
        file = featuresFileName, 
        header = FALSE,
        widths = fields
    )
    
    #Load the subjects file
    testSubjects <- read.delim(file = subjectsFileName, header=FALSE, stringsAsFactors=FALSE)    
    
    #Load the activities
    activities <- read.delim(file = activitiesFilename, sep=" ", header=FALSE)
    
    #Join the 3 datasets
    testData <- cbind(testSet, testSubjects[,1], activities[,1])     
    testData    
}

#this method reads the features descriptions from the UCI dataset and extracts the ones that 
#refer to the mean and std of the measurements
getMeanAndStdFields <- function() {
    featuresFileName <- "./data/UCI HAR Dataset/features.txt"    
    features <- read.delim(file=featuresFileName, header=FALSE, sep=" ")    
    
    #check which fields have mean
    meanFields <- grep("\\-mean\\(\\)", features[,2])
    
    #check which fields have std
    stdFields <- grep("\\-std\\(\\)", features[,2])
    
    targedFields <- sort(c(meanFields, stdFields))    
    targedFields    
}

#This method loads the activity labels from the UCI HAR Dataset
getActivitiesLabels <- function() {
    activityLabelsFileName <- "./data/UCI HAR Dataset/activity_labels.txt"    
    activityLabels <- read.delim(file=activityLabelsFileName, header=FALSE, sep= " ")    
    activityLabels    
}

#this method reads both the test dataset and train dataset, select the mean and std columns
buildFullDataSet <- function() {
    #the test file names
    testSetFileName <- "./data/UCI HAR Dataset/test/X_test.txt";
    testSubjectFileName <- "./data/UCI HAR Dataset/test/subject_test.txt";
    testSetActivitiesFileName <- "./data/UCI HAR Dataset/test/y_test.txt"
    
    #the train file names
    trainSetfileName <- "./data/UCI HAR Dataset/train/X_train.txt";
    trainSubjectFileName <- "./data/UCI HAR Dataset/train/subject_train.txt";    
    trainSetActivitiesFileName <- "./data/UCI HAR Dataset/train/y_train.txt"    
        
    #get which fields to load
    targedFields <- getMeanAndStdFields()
    
    #load the test data
    testData <- readData(testSubjectFileName, testSetFileName, testSetActivitiesFileName, features[targedFields,1])    
    
    #load the train data
    trainData <- readData(trainSubjectFileName, trainSetfileName, trainSetActivitiesFileName, features[targedFields,1])        
    
    #join both datasets
    fullDataSet <- rbind(testData, trainData)
    
    #Set the column Names
    colnames(fullDataSet) <- c(as.character(features[targedFields,2]), "Subject", "ActivityID")
    
    #Load the Activities Labels
    activityLabels <- getActivitiesLabels()    
    
    #Join the Dataset with the Activities names
    fullDataSet <- merge(fullDataSet, activityLabels, by.x="ActivityID", by.y="V1")
    colnames(fullDataSet)[length(fullDataSet)] <- "Activity"
    
    fullDataSet[,2:length(fullDataSet)] 
}

#This methods builds the tidy dataset.
buildTidyDataSet <- function() {
    fetchData()    #Downloads the data if it doesnt exist
    fullDataSet <- buildFullDataSet(); #Builds the full dataset
    
    tidy <- ddply(fullDataSet, .(Subject, Activity), function(x) colMeans(x[,1:66])) #builds the tidy dataset
    write.table(tidy, file="./data/tidy.txt", row.name=FALSE) #save it to the tidy.txt file    
}



