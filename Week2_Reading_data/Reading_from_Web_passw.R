url<-"http://httpbin.org/basic-auth/user/passwd" # Martin Gascon
pg2 = GET(url)
  authenticate("user","passwd")

names(pg2)


google - handle("http://google.com")
pg1 = GET(handel=google, path="/")
pg2 = GET(handel=google, path="search")

# More info in...
# http://cran.r-project.org/web/packages/httr/httr.pdf
