---
title: "Getting and Cleaning Data  Course Project"
output: html_document
---
##Learning objective

This repository contains the R code and required  documentation files for the course project of "Getting and Cleaning Data" in Coursera.

The purpose of this project is to learn the skill sets to collect, work with and clean a data set.  The source data can be downloaded from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  The original raw data and the project full description is available at [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)[1].

##Description of files

* run_analysis.R contains all the R codes required for performing the required analysis;
* cookbook.md describes the variables, the data and work that was done to clean up thte data;
* average_mean_std.txt is the final output results after the analysis.

##Description of R scripts performed

* Step 1. Merges the training and the test sets to create one data set.in.txt")

```x_test <- read.table("test/X_test.txt", na.string = c("NA", ""))```

```y_test <- read.table("test/y_test.txt", na.string = c("NA", ""))```

```subject_test <- read.table("test/subject_test.txt", na.string = c("NA", ""))```

```x_train <- read.table("train/X_train.txt", na.string = c("NA", ""))```

```y_train <- read.table("train/y_train.txt", na.string = c("NA", ""))```

```subject_train <- read.table("train/subject_train.txt", na.string = c("NA", ""))```

```x_dataset <- rbind(x_train, x_test)```

```y_dataset <- rbind(y_train, y_test)```

```subject_dataset <- rbind(subject_train, subject_test)```

* Step 2. Extracts only the measurements on the mean and standard deviation for each measurement 

```features <- read.table("features.txt")```

```mean_std_features_names <- grep("-(mean|std)\\(\\)", features[ , 2])  # extract the row numbers which of feature names containing the mean and standard deviation for each measurement.```

```x_dataset_mean_std <- x_dataset[ , mean_std_features_names]  #subset the x_dataset containing the mean and standard deviation and rename the column names```

```colnames(x_dataset_mean_std) <- features[mean_std_features_names, 2]  # rename the column names```

* Step 3. Uses descriptive activity names to name the activities in the data set.

```activity_labels <- read.table("activity_labels.txt")```


```y_dataset[ , 1] <- activity_labels[y_dataset[ ,1], 2]  # find the corresponding acitivities and re-assign them back to the y_dataset```

* Step 4. Appropriately labels the data set with descriptive variable names.

```colnames(y_dataset) <- "Activity"```

```colnames(subject_dataset) <- "Subject"  # rename the y_dataset and subject_dataset column names```

```HCI_HAR_Dataset_mean_std <- cbind(subject_dataset, y_dataset, x_dataset_mean_std)  # create the complete dataset```

```names(HCI_HAR_Dataset_mean_std) <- gsub("BodyBody", "Body", names(HCI_HAR_Dataset_mean_std)) #correct the "BodyBody" to "Body" in the column names```

```names(HCI_HAR_Dataset_mean_std) <- gsub ("-mean\\(\\)", "Mean", names(HCI_HAR_Dataset_mean_std)) #correct the "-mean()" to "Mean" ```

```names(HCI_HAR_Dataset_mean_std) <- gsub ("-std\\(\\)", "Std", names(HCI_HAR_Dataset_mean_std)) #correct the "-std()" to "Std" ```

```table(is.na(HCI_HAR_Dataset_mean_std))  # checking any missing data```

* Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```average_mean_std <- ddply(HCI_HAR_Dataset_mean_std, .(Subject, Activity), function(x)colMeans(HCI_HAR_Dataset_mean_std[,3:68]))  # calculate the averages of mean and std```

```table(is.na(average_mean_std))  # Check any missing data```

```write.table(average_mean_std, "average_mean_std.txt", row.names = FALSE)  # save the result dataset```

##Citation
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012