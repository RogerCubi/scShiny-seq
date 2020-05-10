tabItem(tabName = "saveSeuratTab",
        wellPanel(
                fluidPage(h4(strong("Save the Seurat Object")),
                          downloadButton("downloadData", "Download"))),
        wellPanel(
        fluidPage(h4(strong("Load a Seurat Object")),
                  fileInput(inputId = "savedAnalysis",label = "Select an analysis file",multiple = FALSE),
                  textOutput("loadInfo")
                  
        ))
)
