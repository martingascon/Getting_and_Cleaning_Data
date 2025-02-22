---
title: "CodeBook"
output: html_document
---

# 1. Download and extract the Data   


### load needed libraries
```{r}
library(dplyr)
library(reshape2)
setwd('~/Dropbox/Personal/Coursera/g_getting_and_cleaning_data/Project/')
```

### download from url the zip file and unzip
```{r}
url<-"http://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip"
if(!file.exists("./data")){dir.create("./data")}
download.file(url,destfile="./data/Dataset.zip")
unzip("./data/Dataset.zip", exdir="./data/")
list.files("./data/")  
```
### manually rename the folder from "UCI HAR Dataset" to "UCI_HAR_Dataset" H8W
```{r}
file.rename("./data/UCI HAR Dataset", "./data/UCI_HAR_Dataset")
list.files("./data/UCI_HAR_Dataset")   
list.files("./data/UCI_HAR_Dataset/test")   
list.files("./data/UCI_HAR_Dataset/train")  
```

# 2. Perform the required analysis   

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###  1) Merges the training and the test sets to create one data set.

1.1 We have to read the 6 files (3x training and 3x test)
```{r}
subject_train<-read.table("./data/UCI_HAR_Dataset/train/subject_train.txt",head=F)
X_train<-read.table("./data/UCI_HAR_Dataset/train/X_train.txt", head=F)
y_train<-read.table("./data/UCI_HAR_Dataset/train/y_train.txt", head=F)
subject_test<-read.table("./data/UCI_HAR_Dataset/test/subject_test.txt",head=F)
X_test<-read.table("./data/UCI_HAR_Dataset/test/X_test.txt", head=F)
y_test<-read.table("./data/UCI_HAR_Dataset/test/y_test.txt", head=F)
```
Let's see the dimensions.
```{r}
dim(subject_train)  # [1] 7352    1
dim(X_train)        # [1] 7352    561
dim(y_train)        # [1] 7352    1
dim(subject_test)   # [1] 2947    1
dim(X_test)         # [1] 2947    561 
dim(y_test)         # [1] 2947    1
```
1.2 then combine test and training and see dimensions
```{r}
data_train<-cbind(subject_train,y_train,X_train)
data_test<-cbind(subject_test,y_test,X_test)
dim(data_train) #[1] 7352  563     # 1st: subject, 2nd: activity, 561 cols from data
dim(data_test) #[1] 2947  563     #  1st: subject, 2nd: activity, 561 cols from data
```
1.3 merge training and the test datasets
```{r}
dataset = rbind(data_train, data_test)
dim(dataset) # [1] 10299   563
```

### 2) Extracts only the measurements on the mean and standard deviation for each measurement.

2.1 Load features on a table (only 2nd column) 
```{r}
features <-read.table("./data/UCI_HAR_Dataset/features.txt",head=F)[,2] ## only 2nd column
str(features)
```
2.2 Identify which columns contain mean and std
```{r}
selected_mean<-grep("mean",features) ## Add 2 because first two columns are subject and activity 
selected_std<-grep("std", features) ## first two columns are subject and activity 
```
2.3 reduce the dataset only to the extracted columns
```{r}
extracted_columns <- c(1,2,selected_mean+2,selected_std+2)  # 81 in total
dataset<-dataset[,extracted_columns]
```

### 3) Uses descriptive activity names to name the activities in the data set
3.1 load the activity names
```{r}
activity_labels<-read.table("./data/UCI_HAR_Dataset/activity_labels.txt", head=F)
str(activity_labels)
```
3.2 replace activities with activity labels
```{r}
dataset[,2] <-activity_labels[dataset[,2],2]
print(dataset[,2][1:20])
```

### 4) Appropriately labels the data set with descriptive variable names. 
4.1 First row is subject, 2nd activity and the rest are those with mean and std on the name
```{r}
names(dataset) <-c("subject", "activity", as.character(features[selected_mean]),
                   as.character(features[selected_std]))
str(dataset)
```

### 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

5.1 Create labels containing activity and subject and variable with the rest of names
```{r}
labels <-c("activity","subject")
variables <-setdiff(names(dataset),labels)
```
5.2 Data melt using labels and variables, then calculate mean using dcast
```{r}
data_melt = melt(dataset, id = labels, measure.vars = variables)
tidy_dataset <- dcast(data_melt, subject + activity ~ variable, mean)
head(tidy_dataset)
```
5.3 write tidy dataset into a file.
```{r}
write.table(tidy_dataset, file = "./tidy_data.txt",row.name=FALSE)
```

