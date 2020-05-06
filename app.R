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
library(shinyFiles)
# if (!requireNamespace("BiocManager", quietly = TRUE))
#     install.packages("BiocManager")
# 
# BiocManager::install("DESeq2")

# Define UI for application that draws a histogram
ui <- tagList(
    dashboardPage(
    dashboardHeader(title = "scShinySeq"),
    dashboardSidebar(
        sidebarMenu(
            id = "tabs",
            menuItem(text = "Input Data", tabName = "datainput", icon = icon("upload")),
            menuItem(text = "QC & Filter", tabName = "qcFilterTab", icon = icon("filter")),
            menuItem(text = "Normalization", tabName = "filterNormSelectTab", icon = icon("th")),
            menuItem(text = "Linear Dimensional Reduction", tabName = "pcaTab", icon = icon("th")),
            menuItem(text = "Determine the Dimensionality", tabName = "dimTab", icon = icon("chalkboard-teacher")),
            menuItem(text = "Cell Clustering", tabName = "clusteringTab", icon = icon("object-group")),
            menuItem(text = "Save the Seurat Object", tabName = "saveSeuratTab", icon = icon("save")),
            menuItem(text = "Differentially expressed features", tabName = "diffExpTab", icon = icon("search"))
        ) #sidebarMenu
    ), #dashboardSidebar
    dashboardBody(
        tabItems(
            source("ui-tab-inputdata.R", local = TRUE)$value,
            source("ui-tab-qcfilter.R", local = TRUE)$value,
            source("ui-tab-filterNormSelect.R", local = TRUE)$value,
            source("ui-tab-dimensionalReduction.R", local = TRUE)$value,
            source("ui-tab-dimensionSelect.R", local = TRUE)$value,
            source("ui-tab-clustering.R", local = TRUE)$value,
            source("ui-tab-saveObject.R", local = TRUE)$value,
            source("ui-tab-diffExpress.R", local = TRUE)$value
        )
    ),
)#dashboardPage
)

#max upload 300mb
options(shiny.maxRequestSize = 300*1024^2)

server <- function(input, output, session) {
    
    source("server-initInputData.R",local = TRUE)
    
    source("server-qcfilter.R",local = TRUE)
    
    source("server-normSelect.R",local = TRUE)
    
    source("server-dimensionalReduction.R",local = TRUE)
    
    source("server-dimensionSelect.R",local = TRUE)
    
    source("server-clustering.R",local = TRUE)
    
    source("server-saveObject.R",local = TRUE)
    
    source("server-diffExpress.R",local = TRUE)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
