################################################################################# QUIZ 2- 1
library(httr)

setwd('~/Dropbox/Personal/Coursera/g_getting_and_cleaning_data/Week2_Reading_data/')

# 1. Find OAuth settings for github: http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
# Replace your key and secret below. Replace from test1 in my Github repo
myapp <- oauth_app("github", key = "mykey",secret = "mysecret")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)

homeTL = GET("https://api.github.com/users/jtleek/repos/datasharing",gtoken)
json1 = content(homeTL)
json1
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]

#################################################################################### QUIZ 2- 2
library(sqldf)  #install.packages("sqldf")
setwd("~/Dropbox/Personal/Coursera/g_getting_and_cleaning_data/Week2_Reading_data")
#url<-"http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv "
#download.file(url,destfile = "data/acs.csv", method="curl")
acs <- read.csv("./data/getdata-data-ss06pid.csv")
query1 <- sqldf("select * from acs where AGEP < 50")
query2 <- sqldf("select pwgtp1 from acs where AGEP < 50")
query3 <- sqldf("select * from acs where AGEP < 50")   
query4 <- sqldf("select * from acs where AGEP < 50 and pwgtp1") 

#################################################################################### QUIZ 2- 3
q<-unique(acs$AGEP)
query5<-sqldf("select distinct AGEP from acs")
query6<-sqldf("select distinct pwgtp1 from acs")
query7<-sqldf("select AGEP where unique from acs")
query8<-sqldf("select unique * from acs")
identical(query6, q)

######################################################################################  QUIZ 2-4 
con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
nchar(htmlCode[c(10,20,30,100)])  ## [1] 45 31  7 25
 
#####################################################################################  QUIZ 2-5 
#Question 5
#Read this data set into R and report the sum of the numbers in the fourth of the nine columns. 
data <- read.table("./data/getdata-wksst8110.for",header=T)
head (data)
data <- data[-(1:4),]
head (data)
sum(data$V4)










