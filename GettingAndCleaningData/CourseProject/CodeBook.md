CodeBook
========
## extract_features
Boolean array related to the variables we are interested in

## test_data
the test set is pre-formated with :
* subject ID
* activity ID
* activity label
* 79 relevant variables

## train_data
the training set is pre-formated with :
* subject ID
* activity ID
* activity label
* 79 relevant variables

## data
"data" merge test_data and train_data in one set

## data_labels
Parameters forming the compound key 

## melt_data
Melt data according id_labels and data_labels

## tidy_data
Data that we are looking for : 
"the average of each variable for each activity and each subject"
