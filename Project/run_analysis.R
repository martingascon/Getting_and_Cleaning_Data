# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. 
# You will be graded by your peers on a series of yes/no questions related to the project. 
#You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or 
# work that you performed to clean up the data called CodeBook.md.
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.  

# One of the most exciting areas in all of data science right now is wearable computing 
# - see for example this article ... 
# Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced
# algorithms to attract new users. 
# The data linked to from the course website represent data collected from the accelerometers 
# from the Samsung Galaxy S smartphone. 
# A full description is available at the site where the data was obtained: 
    
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# Here are the data for the project: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# You should create one R script called run_analysis.R that does the following. 
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

library(dplyr)
library(reshape2)
setwd('~/Dropbox/Personal/Coursera/g_getting_and_cleaning_data/Project/')
    #url<-"http://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip"
    #if(!file.exists("./data")){dir.create("./data")}
    #download.file(url,destfile="./data/Dataset.zip")
    #unzip("./data/Dataset.zip", exdir="./data/")
    #list.files("./data/")  

# manually rename the folder from "UCI HAR Dataset" to "UCI_HAR_Dataset" H8W
    # file.rename"./data/UCI HAR Dataset", "./data/UCI_HAR_Dataset")
    #list.files("./data/UCI_HAR_Dataset")   
    #list.files("./data/UCI_HAR_Dataset/test")   
    #list.files("./data/UCI_HAR_Dataset/train")   


#####  1) Merges the training and the test sets to create one data set.


## 1.1 We have to read the 3 files (training and test). 
## 1.2 then combine test and training
## 1.3 merge training and the test datasets

# 1.1
subject_train<-read.table("./data/UCI_HAR_Dataset/train/subject_train.txt",head=F)
X_train<-read.table("./data/UCI_HAR_Dataset/train/X_train.txt", head=F)
y_train<-read.table("./data/UCI_HAR_Dataset/train/y_train.txt", head=F)
subject_test<-read.table("./data/UCI_HAR_Dataset/test/subject_test.txt",head=F)
X_test<-read.table("./data/UCI_HAR_Dataset/test/X_test.txt", head=F)
y_test<-read.table("./data/UCI_HAR_Dataset/test/y_test.txt", head=F)

dim(subject_train)  # [1] 7352    1
dim(X_train)        # [1] 7352    561
dim(y_train)        # [1] 7352    1
dim(subject_test)   # [1] 2947    1
dim(X_test)         # [1] 2947    561 
dim(y_test)         # [1] 2947    1

# 1.2  
data_train<-cbind(subject_train,y_train,X_train)
data_test<-cbind(subject_test,y_test,X_test)
dim(data_train) #[1] 7352  563     # 1st: subject, 2nd: activity, 561 cols from data
dim(data_test) #[1] 2947  563     #  1st: subject, 2nd: activity, 561 cols from data

# 1.3
dataset = rbind(data_train, data_test)
dim(dataset) # [1] 10299   563

# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
## 2.1 Load feature on a table (only 2nd column) 
## 2.2 Identify which columns contain mean and std
## 2.3 reduce the dataset only to the extracted columns

#2.1
features <-read.table("./data/UCI_HAR_Dataset/features.txt",head=F)[,2] ## only 2nd column
str(features)
#2.2
selected_mean<-grep("mean",features) ## Add 2 because first two columns are subject and activity 
selected_std<-grep("std", features) ## first two columns are subject and activity 
# 2.3
extracted_columns <- c(1,2,selected_mean+2,selected_std+2)  # 81 in total
dataset<-dataset[,extracted_columns]


# 3) Uses descriptive activity names to name the activities in the data set
# 3.1 load the activity names
# 3.2 replace activities with activity labels

# 3.1 
activity_labels<-read.table("./data/UCI_HAR_Dataset/activity_labels.txt", head=F)
str(activity_labels)
# 3.2 
dataset[,2] <-activity_labels[dataset[,2],2]
print(dataset[,2][1:20])

# 4) Appropriately labels the data set with descriptive variable names. 
names(dataset) <-c("subject", "activity", as.character(features[selected_mean]),
                   as.character(features[selected_std]))
str(dataset)
# 5) From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
# 5.1 Create labels containing activity and subject and variable with the rest of names
labels <-c("activity","subject")
variables <-setdiff(names(dataset),labels)
# 5.2 Data melt using labels and variables, then calculate mean using dcast
data_melt = melt(dataset, id = labels, measure.vars = variables)
tidy_dataset <- dcast(data_melt, subject + activity ~ variable, mean)
head(tidy_dataset)
# 5.3 write tidy dataset into a file. 
write.table(tidy_dataset, file = "./tidy_data.txt",row.name=FALSE)


