#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

suppressPackageStartupMessages({
    library(shiny)
    require(shinydashboard)
    library(shinyjs)
    require(Seurat)
    library(dplyr)
    library(patchwork)
    library(shinyFiles)
    library(DT)
    library(ggplot2)
    ## library(DESeq2)
    ## library(MAST)
    library(SingleCellExperiment)
    ## library(SC3)
    ## library(scater)
})

# if (!requireNamespace("BiocManager", quietly = TRUE))
#     install.packages("BiocManager")
# 
# BiocManager::install("DESeq2")
# BiocManager::install("MAST")
# BiocManager::install("SingleCellExperiment")
# BiocManager::install("SC3")
# BiocManager::install("scater")

# Define UI for application that draws a histogram
ui <- tagList(
    dashboardPage(
    dashboardHeader(title = "scShinySeq", tags$li(
        a(
            strong("Roger Cubí Piqué"),
            height = 40,
            href = "https://github.com/RogerCubi/scShiny-seq",
            title = "",
            target = "_blank"
        ),
        class = "dropdown"
    )),
    dashboardSidebar(
        ## id = "tabs",
        useShinyjs(),
        sidebarMenu(id = "sidebar",
                    tags$head(tags$style(".inactiveLink {
                            pointer-events: none;
                           cursor: default;
                           }")),
            menuItem(text = "Introduction", tabName = "intro", icon = icon("info")),
            menuItem(text = "Input Data", tabName = "datainput", icon = icon("upload")),
            menuItem(text = "QC & Filter", tabName = "qcFilterTab", icon = icon("filter")),
            menuItem(text = "Normalization", tabName = "filterNormSelectTab", icon = icon("th")),
            menuItem(text = "Linear Dimensional Reduction", tabName = "pcaTab", icon = icon("th")),
            menuItem(text = "Determine the Dimensionality", tabName = "dimTab", icon = icon("chalkboard-teacher")),
            menuItem(text = "Cell Clustering", tabName = "clusteringTab", icon = icon("object-group")),
            menuItem(text = "Save or load Seurat analysis", tabName = "saveSeuratTab", icon = icon("save")),
            menuItem(text = "Differentially expressed genes", tabName = "diffExpTab", icon = icon("search")),
            menuItem(text = "Visualizing marker expression", tabName = "plotMarkerTab", icon = icon("chart-bar")),
            menuItem(text = "SC3 Clustering", tabName = "sc3Tab", icon = icon("object-group"))
        ) #sidebarMenu
    ), #dashboardSidebar
    dashboardBody(
        tabItems(
            source("ui-tab-intro.R", local = TRUE)$value,
            source("ui-tab-inputdata.R", local = TRUE)$value,
            source("ui-tab-qcfilter.R", local = TRUE)$value,
            source("ui-tab-filterNormSelect.R", local = TRUE)$value,
            source("ui-tab-dimensionalReduction.R", local = TRUE)$value,
            source("ui-tab-dimensionSelect.R", local = TRUE)$value,
            source("ui-tab-clustering.R", local = TRUE)$value,
            source("ui-tab-saveObject.R", local = TRUE)$value,
            source("ui-tab-diffExpress.R", local = TRUE)$value,
            source("ui-tab-visualizingExpression.R", local = TRUE)$value,
            source("ui-tab-sc3Clustering.R", local = TRUE)$value
        )
    ),
)#dashboardPage
)

#max upload 300mb
options(shiny.maxRequestSize = 300*1024^2)

server <- function(input, output, session) {
    
    source("server-initInputData.R",local = TRUE)


    ## By default, all menuitems except `input data`  are disabled
    addCssClass(selector = "a[data-value='qcFilterTab']", class = "inactiveLink")
    addCssClass(selector = "a[data-value='filterNormSelectTab']", class = "inactiveLink")
    addCssClass(selector = "a[data-value='pcaTab']", class = "inactiveLink")
    addCssClass(selector = "a[data-value='dimTab']", class = "inactiveLink")
    addCssClass(selector = "a[data-value='clusteringTab']", class = "inactiveLink")

    ## commented out to allow loading pre-computed objects as first step
    ## maybe the `load sce` function should be moved to the inputtab? @todo
    ## addCssClass(selector = "a[data-value='saveSeuratTab']", class = "inactiveLink")

    addCssClass(selector = "a[data-value='diffExpTab']", class = "inactiveLink")
    addCssClass(selector = "a[data-value='plotMarkerTab']", class = "inactiveLink")
    addCssClass(selector = "a[data-value='sc3Tab']", class = "inactiveLink")


    ## Stepwise enabling menuitems (according to step completion)
    observeEvent(input$upload_data, {
        removeCssClass(selector = "a[data-value='qcFilterTab']", class = "inactiveLink")

    })

    observeEvent(input$submit_threshold, {
        removeCssClass(selector = "a[data-value='filterNormSelectTab']", class = "inactiveLink")    
    })

    observeEvent(input$submit_norm, {
        removeCssClass(selector = "a[data-value='pcaTab']", class = "inactiveLink")
    })

    observeEvent(input$pcaImput, {
        removeCssClass(selector = "a[data-value='dimTab']", class = "inactiveLink")
    })

    observeEvent(input$dimImput, {
        removeCssClass(selector = "a[data-value='clusteringTab']", class = "inactiveLink")
    })

    observeEvent(input$clusteringSelect, {
        removeCssClass(selector = "a[data-value='saveSeuratTab']", class = "inactiveLink")
        removeCssClass(selector = "a[data-value='diffExpTab']", class = "inactiveLink")
        removeCssClass(selector = "a[data-value='sc3Tab']", class = "inactiveLink")
        removeCssClass(selector = "a[data-value='plotMarkerTab']", class = "inactiveLink")
    })

    ## ## in case the plotMarkers should depend upon diffExpr
    ## observeEvent(input$allValidate | input$clusterValidate | input$clusterVsClusterValidate, {
    ##     removeCssClass(selector = "a[data-value='plotMarkerTab']", class = "inactiveLink")

    ## })

    ## example button to show a `jump to next step` capability, @todo check if a good idea?
    observeEvent(input$done_input_data, {
        updateTabsetPanel(session, "sidebar",
                          selected = "qcFilterTab")

    })    
    source("server-qcfilter.R",local = TRUE)

    source("server-normSelect.R",local = TRUE)
    
    source("server-dimensionalReduction.R",local = TRUE)
    
    source("server-dimensionSelect.R",local = TRUE)
    
    source("server-clustering.R",local = TRUE)
    
    source("server-saveObject.R",local = TRUE)
    
    source("server-diffExpress.R",local = TRUE)
    
    source("server-visualizingExpression.R",local = TRUE)
    
    source("server-sc3Clustering.R",local = TRUE)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
