readFiles <- function() {
    testSetFileName <- "./data/UCI HAR Dataset/test/head_X_test_sample.txt";
    print(testSetFileName)
    testSet <- read.fwf(
        file = testSetFileName, 
        header = FALSE, 
        widths = c(16, 16)
    )
    #testSet <- read.delim(file = trainingSetFileName, header = FALSE, sep = " ")
    summary(testSet)
    head(testSet, n = 1)
    

}
?read.fwf
?read.delim