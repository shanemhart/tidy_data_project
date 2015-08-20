readme for tidy data
8/20/15

The original data source is the UCI HAR Dataset, which can be found here.
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

with a full description of the experiment can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

For a full description of the data, see the original files.  But to summarize 30 individuals were analyzed while doing 6 different activities.  Data was acquired in short timed segments over the various activities.  Thus a large amount of data for each individual for each activity was acquired and stored.  
To further complicate things the data was split into two sets, a third of the individuals were used to test the experiment, while the remaing individuals were used the experiment.  Creating two sets of data labeled train, and test.

A “tidy” data set was desired that contained only the mean and standard deviations of the various data that was collected.  Further more the mean of each of those data features was to be summarized to each individual for each activity they participated in.

The following procedure was utilized in a R script named run_analsis.R:  This script is intend to be ultized sitting in the same working folder as the UCI HAR folder as created by unzipping the zip file.  

First the label and feature files were read into memory to have a record of what activities, and what the data contained in the real files represented.  

Then the data for the test group was read into memory.  As the data files were big, this took a few minutes for some of the files.  This was split into 3 files.  One contains the actual raw data, the other contains which subjects that data corresponded too.  And the third containing which activity was being performed while that data was being collected.  Each file was read into its on data frame in R.  This was then repeated for the training data set.

Since only the mean and std data was desired, the feature file which listed what each data column represented as analyzed using grep to determine which rows contained data on mean and std.  

This data was combined and stored as vector and used to filter out the data frames of the test and train data to only the columns that was desired.  After the data was filtered this same list was used to label the data columns by using the names that was contained directly in the feature file to its appropriate columns.

Then activity data and subject data was added to the data frame for each row in each of the train and test data.  Then the two data sets were combined into one using the merge() function, and then resorted with tidy() by Subject, source of data (test / train), and activity.

At this point the activities in the data frame were still listed as numeric integers 1:6.  So this was then replaced with a string of the activity performed, ripped directly from the Activity.txt file.

Then columns were re-orded in this data set so that subject and activity would be displayed first for ease of viewing.

Then a matrix was created of the appropriate dimensions to store the mean of each of the readings taken during each activity by each individual.  A for loop was then utilized to filter out the data for each subject, for each activity and the colMeans() function used to calculate the mean of each column.  this was then stored in the previously mentioned matrix.


A new data frame was created using the matrix, and then happened with subject and activity data.  The column names were transferred over from the data file, and this file was then outputted as ‘tidy_data.txt’
