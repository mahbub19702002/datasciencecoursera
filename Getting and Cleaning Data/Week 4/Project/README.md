## Read in the train and test data, feature names, and the associated labels
All the different sections of the collected data required for analysis are spread over several different text files in different directories in the supplied dataset. We need to read them in separately to join them together properly to make them suitable for analysis. This part of the code assumes that the dataset directory is at the same level as the run_analysis.R script.

## Check the dimensions of the date to decide how to join them
After reading in the dataset sections we need to check the dimension of the data tables to decide how to correctly join them together for analysis.

## Rename the columns of the train and test data frames
The different data tables do not come with column headings. We must get them from the 'features.txt' file from the dataset directory.

## Add subject and activity label columns to the test and train data frame
The subjects and the activity labels are separated from the actual measurements. We will need to add them at this step.

## Read in textual description of the activity labels
The textual descriptions of the activities are stored in a separate text file. We will need to read them in to replace their numeric representations in the combined data frames.

## Extract columns that have mean() in their names
We will need to extract columns that have 'mean()' and 'std()' in their column names.

## The previous step removes the subject and activity label columns
We need to add them again to the combined data frame

## Rename the columns of the combined data frame with meaningful column names
This step also gets rid of the column names with mean() and std() in their
names. This is necessary, otherwise they cause problems when summarise() method
is applied.

As a last step we get the mean and standard deviation of the different measures
in the data frame for each subject for each activity and write the data frame to
text and CSV files for submission
