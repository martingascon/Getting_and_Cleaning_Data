library(RMySQL)
# GENOMICS in http://genome.usc.edu 
# documentation in http://genome.usc.edu/goldenPath/help/mysql.html
# mysql --user=genome --host=genome-mysql.cse.uscs.edu -A

ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu" )
result <-dbGetQuery(ucscDb,"show databases;"); 
################ very important!!!1
dbDisconnect(ucscDb);

hg19 <- dbConnect(MySQL(), db="hg19", user="genome", host="genome-mysql.cse.ucsc.edu" )  
allTables <-dbListTables(hg19)
length(allTables); allTables[1:5]

dbListFields(hg19,"affyU133Plus2")
dbGetQuery(hg19,"select count(*) from affyU133Plus2")
affyData <- dbReadTable(hg19,"affyU133Plus2")
head(affyData)

# select a specific subset
query <- dbSendQuery(hg19,"select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <-fetch(query); quantile(affyMis$misMatches); # True
affyMisSmall <-fetch(query, n=10); dbClearResult(query);
dim(affyMisSmall) # [1] 10 22

### documentation
## http://cran.r-project.org/web/packages/RMySQL/RMySLQ.pdf
## List of commands http://www.pantz.org/software/mysql/mysqlcommands.html

## http://www.r-bloggers.com/mysql-and-r/


