# run_analysis.R does the following. 
#
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation 
#    for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive activity names. 
# 5) Creates a second, independent tidy data set with the average
#    of each variable for each activity and each subject. 
#
#
# It assumes that the Samsung data is in a directory called
# 'UCI HAR Dataset' in the current working dirctory.
#
# The output is a file called 'tidy.csv' in the working directory



run_analysis <- function(directoryName = 'UCI HAR Dataset'){
  
  assertDirectory <- function(dir){
    if (!file.exists(dir)){
      stop('input directory ', dir, ' not found')
    }
    if (!file.info(dir)$isdir){
      stop(dir, ' is not a directory')
    }
    dir
  }
  
  # 1) Merges the training and the test sets to create one data set.
  
  # first read in the training data set and produce a data table from it  
      trainDir <- assertDirectory(file.path(directoryName, 'train'))
      trainSubjects <- read.table(file.path(trainDir, 'subject_train.txt'))
      trainLabels <- read.table(file.path(trainDir, 'y_train.txt'))
      trainData <- read.table(file.path(trainDir, 'X_train.txt'))
      trainData <- cbind(subject = trainSubjects[,1], set = 'train',  activity = trainLabels[,1], data = trainData)
  
  # then do the same with the test data set
      testDir <- assertDirectory(file.path(directoryName, 'test'))
      testSubjects <- read.table(file.path(testDir, 'subject_test.txt'))
      testData <- read.table(file.path(testDir, 'X_test.txt'))
      testLabels <- read.table(file.path(testDir, 'y_test.txt'))
      testData <- cbind(subject = testSubjects[,1], set = 'test', activity = testLabels[,1], data= testData)
  
  # then combine the rows from the two data tables
  testData <- rbind(trainData, testData)  
  
  
  # 2) Extracts only the measurements on the mean and standard deviation 
  #    for each measurement. 
  
  # measurements are defined in features.txt
  features <- read.table(file.path(directoryName,'features.txt'), 
                          col.names=c('code', 'label'))
  
  # some of those names have special characters that cannot be used as column names
  # clean up those
  fixedLabels <- gsub('-', '_', features$label, fixed=TRUE)
 
  # label the columns accordingly
  colnames(testData) <- c('subject', 'set', 'activity', fixedLabels)
                   
  # only keep -mean() and -std()
  meanFeatures <- grepl('_mean()_', fixedLabels, fixed=TRUE);
  stdFeatures <- grepl('_std()_', fixedLabels, fixed=TRUE);
  fixedLabels <- fixedLabels[meanFeatures | stdFeatures]
  
  testData <- testData[, c('subject', 'set', 'activity', fixedLabels)]
  
  
  
  # 3) Uses descriptive activity names to name the activities in the data set
  # these names are defined in activity_labels.txt
  activities = read.table(file.path(directoryName,'activity_labels.txt'), 
                          col.names=c('code', 'label'))
  
  testData$activity = factor(testData$activity, activities$code, activities$label);
  
  # 4) Appropriately labels the data set with descriptive activity names.
  
  # same as 3 ?
  
  
  # 5) Creates a second, independent tidy data set with the average
  #    of each variable for each activity and each subject.
  
  testData <- aggregate(testData[,fixedLabels],by=testData[c('subject', 'set', 'activity')], mean)
 
  
  testData
}

write.csv(run_analysis(), 'tidy.csv')