tabItem(tabName = "saveSeuratTab",
        h4(strong("Save or Load the analysis")),
        p("You can save the object at this point so that it can easily be loaded back in without having to rerun 
                            the computationally intensive steps performed above, or easily shared with collaborators."),
        wellPanel(
                fluidPage(h4(strong("Save the Seurat Object")),
                          downloadButton("downloadData", "Save analysis"))),
        wellPanel(
        fluidPage(h4(strong("Load a Seurat Object")),
                  fileInput(inputId = "savedAnalysis",label = "Select an analysis file",multiple = FALSE),
                  textOutput("loadInfo")
                  
        ))
)
