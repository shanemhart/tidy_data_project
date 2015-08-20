

## Function for cleaning data
run_analysis = function() {
  ## Set Paths for convience
  
  pth <- 'UCI HAR Dataset'
  d1 <- '/test'
  d2 <- '/train'
  
  ## read Lables and features
  act_Labels <- read.csv(paste0(pth, '/activity_labels.txt'), header = FALSE, sep = " ")
  features <- read.csv(paste0(pth, '/features.txt'), header = FALSE, sep = " ")
  
  ## reads x_test, may take some time, followed by subject, and y data
  x_test <- read.fwf(paste0(pth,d1, '/X_test.txt'), widths = rep(16, 561), colClasses = (rep('numeric', 561)))
  sub_test <- read.csv(paste0(pth, d1, '/subject_test.txt'), header = FALSE)
  y_test <- read.csv(paste0(pth, d1, '/y_test.txt'), header = FALSE, colClasses = 'character')


  ## read x_train, may take some time, followed by subject and y data
  x_train <- read.fwf(paste0(pth,d2, '/X_train.txt'), widths = rep(16, 561), colClasses = (rep('numeric', 561)))
  sub_train <- read.csv(paste0(pth, d2, '/subject_train.txt'), header = FALSE)
  y_train <- read.csv(paste0(pth, d2, '/y_train.txt'), header = FALSE, colClasses = 'character')
  
  ## determine which rows have mean data and std data
  mean_cols <-features[grep('mean()', features$V2),]
  std_cols <-features[grep('std()', features$V2),]
  ## combine to one set of columns, and re-order
  tidy_cols = sort(c(mean_cols[,1], std_cols[,1]))
  
  ## filter data
  x_test <- x_test[,tidy_cols]
  x_train <- x_train[,tidy_cols]
  
  ## label cols
  colnames(x_test) <- features[tidy_cols, 2]
  colnames(x_train) <- features[tidy_cols, 2]
  
  ## add activity number, and test_subject, and identifier for test vs train
  x_test["Subject"] <- sub_test[1]
  x_test["Activity"] <- y_test[1]
  x_test["Data_Source"] <- rep('test', nrow(x_test))
  x_train["Subject"] <- sub_train[1]
  x_train["Activity"] <- y_train[1]
  x_train["Data_Source"] <- rep('train', nrow(x_train))
  
  ## merge data together and then sort
  tidy = merge(x_test, x_train, all = TRUE)
  tidy <- tidy[order(tidy$Subject, tidy$Data_Source, tidy$Activity),]
  
  ## label activity tidy data, with lables from activity file
  tidy[tidy$Activity == '1', 81] <- as.character(act_Labels[1,2])
  tidy[tidy$Activity == '2', 81] <- as.character(act_Labels[2,2])
  tidy[tidy$Activity == '3', 81] <- as.character(act_Labels[3,2])
  tidy[tidy$Activity == '4', 81] <- as.character(act_Labels[4,2])
  tidy[tidy$Activity == '5', 81] <- as.character(act_Labels[5,2])
  tidy[tidy$Activity == '6', 81] <- as.character(act_Labels[6,2])
  
  ## re order table so Subject and Activity are first
  tidy <- tidy[,c(80,81, 1:79, 82)]
  
  ## creat matrix to store average data from tidy  number of rows, is number of subjects * number of activities
  m = matrix(0, nrow = (30*6), ncol = ncol(tidy)-3)
  count <-1
  for(i in 1:30) {
    for(n in 1:6) {
      set <- tidy[tidy$Subject == i & tidy$Activity == act_Labels[n,2],]
      m[(count),] <- colMeans(set[,3:81])
      count <- count +1
    }
  }
  ## create vector for subject to bind together with matrix to make data.frame
  sub <- sort(rep(1:30,6))
  frame = data.frame(Subject = sub, Activity = act_Labels[2], m)
  
  ## rename columns
  cnames <- colnames(tidy[1:81])
  colnames(frame) <- cnames
  
  ## write data table
  write.table(frame, file = 'tidy_data.txt', row.names = FALSE)

}

