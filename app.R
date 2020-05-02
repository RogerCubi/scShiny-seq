#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
require(shinydashboard)
require(Seurat)
library(dplyr)
library(patchwork)

# Define UI for application that draws a histogram
ui <- tagList(
    dashboardPage(
    dashboardHeader(title = "scShinySeq"),
    dashboardSidebar(
        sidebarMenu(
            id = "tabs",
            menuItem(text = "Input Data", tabName = "datainput", icon = icon("upload")),
            menuItem(text = "QC & Filter", tabName = "qcFilterTab", icon = icon("th"))
        ) #sidebarMenu
    ), #dashboardSidebar
    dashboardBody(
        tabItems(
            source("ui-tab-inputdata.R", local = TRUE)$value,
            source("ui-tab-qcfilter.R", local = TRUE)$value
        )
    ),
)#dashboardPage
)

#max upload 300mb
options(shiny.maxRequestSize = 300*1024^2)

server <- function(input, output) {
    
    source("server-initInputData.R",local = TRUE)
    
    source("server-qcfilter.R",local = TRUE)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
