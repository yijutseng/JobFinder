library(shiny)
library(httr)
library(data.table)
library(XML)
domain <- function(x) {
  paste0(strsplit(x,":")[[c(1, 1)]],'//',strsplit(gsub("http://|https://", "", x), "/")[[c(1, 1)]])
}
HTMLSearch<- function(website,name,KeywordList){
  NameList<-c()
  SiteList<-c()
  ResultList<-c()
  ResultUrlList<-c()
    tryCatch({
      doc.html = htmlTreeParse(website,useInternal = TRUE)
      mainDomain<-domain(website)
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
          NameList<-c(NameList,name)
          SiteList<-c(SiteList,website)
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
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  data.frame(NameList,ResultList,SiteList,ResultUrlList)
}

shinyServer(
function(input, output) {
  JobListOri<-fread("JobList",header = FALSE,sep = ' ')
  KeywordList<-read.table("Keywords.txt",header = FALSE)
  NameList<-c()
  SiteList<-c()
  ResultList<-c()
  ResultUrlList<-c()
  SearchedResult<-data.frame(NameList,ResultList,SiteList,ResultUrlList)
  SearchedSiteList<-c()
  
  observeEvent(input$search, {
    output$SearchResult<-DT::renderDataTable({
      withProgress(message = 'Searching...', value = 0, {
        JobList<-subset(JobListOri,JobListOri$V2 %in% input$ri|JobListOri$V2==0)
        JobList<-subset(JobList,JobList$V1 %in% input$area)
        for(i in 1:nrow(JobList)){
          incProgress(1/nrow(JobList), detail = paste("sites:", i,'/',nrow(JobList)))
          if(JobList[i]$V4 %in% SearchedSiteList){
            next
          }
          SearchedSiteList<<-c(SearchedSiteList,JobList[i]$V4)
          tempSearchResult<-HTMLSearch(JobList[i]$V4,JobList[i]$V3,KeywordList)
          SearchedResult<<-rbind(SearchedResult,tempSearchResult)
        }
        
        output$textOutput<-renderText({
          paste0(nrow(JobList)," websites have been searched, ",nrow(SearchedResult)," position(s) are avaliable.")
        })
        #SearchedResult
        subset(SearchedResult,SearchedResult$SiteList %in% JobList$V4)
      })
    },rownames = FALSE)
    
  })
}
)