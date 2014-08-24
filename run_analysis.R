library("data.table")
library("reshape2")

activity_types <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

#############################################################
# TEST DATA
#############################################################

#Read test data from files
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Extract activity types
y_test[,2] <- activity_types[y_test[,1]]

#Naming columns
names(x_test) <- features
names(y_test) <- c("Activity_ID", "Activity_Label")
names(subject_test) <- "Subject"

#Extract mean and standard deviation
x_test <- x_test[,grepl("mean|std", features)]

#Combine test data
test_data <- cbind(as.data.table(subject_test), y_test, x_test)

#############################################################
# TRAIN DATA
#############################################################

#Read train data from files
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Extract activity types
y_train[,2] <- activity_types[y_train[,1]]

#Naming columns
names(X_train) <- features
names(y_train) <- c("Activity_ID", "Activity_Label")
names(subject_train) <- "Subject"

#Extract mean and standard deviation
X_train <- X_train[,grepl("mean|std", features)]

#Combine train data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

#############################################################
# TIDY DATA
#############################################################

#Merge test and train data
data = rbind(test_data, train_data)

id_labels <- c("Subject", "Activity_ID", "Activity_Label")
data_labels <- setdiff(colnames(data), id_labels)
melt_data <- melt(data, id = id_labels, measure.vars = data_labels)

#Prepare and write tidy data
tidy_data <- dcast(melt_data, Subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
