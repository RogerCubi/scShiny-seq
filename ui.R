#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

require(shinydashboard)
require(shinyjs)
require(shinyBS)
require(shinycssloaders)
require(DT)
require(shiny)
require(Seurat)
# require(dplyr)
# require(Matrix)
# require(V8)
# require(sodium)

# Define UI for application that draws a histogram
ui <- tagList(
    dashboardPage(
        dashboardHeader(title = "scShiny-seq"),
        dashboardSidebar(
            sidebarMenu(
                id = "tabs",
                menuItem("Input Data", tabName = "datainput", icon = icon("upload")),
                menuItem("QC & Filter", tabName = "qcFilterTab", icon = icon("th")),
                menuItem("Norm/Detect/Scale",tabName = "filterNormSelectTab",icon = icon("th"))
            )# SidebarMenu
        ),# dashboardSidebar
        dashboardBody(
            tabItems(
                source("ui-tab-inputdata.R", local = TRUE)$value,
                source("ui-tab-qcfilter.R", local = TRUE)$value,
                source("ui-tab-filterNormSelect.R", local = TRUE)$value

                
                
            )
        ),
    )# dashboardPage
)# tagList
