##run_analysis.R written on 6/19/2014

##This script provides an analysis of a portion of the smart phone data 
##found in the UCI Machine Learning Repository.  This data can be downloaded 
##from the following url: 
##http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##The data was downloaded and datestamped   Fri Jun 13 02:08:30 2014

##This code assumes all files in the download have been unpacked and are available 
##in the working directory.

##Begin the analysis by reading the file giving the feature vector:

fe <- read.table("features.txt", sep="\t")

##Check the structure of the file using dim, str, head.  These are not, 
##strictly speaking, required for analysis, but useful to know.

##dim(fe)
##str(fe)
##head(fe)

##Look for the occurence of 'mean' in features.  Convert to character type:

fechar<- as.character(fe[,1])

##This is a character vector.  We can apply grep to find 
##column names of interest

MeanColumnNumbers<- grep("mean\\(\\)", fechar)
STDColumnNumbers<- grep("std\\(\\)", fechar)

##These commands return row numbers for features involving the expressions
##'mean()' and 'std()'.  While there were other occurences of the word 'Mean'
##and the symbol 'Std', we chose not to include them.  We use these row numbers
##to label comlumns.   

Colinterest<- sort(c(MeanColumnNumbers,STDColumnNumbers))+2
MSTDColumns<- c(1,2,Colinterest)

##We will use the first column for subject and the second for activity

##count the number of columns of interest

length(grep("mean\\(\\)",fechar)) + length(grep("std\\(\\)",fechar)) 

##This gives 66 total.  Thus our data frame will have 68 columns.
##Check out the training data:  read into memory with columns of numeric type


Xtr <- read.table("X_train.txt", comment.char = "",colClasses="numeric")
activitytr <- read.table("y_train.txt", comment.char = "",colClasses="numeric")
subjecttr <- read.table("subject_train.txt", comment.char = "",colClasses="numeric")

##Start constructing the data frame. Combine training data by binding columns

satr<- cbind(subjecttr,activitytr)
DFtrain<- cbind(satr, Xtr)

##include column names

colnames(DFtrain)<-c("subject","activity",fechar)

##Repeat for test data

Xte <- read.table("X_test.txt", comment.char = "",colClasses="numeric")
activityte <- read.table("y_test.txt", comment.char = "",colClasses="numeric")
subjectte <- read.table("subject_test.txt", comment.char = "",colClasses="numeric")

sate<- cbind(subjectte,activityte)
DFtest<- cbind(sate, Xte)

colnames(DFtest)<-c("subject","activity",fechar)

##construct a single data frame - combine on rows

DF<- rbind(DFtrain,DFtest)

##Extract columns of interest

DFfin<- DF[,MSTDColumns]

##running str(DFfin) provides information on the data frame.
##there are 10299 observations of 68 variables.

##As directed, we fix names a little.  To do so, manipulate feature vector
##and glue.  Note  rules about column names

NewC<- gsub("mean\\(\\)", "Mean", names(DFfin))
NewC<- gsub("std\\(\\)", "StdDev", NewC)
NewC<- gsub("tBody", "TimeBody", NewC)
NewC<- gsub("fBody", "FrequencyBody", NewC)
NewC<- gsub("FrequencyBodyBody", "FrequencyBody", NewC)
NewC<- gsub("^[0-9]+", "", NewC)
NewC<- gsub("tGravity", "TimeGravity", NewC)
NewC<- gsub("-X", "XAxis", NewC)
NewC<- gsub("-Y", "YAxis", NewC)
NewC<- gsub("-Z", "ZAxis", NewC)
NewC<- gsub("-", "", NewC)
NewC<- gsub(" ", "", NewC)

colnames(DFfin)<- NewC

##next, we change activity levels.
##read activity labels.  we read the file 'as.is'

alabels <- read.table("activity_labels.txt", as.is=TRUE)

##set up a data frame which will have the required activity labels
 
DFfinal<- DFfin

##glue in the labels

for (i in 1:6) {
	DFfinal$activity[DFfinal$activity == i] <- alabels[i,2]
}

##DFinal is the first tidy data set requested in the assignment. 

##We now consttruct the second tidy data set 
##begin by making a copy of the first tidy data set

temp<- DFfin


##now, nest and compute to construct a data frame which is 180 x 68
##strategy is simple: nested for loops give all combinations of subject 
##and activity.  For each of these, compute an average on columns

Begin by initializing a data frame:

Temp<-data.frame()

##Now loop as described
##temp1 is the data frame for each individual subject
##temp2 is the restricition of temp1 to each particular activity (68 columns)
##third nested loop averages over column entries.  Note that the first two 
##columns have same entries, so averaging produces no change.

for (i in 1:30) {
	temp1<- temp[temp$subject %in% c(i),]
	for (j in 1:6) {
		temp2<- temp1[temp1$activity %in% c(j),]
		for (k in 1:68) {
			Temp[6*(i-1)+j, k] <- mean(temp2[,k])
		}
	}
}

##Temp is the data frame of interest 
##Name the columns

colnames(Temp)<- NewC

##Name activities


for (i in 1:6) {
	Temp$activity[Temp$activity == i] <- alabels[i,2]
}

tidydataforGettingData<- Temp

##write the solution to a txt file

write.table(tidydataforGettingData, file = "tidydataforGettingData.txt", sep= " ", col.names=colnames(Temp)) 

