run<-function(){

  setwd('~/Dropbox/Personal/Coursera/g_getting_and_cleaning_data/Week1_Reading_Local_files/')
  
  # checking and creating directories
  if(!file.exists("data")) { dir.create("data")}
  
  ######################## Question 1
  #The American Community Survey distributes downloadable data about United States communities. 
  #Download the 2006 microdata survey about housing for the state of Idaho using download.file() 
  #from here:
  #https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
  #and load the data into R. The code book, describing the variable names is here:
  #https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
  #How many properties are worth $1,000,000 or more? 

   fileUrl1<-"https://d396qusza40orc.cloudfront.net/getdata/Fdata/ss06hid.csv"
   download.file(fileUrl1,destfile="./data/getdata_ss06hid.csv",method="curl")
   data1<-read.csv("./data/getdata_ss06hid.csv", sep = ",", head = TRUE)  
   print(nrow(data1<-subset(data1,data1$VAL == 24))) ## 53
   print(data1$FES)

  ################## Question 2  
  
  ################# Question 3
  #Download the Excel spreadsheet on Natural Gas Aquisition Program here:
  #https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
  #Read rows 18-23 and columns 7-15 into R and assign the result to a variable called:
  #dat 
  #What is the value of:  sum(dat$Zip*dat$Ext,na.rm=T) 
  library(xlsx) 
  # install.packages("xlsx") if not installed
  fileUrl3<-"https://d396qusza40orc.cloudfront.net/getdata/data/FDATA.gov_NGAP.xlsx"
  download.file(fileUrl3,destfile="./gasnatural.xlsx",method="curl")  # curl because https
  rowIndex<-18:23
  colIndex<-7:15
  dat<-read.xlsx("./data/gasnatural.xlsx",sheetIndex=1, header = TRUE, colIndex=colIndex, rowIndex=rowIndex)
  head(dat)
  sum(dat$Zip*dat$Ext,na.rm=T) #36534720
  
  
################# Question 4
  # Read the XML data on Baltimore restaurants from here: 
  # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml 
  # How many restaurants have zipcode 21231?

   library(XML)
   fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
   fileURL2 <- sub("s", "", fileUrl)   ## XML does not support https
   doc <- xmlTreeParse(fileURL2, useInternal = TRUE)    # parse the file 
   rootNode<-xmlRoot(doc)  
   xmlName(rootNode)
   sum(xpathSApply(rootNode, "//zipcode", xmlValue)==21231)

  
  ########################## Question 5       
  # The American Community Survey distributes downloadable data about United States communities.
  # Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 
  # https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv 
  # using the fread() command load the data into an R object DT
  # Which of the following is the fastest way to calculate the average value of the variable pwgtp15
  library(data.table)
  fileUrl5<-"https://d396qusza40orc.cloudfront.net/getdata/data/ss06pid.csv"
  download.file(fileUrl5,destfile="./data/getdata_ss06pid.csv",method="curl")
  list.files("./")
  DT <- fread("./data/getdata_ss06pid.csv")  


#system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))                         
#system.time(mean(DT$pwgtp15,by=DT$SEX))                                
#system.time(tapply(DT$pwgtp15,DT$SEX,mean))                        
##system.time(rowMeans(DT)[DT$SEX==1]))
##system.time(rowMeans(DT)[DT$SEX==2]))
#system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15))
#system.time(DT[,mean(pwgtp15),by=SEX])                                   

  
### Extract content by attributes 
#   fileUrl = "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
#   doc <- htmlTreeParse(fileUrl, useInternal = TRUE)
#   scores <- xpathSApply(doc, "//li[@class='score']", xmlValue)
#   scores

}



 
