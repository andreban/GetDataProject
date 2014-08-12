readData <- function(subjectsFileName, featuresFileName, columnIds) {
    rows <- -1;
    fields <- rep(-16, 561)
    fields[columnIds] <- fields[columnIds] * -1
    testSet <- read.fwf(
        file = featuresFileName, 
        header = FALSE,
        widths = fields,
        n=rows
    )
    
    testSubjects <- read.delim(file = subjectsFileName, header=FALSE, nrows=rows)    
    testData <- cbind(testSet, as.factor(testSubjects[,1]))     
    testData    
}

buildFullDataSet <- function() {
    featuresFileName <- "./data/UCI HAR Dataset/features.txt"
    features <- read.delim(file=featuresFileName, header=FALSE, sep=" ")    
    meanFields <- grep("\\-mean\\(\\)", features[,2])
    stdFields <- grep("\\-std\\(\\)", features[,2])
    
    targedFields <- sort(c(meanFields, stdFields))
        
    testSetFileName <- "./data/UCI HAR Dataset/test/X_test.txt";
    testSubjectFileName <- "./data/UCI HAR Dataset/test/subject_test.txt";
    trainSetfileName <- "./data/UCI HAR Dataset/train/X_train.txt";
    trainSubjectFileName <- "./data/UCI HAR Dataset/train/subject_train.txt";    
    
    testData <- readData(testSubjectFileName, testSetFileName, features[targedFields,1])    
    traindata <- readData(trainSubjectFileName, trainSetfileName, features[targedFields,1])        
    fullDataSet <- rbind(testData, traindata)
        
    colnames(fullDataSet) <- c(as.character(features[targedFields,2]), "Subject")
    colnames(fullDataSet)
    fullDataSet    
}

applyMean <- function(dataset) {
    sapply(dataset, mean)
}

splitData <- split(fullDataSet, fullDataSet$Subject)
averagedList <- lapply(splitData, applyMean)
tidy <- sapply(averagedList, c)
tidy <- tidy[1:dim(tidy)[1]-1,]

write.table(tidy, file="./data/tidy.txt")

