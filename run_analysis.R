## Download data file and unzip to directory.
download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
    destfile="dataset.zip")
unzip("dataset.zip")
folder_name = "UCI\ HAR\ Dataset"

print("Reading in all data files.")
## Read in all data files.
labels <- read.table(paste(folder_name, "activity_labels.txt", sep="/"),
                     sep=" ",
                     col.names = c("activity_label", "activity_name"))

features <- read.table(paste(folder_name, "features.txt", sep="/"),
                       sep=" ",
                       col.names = c("id", "feature"))

# Re-label parentheses in feature names as these are not allowed in col.names.
formatted_features <- gsub("\\()", "", features$feature)
formatted_features <- gsub(")", "", formatted_features)
formatted_features <- gsub("\\(", "_", formatted_features)

# Read in test data.
X_test <- read.table(paste(folder_name, "test/X_test.txt", sep="/"),
                     col.names=formatted_features)
subject_test <- read.table(paste(folder_name, "test/subject_test.txt", sep="/"),
                           col.names = c("volunteer"))
y_test <- read.table(paste(folder_name, "test/y_test.txt", sep="/"),
                     col.names = c("activity_label"))

# Read in training data.
X_train <- read.table(paste(folder_name, "train/X_train.txt", sep="/"),
                      col.names=formatted_features)
subject_train <- read.table(
    paste(folder_name, "train/subject_train.txt", sep="/"),
    col.names = c("volunteer"))
y_train <- read.table(paste(folder_name, "train/y_train.txt", sep="/"),
                      col.names = c("activity_label"))

# Read in all test and train data for each dimension and assign in
# appropriately named variable.
test_vars = c()
train_vars = c()
for (data_set in c("test", "train")) {
  for (measurement in c("body_acc", "body_gyro", "total_acc")) {
    for (dim in c("x", "y", "z")) {
      colnames <- paste(measurement, dim, "reading",
                        as.character(1:128), sep="_")
      dataname <- paste(measurement, dim, data_set, sep="_")
      path <- paste(folder_name, data_set, "Inertial\ Signals", dataname, sep="/")
      path <- paste(path, "txt", sep=".")

      # Store read in dataset into variable.
      created <- read.table(path, col.names=colnames)

      # Store calculated mean into column.
      created[[paste(measurement, dim, "mean", sep="_")]] <- rowMeans(created)
      # Store calculated standard deviation into column.
      created[[paste(measurement, dim, "std", sep="_")]] <- apply(created, 1, sd)

      assign(dataname, created)

      if (data_set == "test") {
        test_vars <- c(test_vars, dataname,
                       paste(dataname, "mean", sep="_"),
                       paste(dataname, "mean", sep="_"))
      } else {
        train_vars <- c(train_vars, dataname,
                        paste(dataname, "mean", sep="_"),
                        paste(dataname, "mean", sep="_"))
      }
    }
  }
}

## Process and merge data
print("Merging all data together....")
labeled_test_activities <- merge(y_test, labels, by.x="activity_label", by.y="activity_label")
labeled_train_activities <- merge(y_train, labels, by.x="activity_label", by.y="activity_label")

# 1. Merge the training and the test sets to create one data set.
all_train <- cbind(X_train, subject_train, y_train)
all_train$activity <- labeled_train_activities$activity_name
for (data in train_vars) {
  all_train <- cbind(all_train, get(data))
}

all_test <- cbind(X_test, subject_test, y_test)
all_test$activity <- labeled_test_activities$activity_name
for (data in test_vars) {
  all_test <- cbind(all_test, get(data))
}

all_data <- rbind(all_test, all_train)
print("All merged data stored in 'all_data'.")

# 2. Extracts only the measurements on the mean and standard deviation for each
#    measurement.


# 3. Use descriptive activity names to name the activities in the data set.

# 4. Appropriately labels the data set with descriptive variable names.

# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
