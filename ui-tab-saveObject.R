tabItem(tabName = "saveSeuratTab",
        h4(strong("Save or Load the analysis")),
        p("You can save the object at this point so that it can easily be loaded back in without having to rerun 
                            the computationally intensive steps performed above, or easily shared with collaborators."),
        wellPanel(
                fluidPage(h4(strong("Save the analysis")),
                          radioButtons(inputId = "ObjectClass",label = "Select Object format", choices = c("Seurat", "SingleCellExperiment(SCE)"),inline = TRUE),
                          conditionalPanel(condition = "input.ObjectClass=='SingleCellExperiment(SCE)'", 
                                           p("If you decide to save the analysis with the SCE format, 
                                             please note that the following analysis of the scShiny-seq app are not yet compatible with this format. 
                                             If you want to continue the analysis later in the app, please use the Seurat format.")),
                          downloadButton("downloadData", "Save analysis")
                          )),
        wellPanel(
        fluidPage(h4(strong("Load an analysis file")),
                  fileInput(inputId = "savedAnalysis",label = "Select an analysis file",multiple = FALSE),
                  textOutput("loadInfo")
                  
        ))
)
