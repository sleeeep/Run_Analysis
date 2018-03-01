## --------------------------------
## Getting and Cleaning Data
## Course Project
## author: Yan He
## --------------------------------

## load library and data from local repository

if(!require('tidyverse')){
  install.packages("tidyverse")
}
if(!require('reshape2')){
  install.packages('reshape2')
}

library(tidyverse)
library(reshape2)

setwd('/Users/heyan/Documents/Data Science/getting and cleaning data/course project/UCI HAR Dataset')
X_train <- read.table('./train/X_train.txt', header = F)
y_train <- read.table('./train/y_train.txt', header = F)
subject_train <- read.table('./train/subject_train.txt', header = F)

X_test <- read.table('./test/X_test.txt', header = F)
y_test <- read.table('./test/y_test.txt', header = F)
subject_test <- read.table('./test/subject_test.txt', header = F)

features <- read.table('./features.txt', header = F, stringsAsFactors = F)
activity_labels <- read.table('./activity_labels.txt', header = F)

## combine training and testing data set
train_data <- cbind(subject_train, X_train, y_train)
test_data <- cbind(subject_test, X_test, y_test)
all_data <- rbind(train_data, test_data)

names(all_data)[1] <- 'subject_id'
names(all_data)[2:(length(all_data)-1)] <- features[,2]
names(all_data)[length(all_data)] <- 'activity_labels'

## extract mean and std measturements
extract_features_index <- grepl('mean|std', features[,2])
extract_features <- features[,2][extract_features_index]
extract_all_data_features <- all_data[,2:(length(all_data)-1)][,extract_features_index]
extract_all_data <- cbind(all_data[,1], extract_all_data_features, all_data[,length(all_data)])
names(extract_all_data)[1] <- 'subject_id'
names(extract_all_data)[length(extract_all_data)] <- 'activity_labels'

## use descriptive activity names to name
extract_all_data['activity'] <- activity_labels[,2][extract_all_data[['activity_labels']]]

## new data set for average of each variables
## melt data to be a thin one.
melt_data <- melt(extract_all_data, 
                  id = c('subject_id','activity','activity_labels'),
                  measure.vars = extract_features)
## get the average of variables
tidy_data <- dcast(melt_data, subject_id + activity ~ variable, mean)

## save 
write.table(tidy_data, '/Users/heyan/quiz/Run_Analysis/run_analysis.txt')
