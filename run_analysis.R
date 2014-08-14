library(plyr)
#This method downloads the data file an extracts it to the .data directory
fetchData <- function() {
    if (!file.exists("./data")) {
        dir.create("./data")
    }
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
    
    testSubjects <- read.delim(file = subjectsFileName, header=FALSE, stringsAsFactors=FALSE)    
    activities <- read.delim(file = activitiesFilename, sep=" ", header=FALSE)
    testData <- cbind(testSet, testSubjects[,1], activities[,1])     
    testData    
}

getMeanAndStdFields <- function() {
    featuresFileName <- "./data/UCI HAR Dataset/features.txt"    
    features <- read.delim(file=featuresFileName, header=FALSE, sep=" ")    
    meanFields <- grep("\\-mean\\(\\)", features[,2])
    stdFields <- grep("\\-std\\(\\)", features[,2])
    
    targedFields <- sort(c(meanFields, stdFields))    
    targedFields    
}

getActivitiesLabels <- function() {
    activityLabelsFileName <- "./data/UCI HAR Dataset/activity_labels.txt"    
    activityLabels <- read.delim(file=activityLabelsFileName, header=FALSE, sep= " ")    
    activityLabels    
}

buildFullDataSet <- function() {
    testSetFileName <- "./data/UCI HAR Dataset/test/X_test.txt";
    testSubjectFileName <- "./data/UCI HAR Dataset/test/subject_test.txt";
    testSetActivitiesFileName <- "./data/UCI HAR Dataset/test/y_test.txt"
    
    trainSetfileName <- "./data/UCI HAR Dataset/train/X_train.txt";
    trainSubjectFileName <- "./data/UCI HAR Dataset/train/subject_train.txt";    
    trainSetActivitiesFileName <- "./data/UCI HAR Dataset/train/y_train.txt"    
        
    targedFields <- getMeanAndStdFields()
    
    testData <- readData(testSubjectFileName, testSetFileName, testSetActivitiesFileName, features[targedFields,1])    
    
    trainData <- readData(trainSubjectFileName, trainSetfileName, trainSetActivitiesFileName, features[targedFields,1])        
    
    fullDataSet <- rbind(testData, trainData)
    
        
    colnames(fullDataSet) <- c(as.character(features[targedFields,2]), "Subject", "ActivityID")
    colnames(fullDataSet)
    fullDataSet    
}

fullDataSet <- buildFullDataSet();
activityLabels <- getActivitiesLabels()

fullDataSet <- merge(fullDataSet, activityLabels, by.x="ActivityID", by.y="V1")
tidy <- ddply(fullDataSet, .(Subject, V2), function(x) colMeans(x[,1:66]))
write.table(tidy, file="./data/tidy.txt")


