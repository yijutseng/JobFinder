library(httr)
library(data.table)
library(XML)
library(shinyapps)
JobList<-fread("JobList",header = FALSE,sep = ' ')
KeywordList<-read.table("Keywords.txt",header = FALSE)

domain <- function(x) {
  paste0(strsplit(x,":")[[c(1, 1)]],'//',strsplit(gsub("http://|https://", "", x), "/")[[c(1, 1)]])
  }
NameList<-c()
SiteList<-c()
ResultList<-c()
ResultUrlList<-c()
for(i in 1:nrow(JobList)){
  doc.html = htmlTreeParse(JobList[i]$V4,useInternal = TRUE)
  mainDomain<-domain(JobList[i]$V4)
  # Extract all the link (HTML tag is a, starting at
  # the root of the document). Unlist flattens the list to
  # create a character vector.
  doc.text = unlist(xpathApply(doc.html, '//a', xmlValue))
  doc.url = unlist(xpathApply(doc.html, '//a', xmlGetAttr,'href'))
  # Replace all \n by spaces
  #doc.text = gsub('\\n', ' ', doc.text)
  # Join all the elements of the character vector into a single
  # character string, separated by spaces
  #doc.text = paste(doc.text, collapse = ' ')
  siteResult<-c()
  if(is.null(doc.text)){
    next
  }
  for(j in 1:length(doc.text)){
    fit<-TRUE
    for(keyIndex in 1:nrow(KeywordList)){
      if(!grepl(KeywordList[keyIndex,],doc.text[j])){
        fit<-FALSE
      }
    }
    if(fit==TRUE){
        NameList<-c(NameList,JobList[i]$V3)
        SiteList<-c(SiteList,JobList[i]$V4)
        ResultList<-c(ResultList,doc.text[j])
        if(grepl('http://|https://',doc.url[j])){
          ResultUrlList<-c(ResultUrlList,doc.url[j])
        }else{
          if(grepl("^/",doc.url[j])){
            ResultUrlList<-c(ResultUrlList,paste0(mainDomain,doc.url[j]))
          }else{
            ResultUrlList<-c(ResultUrlList,paste0(mainDomain,'/',doc.url[j]))
          }
        }
    }
  }
}
ResultDf<-data.frame(NameList,SiteList,ResultList,ResultUrlList)
head(ResultDf)



