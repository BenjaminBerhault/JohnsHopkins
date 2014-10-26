## DATA #######################################################
# Human Activity Recognition Using Smartphones Dataset
#
# The experiments have been carried out with a group of 30 volunteers 
# within an age bracket of 19-48 years. Each person performed six activities :
# WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
# wearing a smartphone (Samsung Galaxy S II) on the waist. 
# Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration 
# and 3-axial angular velocity at a constant rate of 50Hz. 
# The experiments have been video-recorded to label the data manually. 
# The obtained dataset has been randomly partitioned into two sets, 
# where 70% of the volunteers was selected for generating the training data and 
# 30% the test data. 
###############################################################

## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Load: activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Load: data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)

# Load and process X_test & y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# set columns names
names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_features]

# add a column specifying the activity label corresponding the activity number 
y_test[,2] = activity_labels[y_test[,1]]
# add column headers
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data
test_data <- cbind(subject_test, y_test, X_test)

# Load and process X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

# subject training 
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# set columns names
names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# add a column specifying the activity label corresponding the activity number 
y_train[,2] = activity_labels[y_train[,1]]
# add column headers
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(subject_train, y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")

# substract "subject", "Activity_ID", "Activity_Label" columns
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
