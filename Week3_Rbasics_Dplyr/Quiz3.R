library(dplyr)
################################################################################# QUIZ3- Q1
#The American Community Survey distributes downloadable data about United States 
# communities. Download the 2006 microdata survey about housing for the state of 
# Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# and load the data into R. The code book, describing the variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Create a logical vector that identifies the households on greater than 10 acres 
# who sold more than $10,000 worth of agriculture products. Assign that logical 
# vector to the variable agricultureLogical. Apply the which() function like this
# to identify the rows of the data frame where the logical vector is TRUE. 
# which(agricultureLogical) What are the first 3 values that result?


setwd('~/Dropbox/Personal/Coursera/g_getting_and_cleaning_data/Week3_Rbasics_Dplyr/')
url<-"https://d396qusza40orc.cloudfront.net/getdata/data/ss06hid.csv"
url2<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"

if(!file.exists("./data")){dir.create("./data")}
download.file(url,destfile="./data/ss06hid.csv",method="curl")
download.file(url2,destfile="./data/ss06hid.pdf",method="curl")
data<-read.csv("./data/ss06hid.csv")
dim(data)
head(data)
str(data)
summary(data)

# first way 
agricultureLogical<- ifelse(data$ACR==3 & data$AGS==6,TRUE,FALSE)
table(agricultureLogical)
sel<-data[which(agricultureLogical),]
head(sel,n=3)
################################################################################# QUIZ3- Q2
#Question 2
#Using the jpeg package read in the following picture of your instructor into R
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
# (some Linux systems may produce an answer 638 different for the 30th quantile)

#install.packages("jpeg")  ## if necessary
library(jpeg)

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url,destfile="./data/Fjeff.jpg",method="curl")
#img <-readJPEG("./dataFjeff.jpg", native = T)
img <- readJPEG("./data/Fjeff.jpg", native = T  )
quantile(img,probs=c(0.3,0.8))

################################################################################# QUIZ3- Q3
# Question 3
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# Load the educational data from this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. How many of the IDs match?
# Sort the data frame in descending order by GDP rank (so United States is last). 
# What is the 13th country in the resulting data frame? 

url3<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url4<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

if(!file.exists("./data")){dir.create("./data")}
download.file(url3,destfile="./data/GDP.csv",method="curl")
datagdp<-read.csv("./data/GDP.csv")

download.file(url4,destfile="./data/FedStats_country.csv",method="curl")
datafed<-read.csv("./data/FedStats_country.csv")

dim(datagdp)
head(datagdp,10)
# we actually have to set the names and remove the first 4 rows and keep cols 1,2,4,5 
datagdp<-datagdp[-(1:4),c(1,2,4,5)]
# now we take only 190 rows
datagdp<-datagdp[1:191,]
names(datagdp)<-c("CountryCode","ranking","Long.Name","GDP")
datagdp$ranking <- as.numeric(as.character(datagdp$ranking))
head(datagdp,5)

dim(datafed)
names(datafed)

matches <- match(datagdp$CountryCode, datafed$CountryCode, nomatch=0)
sum(matches>0)

datagdp <-arrange(datagdp,desc(ranking))
# print the 13th element
print(datagdp$Long.Name[13])

################################################################################# QUIZ3- Q4
#Question 4
#What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
 
# First we have to merge both frames using the short code
merged <- merge(datagdp, datafed, by.x='CountryCode', by.y='CountryCode')
merged$Income.Group <- as.factor(merged$Income.Group)
mean(merged[merged$Income.Group == "High income: OECD", "ranking"], na.rm = TRUE)
mean(merged[merged$Income.Group == "High income: nonOECD", "ranking"], na.rm = TRUE)

################################################################################# QUIZ3- Q5
#Question 5
#Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries are Lower middle income but among the 38 nations with highest GDP?

# using cut
merged$rankGroup <- cut(merged$ranking, breaks=quantile(merged$ranking, probs=c(0.0,0.2,0.4,0.6,0.8,1)))
table(merged$Income.Group, merged$rankGroup)
sum(as.numeric(merged$rankGroup) == 1 & merged$Income.Group == "Lower middle income", na.rm = TRUE)
# first arrange by ranking

# using cut2
library(Hmisc)
merged$rankGroup <- cut2(merged$ranking, g = 5)
table(merged$Income.Group, merged$rankingGroup)
sum(as.numeric(merged$rankGroup) == 1 & merged$Income.Group == "Lower middle income", na.rm = TRUE)








