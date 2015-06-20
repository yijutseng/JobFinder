library(shiny)
library(ggplot2)
library(DT)
library(shinythemes)

dataset <- diamonds

fluidPage(
  theme = shinytheme("journal"),
  titlePanel("Fide Your Job!! (v0.1)"),
  
  sidebarPanel(
    checkboxGroupInput("ri", 
                       label = h3("Research interests"), 
                       choices = list("Health Informatics" = 1, 
                                      "Health Management" = 2, "Informatics" = 3, "Public Health" = 4),
                       selected = c(1,2,3,4)),
    checkboxGroupInput("area", 
                       label = h3("Area"), 
                       choices = list("Northern Taiwan" = 1, 
                                      "Central Taiwan" = 2, "Southern Taiwan" = 3, "Eastern Taiwan" = 4),
                       selected = c(1,2,3,4)),
    actionButton("search","Cross your fingers")
  ),
  
  mainPanel(
    #datatable('SearchResult'),
    #progressInit(),
    #dataTableOutput('SearchResult')
    textOutput('textOutput'),
    #tableOutput('SearchResult'),
    DT::dataTableOutput('SearchResult')
  )
)