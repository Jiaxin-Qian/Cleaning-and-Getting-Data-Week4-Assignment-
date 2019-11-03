library(dplyr)
# read test data
x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
# read train data
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
# read features for data
features <- read.table('./UCI HAR Dataset/features.txt')
# read activity labels
activity <- read.table('./UCI HAR Dataset/activity_labels.txt')
# 1. merge the training and the test sets to create one data set
x_combo <- rbind(x_train, x_test)
y_combo <- rbind(y_train, y_test)
subject_combo <- rbind(subject_train, subject_test)
# 2. Extracts only the measurements on the mean and std for each measuremnt 
extracted_feat <- features[grep("mean\\(\\)|std\\(\\)", features[,2]),]
x_combo <- x_combo[, extracted_feat[,1]]
# 3. use descriptive activity names to name the activities in the data set
colnames(y_combo) <- "activity"
y_combo$activitylabel <- factor(y_combo$activity, labels = as.character(activity[,2]))
activitylabel <- y_combo[,-1]
# 4. label the data set with descriptive variable names
colnames(x_combo) <- features[extracted_feat[,1],2]
# 5. create a second, indenpendent tidy data set with the average of each variable for ecah activity and each subject
colnames(subject_combo) <- "subject"
new <- cbind(x_combo, activitylabel, subject_combo)
new_mean <- new %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(new_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
