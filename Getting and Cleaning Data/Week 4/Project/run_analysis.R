library(dplyr)

# Read in the train and test data, feature names, and the associated labels
X_test_df <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "", dec = ".")
X_train_df <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "", dec = ".")
y_test_df <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "", dec = ".")
y_train_df <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "", dec = ".")
subjects_test_df <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")
subjects_train_df <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")
features_df <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, sep = "", dec = ".")
features_df <- features_df[-c(1)]

# Check the dimensions of the date to decide how to join them
#dim(X_test_df)
#dim(y_test_df)
#dim(X_train_df)
#dim(y_train_df)
#dim(features_df)

# Rename the columns of the train and test data frames
colnames(X_test_df) <- features_df$V2
colnames(X_train_df) <- features_df$V2

# Add subject and activity label columns to the test data frame
X_test_df <- cbind(X_test_df, activityLabel = y_test_df$V1)
X_test_df <- cbind(subject = subjects_test_df$V1, X_test_df)

# Add subject and activity label columns to the train data frame
X_train_df <- cbind(X_train_df, activityLabel = y_train_df$V1)
X_train_df <- cbind(subject = subjects_train_df$V1, X_train_df)

# Read in textual description of the activity labels
al_df <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")
colnames(al_df) <- c("Label", "Description")

# Replace numeric activity labels with their corresponding descriptions in train and test data frame
X_test_df$activityLabel <- al_df$Description[match(X_test_df$activityLabel, al_df$Label)]
X_train_df$activityLabel <- al_df$Description[match(X_train_df$activityLabel, al_df$Label)]

# Combine train and test data frames
temp_df <- rbind(X_test_df, X_train_df)
#dim(temp_df)

# Extract columns that have mean() in their names
fields <- grepl("mean\\(\\)", colnames(temp_df))
m_result <- temp_df[fields]
colnames(m_result)

# Extract columns that have std() in their names
fields <- grepl("std\\(\\)", colnames(temp_df))
s_result <- temp_df[fields]
colnames(s_result)

# This removes the subject and activity label columns
# We need to add them again to the combined data frame
subject <- temp_df$subject
activity_label <- temp_df$activityLabel
df <- cbind(subject, m_result, s_result, activity_label)

# Rename the columns of the combined data frame with meaningful column names
# This step also gets rid of the column names with mean() and std() in their
# names. This is necessary, otherwise they cause problems when summarise() is applied
colnames(df) <- c("subject", "tBodyAccMean_X", "tBodyAccMean_Y", "tBodyAccMean_Z",
                  "tGravityAccMean_X", "tGravityAccMean_Y", "tGravityAccMean_Z",
                  "tBodyAccJerkMean_X", "tBodyAccJerkMean_Y", "tBodyAccJerkMean_Z",
                  "tBodyGyroMean_X", "tBodyGyroMean_Y", "tBodyGyroMean_Z",
                  "tBodyGyroJerkMean_X", "tBodyGyroJerkMean_Y", "tBodyGyroJerkMean_Z",
                  "tBodyAccMagMean", "tGravityAccMagMean", "tBodyAccJerkMagMean",
                  "tBodyGyroMagMean", "tBodyGyroJerkMagMean",
                  "fBodyAccMean_X", "fBodyAccMean_Y", "fBodyAccMean_Z",
                  "fBodyAccJerkMean_X", "fBodyAccJerkMean_Y", "fBodyAccJerkMean_Z",
                  "fBodyGyroMean_X", "fBodyGyroMean_Y", "fBodyGyroMean_Z",
                  "fBodyAccMagMean", "fBodyBodyAccJerkMagMean", "fBodyBodyGyroMagMean",
                  "fBodyBodyGyroJerkMagMean", "tBodyAccStd_X", "tBodyAccStd_Y", "tBodyAccStd_Z",
                  "tGravityAccStd_X", "tGravityAccStd_Y", "tGravityAccStd_Z",
                  "tBodyAccJerkStd_X", "tBodyAccJerkStd_Y", "tBodyAccJerkStd_Z",
                  "tBodyGyroStd_X", "tBodyGyroStd_Y", "tBodyGyroStd_Z",
                  "tBodyGyroJerkStd_X", "tBodyGyroJerkStd_Y", "tBodyGyroJerkStd_Z",
                  "tBodyAccMagStd", "tGravityAccMagStd", "tBodyAccJerkMagStd",
                  "tBodyGyroMagStd", "tBodyGyroJerkMagStd", "fBodyAccStd_X", "fBodyAccStd_Y", "fBodyAccStd_Z",
                  "fBodyAccJerkStd_X", "fBodyAccJerkStd_Y", "fBodyAccJerkStd_Z",
                  "fBodyGyroStd_X", "fBodyGyroStd_Y", "fBodyGyroStd_Z", "fBodyAccMagStd",
                  "fBodyBodyAccJerkMagStd", "fBodyBodyGyroMagStd", "fBodyBodyGyroJerkMagStd", "activity_label")

# Get mean and standard deviation of the different measures in the data frame for each subject for each activity
mean_df <- df %>% select(subject,tBodyAccMean_X,tBodyAccMean_Y,tBodyAccMean_Z,
                         tGravityAccMean_X,tGravityAccMean_Y,tGravityAccMean_Z,
                         tBodyAccJerkMean_X,tBodyAccJerkMean_Y,tBodyAccJerkMean_Z,
                         tBodyGyroMean_X,tBodyGyroMean_Y,tBodyGyroMean_Z,
                         tBodyGyroJerkMean_X,tBodyGyroJerkMean_Y,tBodyGyroJerkMean_Z,
                         tBodyAccMagMean,tGravityAccMagMean,tBodyAccJerkMagMean,
                         tBodyGyroMagMean,tBodyGyroJerkMagMean,
                         fBodyAccMean_X,fBodyAccMean_Y,fBodyAccMean_Z,
                         fBodyAccJerkMean_X,fBodyAccJerkMean_Y,fBodyAccJerkMean_Z,
                         fBodyGyroMean_X,fBodyGyroMean_Y,fBodyGyroMean_Z,
                         fBodyAccMagMean,fBodyBodyAccJerkMagMean,fBodyBodyGyroMagMean,
                         fBodyBodyGyroJerkMagMean,tBodyAccStd_X,tBodyAccStd_Y,tBodyAccStd_Z,
                         tGravityAccStd_X,tGravityAccStd_Y,tGravityAccStd_Z,
                         tBodyAccJerkStd_X,tBodyAccJerkStd_Y,tBodyAccJerkStd_Z,
                         tBodyGyroStd_X,tBodyGyroStd_Y,tBodyGyroStd_Z,
                         tBodyGyroJerkStd_X,tBodyGyroJerkStd_Y,tBodyGyroJerkStd_Z,
                         tBodyAccMagStd,tGravityAccMagStd,tBodyAccJerkMagStd,
                         tBodyGyroMagStd,tBodyGyroJerkMagStd,
                         fBodyAccStd_X,fBodyAccStd_Y,fBodyAccStd_Z,
                         fBodyAccJerkStd_X,fBodyAccJerkStd_Y,fBodyAccJerkStd_Z,
                         fBodyGyroStd_X,fBodyGyroStd_Y,fBodyGyroStd_Z,
                         fBodyAccMagStd,fBodyBodyAccJerkMagStd,fBodyBodyGyroMagStd,
                         fBodyBodyGyroJerkMagStd,activity_label) %>%  
  group_by(subject, activity_label) %>%
  summarise(tBodyAccMean_X = mean(tBodyAccMean_X),tBodyAccMean_Y = mean(tBodyAccMean_Y),tBodyAccMean_Z = mean(tBodyAccMean_Z),
            tGravityAccMean_X = mean(tGravityAccMean_X),tGravityAccMean_Y = mean(tGravityAccMean_Y),tGravityAccMean_Z = mean(tGravityAccMean_Z),
            tBodyAccJerkMean_X = mean(tBodyAccJerkMean_X),tBodyAccJerkMean_Y = mean(tBodyAccJerkMean_Y),tBodyAccJerkMean_Z = mean(tBodyAccJerkMean_Z),
            tBodyGyroMean_X = mean(tBodyGyroMean_X),tBodyGyroMean_Y = mean(tBodyGyroMean_Y),tBodyGyroMean_Z = mean(tBodyGyroMean_Z),
            tBodyGyroJerkMean_X = mean(tBodyGyroJerkMean_X),tBodyGyroJerkMean_Y = mean(tBodyGyroJerkMean_Y),tBodyGyroJerkMean_Z = mean(tBodyGyroJerkMean_Z),
            tBodyAccMagMean = mean(tBodyAccMagMean),tGravityAccMagMean = mean(tGravityAccMagMean),tBodyAccJerkMagMean = mean(tBodyAccJerkMagMean),
            tBodyGyroMagMean = mean(tBodyGyroMagMean),tBodyGyroJerkMagMean = mean(tBodyGyroJerkMagMean),
            fBodyAccMean_X = mean(fBodyAccMean_X),fBodyAccMean_Y = mean(fBodyAccMean_Y),fBodyAccMean_Z = mean(fBodyAccMean_Z),
            fBodyAccJerkMean_X = mean(fBodyAccJerkMean_X),fBodyAccJerkMean_Y = mean(fBodyAccJerkMean_Y),fBodyAccJerkMean_Z = mean(fBodyAccJerkMean_Z),
            fBodyGyroMean_X = mean(fBodyGyroMean_X),fBodyGyroMean_Y = mean(fBodyGyroMean_Y),fBodyGyroMean_Z = mean(fBodyGyroMean_Z),
            fBodyAccMagMean = mean(fBodyAccMagMean),fBodyBodyAccJerkMagMean = mean(fBodyBodyAccJerkMagMean),fBodyBodyGyroMagMean = mean(fBodyBodyGyroMagMean),
            fBodyBodyGyroJerkMagMean = mean(fBodyBodyGyroJerkMagMean),tBodyAccStd_X = mean(tBodyAccStd_X),tBodyAccStd_Y = mean(tBodyAccStd_Y),tBodyAccStd_Z = mean(tBodyAccStd_Z),
            tGravityAccStd_X = mean(tGravityAccStd_X),tGravityAccStd_Y = mean(tGravityAccStd_Y),tGravityAccStd_Z = mean(tGravityAccStd_Z),
            tBodyAccJerkStd_X = mean(tBodyAccJerkStd_X),tBodyAccJerkStd_Y = mean(tBodyAccJerkStd_Y),tBodyAccJerkStd_Z = mean(tBodyAccJerkStd_Z),
            tBodyGyroStd_X = mean(tBodyGyroStd_X),tBodyGyroStd_Y = mean(tBodyGyroStd_Y),tBodyGyroStd_Z = mean(tBodyGyroStd_Z),
            tBodyGyroJerkStd_X = mean(tBodyGyroJerkStd_X),tBodyGyroJerkStd_Y = mean(tBodyGyroJerkStd_Y),tBodyGyroJerkStd_Z = mean(tBodyGyroJerkStd_Z),
            tBodyAccMagStd = mean(tBodyAccMagStd),tGravityAccMagStd = mean(tGravityAccMagStd),tBodyAccJerkMagStd = mean(tBodyAccJerkMagStd),
            tBodyGyroMagStd = mean(tBodyGyroMagStd),tBodyGyroJerkMagStd = mean(tBodyGyroJerkMagStd),
            fBodyAccStd_X = mean(fBodyAccStd_X),fBodyAccStd_Y = mean(fBodyAccStd_Y),fBodyAccStd_Z = mean(fBodyAccStd_Z),
            fBodyAccJerkStd_X = mean(fBodyAccJerkStd_X),fBodyAccJerkStd_Y = mean(fBodyAccJerkStd_Y),fBodyAccJerkStd_Z = mean(fBodyAccJerkStd_Z),
            fBodyGyroStd_X = mean(fBodyGyroStd_X),fBodyGyroStd_Y = mean(fBodyGyroStd_Y),fBodyGyroStd_Z = mean(fBodyGyroStd_Z),
            fBodyAccMagStd = mean(fBodyAccMagStd),fBodyBodyAccJerkMagStd = mean(fBodyBodyAccJerkMagStd),fBodyBodyGyroMagStd = mean(fBodyBodyGyroMagStd),
            fBodyBodyGyroJerkMagStd = mean(fBodyBodyGyroJerkMagStd))

# Write the data frame to text and CSV files for submission
write.table(mean_df, file = "Project_Submission.txt", sep = "\t")
write.csv(mean_df, file = "Project_Submission.csv")
