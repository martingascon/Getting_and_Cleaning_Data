library(XML)


url<-"http://scholar.google.com/citations?user=_QkYEf8AAAAJ&hl=en" # Martin Gascon
#url<-"http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en" #Jeff Leek
html<-htmlTreeParse(url,useInternalNodes=T)

# Gets "Martin Gascon, PhD - Google Scholar Citations"
xpathSApply(html,"//title", xmlValue)  

# Gets 
xpathSApply(html,"//td[@id='gsc_a_t']", xmlValue)
xpathSApply(html,"//title",xmlValue)
xpathSApply(html,"//td[@id='Title']", xmlValue)


library(httr)
html2=GET(url)
content2 = content(html2,as="text")
parsedHtml = htmlParse(content2,asText=TRUE)
xpathSApply(parsedHtml,"//title", xmlValue)




