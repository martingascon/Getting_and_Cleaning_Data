library(dplyr)
################################################################################# QUIZ4- Q1
# Question 1
#The American Community Survey distributes downloadable data about United States 
# communities. Download the 2006 microdata survey about housing for the state of 
# Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# and load the data into R. The code book, describing the variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Apply strsplit() to split all the names of the data frame on the characters "wgtp". What is the value of the 123 element of the resulting list?
# "" "15"  ,  "w" "15", "wgtp" "15", "wgt" "15"

setwd('~/Dropbox/Personal/Coursera/g_getting_and_cleaning_data/Week4_strings/')
url<-"http://d396qusza40orc.cloudfront.net/getdata/data/ss06hid.csv"
url2<-"http://d396qusza40orc.cloudfront.net/getdata/data/PUMSDataDict06.pdf"

if(!file.exists("./data")){dir.create("./data")}
download.file(url,destfile="./data/ss06hid.csv")
download.file(url2,destfile="./data/ss06hid.pdf")
data<-read.csv("./data/ss06hid.csv")
dim(data)
#head(data,2)
names(data)
#summary(data)
splitNames <- strsplit(names(data),"wgtp")
splitNames[[123]] ## "" "15"

################################################################################# QUIZ4-Q2
#Question 2
# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average? 
# Original data sources: http://data.worldbank.org/data-catalog/GDP-ranking-table
# 387854.4, 381615.4, 377652.4, 381668.9

url3<-"http://d396qusza40orc.cloudfront.net/getdata/data/GDP.csv"  ## rm s from https
if(!file.exists("./data")){dir.create("./data")}
download.file(url3,destfile="./data/GDP.csv")
gdp<-read.csv("./data/GDP.csv")
# we actually have to set the names and remove the first 4 rows and keep cols 1,2,4,5 
gdp<-gdp[-(1:4),c(1,2,4,5)]
# now we take only 190 rows
gdp<-gdp[1:191,]
names(gdp)<-c("CountryCode","ranking","Long.Name","GDP")
names(gdp)
head(gdp,3)
gdps <- gsub(",","",gdp$GDP)
gdps <- gsub(" ","",gdps)
gdps <- as.integer(gdps)
str(gdps)
mean(gdps,na.rm=T) # 377652.4

################################################################################# QUIZ3- Q3
# Question 3
# In the data set from Question 2 what is a regular expression that would allow you to count the number of countries whose name begins with "United"? 
# Assume that the variable with the country names in it is named countryNames. How many countries begin with United?
# grep("*United",countryNames), 5
# grep("^United",countryNames), 4
# grep("United$",countryNames), 3
# grep("^United",countryNames), 3

countryNames<-gdp$Long.Name
countryNames
# remove invalid characters
countryNames <- gsub("\xe3","",countryNames)
countryNames <- gsub("\xe9","",countryNames)
countryNames <- gsub("\xf4","",countryNames)

grep("*United",countryNames)  
countryNames[grep("*United",countryNames)]

grep("^United",countryNames)
countryNames[grep("^United",countryNames)]

grep("United$",countryNames) 
countryNames[grep("United$",countryNames)]

grep("^United",countryNames)
countryNames[grep("^United",countryNames)]

#length(grep("United$",countryNames))  
#length(grep("^United",countryNames))  

################################################################################# QUIZ4- Q4
# Question 4
# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Load the educational data from this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
# Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available, how many end in June? 
# Original data sources: 
# http://data.worldbank.org/data-catalog/GDP-ranking-table 
# http://data.worldbank.org/data-catalog/ed-stats
# 7, 13, 31, 8

url4<-"http://d396qusza40orc.cloudfront.net/getdata/data/EDSTATS_Country.csv"
download.file(url4,destfile="./data/FedStats_country.csv")
fed<-read.csv("./data/FedStats_country.csv")
dim(fed)
names(fed)

names(gdp)<-c("CountryCode","ranking","Long.Name","GDP")
gdp$ranking <- as.numeric(as.character(gdp$ranking))
head(gdp,5)

matches <- match(gdp$CountryCode, fed$CountryCode, nomatch=0)
sum(matches>0)
names(fed)
length(grep("Fiscal year end: June",fed$Special.Notes))



################################################################################# QUIZ4- Q5
#Question 5
# You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded companies on the NASDAQ and NYSE.
# Use the following code to download data on Amazon's stock price and get the times the data was sampled.

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 

# How many values were collected in 2012? How many values were collected on Mondays in 2012?
# 251,51     250, 47    250, 51     252, 47

length(grep("2012",sampleTimes)) # 250

only2012 <- sampleTimes[grep("2012",sampleTimes)]
only2012
count <- 0 
for (i in 1:length(only2012)){
    if (weekdays(only2012[i])=="Monday"){
        print(weekdays(only2012[i]))
        count<-count+1
    }
}
count ## 47
 

