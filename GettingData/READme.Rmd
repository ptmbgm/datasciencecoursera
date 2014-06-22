READme
========================================================

The script run_analysis.r fulfills the project requirement for the Coursera offering: Getting and Cleaning Data.

The assignment for the course reads as follows:

"The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected."

The tasks required for the construction of the script were described as follows:

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names. 

5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


The following describes decision choices made in the construction of the code.  

As suggested in the description of the porject, the code assumes that all files are in the directory containing run_analysis.r.

We use read.table to read in the data.  We begin by reading the feature vector assuming tab delimitation.  

Given that we will eventually use the features as labels, we next convert the feature data to character type.

Having obtained a vector of character type, we use grep to search for the occurence of 'mean' and 'std'.   As a modeling choice, we decided to restrict to occurences of 'mean()' and 'std()'.  This is because it wasn't clear whether the other occurences involved measurements of mean and std. 

We locate the required elements using the grep utility and dump the data to a file called 'Colinterest' for "columns of interest."  We shift these by two in anticipation of using the first two columns for subject and activity data.

Next, we read in the training data.  We do this using read.table with columns as numeric to facilitate later computation.

We combined elements of the training data by binding columns.  We then labeled to columns of the data frame (named DFtrain) accordingly.

This processing was repeated for the test data, resulting in a second data frame, named DFtest.

We combined the two data frames using the rbind utility, resulting in the data frame containg all feature data.  

We extracted the columns of interest using the location of columns in which 'mean()' or 'std()' occur.  We called this data frame DFfin.

Next, we rename the column variables according to the principles of tidy data.  This was done using the gsub utility.  Note: there were a couple of assumed typos in the names: serveral places where 'BodyBody' appeared.  These were edited to exclude one copy of 'Body'.  The code appears as a single line in the obvious block. 

Finally, we glued in activity names using activity labels.  

The resulting data frame, DFinal, is the first of the two required tidy data sets.

To complete the assignment we return to the data frame DFfin whose entries are numeric.

We copy to a temporary file and then initialiaze a new data frame.

We then fill the new data frame with the reuired data.  The code is very simple: for each possible subject,activity pair, the code uses a double loop to extract a data frame containg the data for the given pair.  

This is a data frame with 68 columns and a number of rows depending on the given pair.  

The code then averages over the columns of the restricted data frame and dumps the result to the data frame which is being constructed as the solution to the problem (named Temp).

Finally, we label the activities of the solution data frame and write the result as a text file.




