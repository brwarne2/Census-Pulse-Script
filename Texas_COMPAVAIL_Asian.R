library(dplyr)

# set working directory
setwd("~/Desktop/Pulse/Main")
# create list of files to loop over
file_list <- list.files(pattern="*.csv")
# create data frame named Results
Results <- data.frame(items=c(1:5))
for(i in file_list) {
  #import data
  WeekData <- read.csv(i)
  # Filter for only those living in TEXAS of certain race
  TEXAS <- dplyr::filter(WeekData,EST_ST==48 & RRACE==3) #RRACE==3 EST_ST==48 EST_MSA==26420 RHISPANIC==2
  
  TEXAS$COMPAVAIL <- as.character(TEXAS$COMPAVAIL)
  # Summarize the responses
  Summary_COMPAVAIL_TEXAS <- TEXAS %>%
    filter(COMPAVAIL!=-88,COMPAVAIL!=-99) %>%
    group_by(COMPAVAIL) %>%
    summarise(n=n())
  
  Results <-cbind(Results,summary = Summary_COMPAVAIL_TEXAS$n)
  Week <- i # this should be the week, extract from i
  names(Results)[names(Results)=="summary"] <- paste0("COMPAVAIL_TEXAS_Asian",Week)  
}

# write results to .csv
setwd("~/Desktop/Pulse/Output/COMPAVAIL/TEXAS")
write.table(Results,file="TEXAS_COMPAVAIL_Asian.csv",append=TRUE,sep=",")
