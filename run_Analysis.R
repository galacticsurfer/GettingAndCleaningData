features <- read.table("./features.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
activity_labels <- read.table("./activity_labels.txt", header=FALSE, sep="")

## Training data (A)
y_train <- read.table("./train/y_train.txt", header=FALSE, sep="")
subject_train <- read.table("./train/subject_train.txt", header=FALSE, sep="")
activity_list_train <- merge(y_train, activity_labels, by = "V1", all = TRUE)$V2
A <- cbind(activity_list_train, subject_train, X_train)
names(A)[3:563] <- features[,2]
names(A)[1:2] <- c('activity', 'subject')

## Test data (B)
X_test <- read.table("./test/X_test.txt", header=FALSE, sep="")
y_test <- read.table("./test/y_test.txt", header=FALSE, sep="")
subject_test <- read.table("./test/subject_test.txt", header=FALSE, sep="")
activity_list_test <- merge(y_test, activity_labels, by = "V1", all = TRUE)$V2
B <- cbind(activity_list_test, subject_test, X_test)
names(B)[3:563] <- features[,2]
names(B)[1:2] <- c('activity', 'subject')

## Final Dataset C (Merging Training and Test data)
C <- rbind(A, B)

## Get variables with mean and std
subset_features <- subset(features, grepl("mean()", V2, fixed=TRUE) | grepl("std()", V2, fixed=TRUE))$V1
extracted_data <- C[subset_features]

## Aggregate the data wrt to activity and subject
extracted_data<-aggregate(. ~ subject+activity,data = extracted_data,FUN=function(extracted_data) c(mn =mean(extracted_data), n=length(extracted_data) ) )

## Write to file
write.csv(file='tidy_data.txt', x=extracted_data)
