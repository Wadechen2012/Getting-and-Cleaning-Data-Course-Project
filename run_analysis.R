# Step 1
# Merges the training and the test sets to create one data set.in.txt")
########################################################################

# read the raw data set
x_test <- read.table("test/X_test.txt", na.string = c("NA", ""))
y_test <- read.table("test/y_test.txt", na.string = c("NA", ""))
subject_test <- read.table("test/subject_test.txt", na.string = c("NA", ""))

x_train <- read.table("train/X_train.txt", na.string = c("NA", ""))
y_train <- read.table("train/y_train.txt", na.string = c("NA", ""))
subject_train <- read.table("train/subject_train.txt", na.string = c("NA", ""))

# create "x" data
x_dataset <- rbind(x_train, x_test)

# create "y" data
y_dataset <- rbind(y_train, y_test)
 
#create " subject" data
subject_dataset <- rbind(subject_train, subject_test)

# Step 2
# Extracts only the measurements on the mean and standard deviation for each measurement. 
##########################################################################################

# read the features data
features <- read.table("features.txt")

# extract the row numbers which of feature names containing the mean and standard deviation for each measurement.
mean_std_features_names <- grep("-(mean|std)\\(\\)", features[ , 2]) 

# subset the x_dataset containing the mean and standard deviation and rename the column names
x_dataset_mean_std <- x_dataset[ , mean_std_features_names]
colnames(x_dataset_mean_std) <- features[mean_std_features_names, 2]

# Step 3
#Uses descriptive activity names to name the activities in the data set
###############################################################################

# read the activity label data
activity_labels <- read.table("activity_labels.txt")

# find the corresponding acitivities and re-assign them back to the y_dataset
y_dataset[ , 1] <- activity_labels[y_dataset[ ,1], 2]


# step 4
# Appropriately labels the data set with descriptive variable names.
################################################################################

# rename the y_dataset and subject_dataset column names
colnames(y_dataset) <- "Activity"
colnames(subject_dataset) <- "Subject"

# create the complete dataset
HCI_HAR_Dataset_mean_std <- cbind(subject_dataset, y_dataset, x_dataset_mean_std)

# correct the "BodyBody" to "Body" , remove "()" and "_" in the column names
names(HCI_HAR_Dataset_mean_std) <- gsub("BodyBody", "Body", names(HCI_HAR_Dataset_mean_std))
names(HCI_HAR_Dataset_mean_std) <- gsub ("-mean\\(\\)", "Mean", names(HCI_HAR_Dataset_mean_std))
names(HCI_HAR_Dataset_mean_std) <- gsub ("-std\\(\\)", "Std", names(HCI_HAR_Dataset_mean_std))

# checking any missing data
table(is.na(HCI_HAR_Dataset_mean_std))

# Step 5
# From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject.
###################################################################################

# calculate the averages of mean and std
average_mean_std <- ddply(HCI_HAR_Dataset_mean_std, .(Subject, Activity), function(x) colMeans(HCI_HAR_Dataset_mean_std[,3:68]))

# Check any missing data
table(is.na(average_mean_std))

# save the result dataset
write.table(average_mean_std, "average_mean_std.txt", row.names = FALSE)




