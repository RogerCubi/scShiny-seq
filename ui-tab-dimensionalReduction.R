tabItem(tabName = "pcaTab",
        
        # Launch the PCA
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              numericInput(inputId = "PCs_to_Show", label =  "Number of PCs to show", value = 6, min = 1, max = Inf, step = 1),
              numericInput(inputId = "genes_to_Show", label =  "Number of Genes to show", value = 5, min = 1, max = Inf, step = 1),
              actionButton(inputId = "pcaImput", label = "Validate Selection"),
              tags$style("#nextStepDimensionality {font-size:18px;color:red;display:block;position:relative;text-align:center; }"),
              textOutput("nextStepDimensionality")
            ),
            mainPanel(
              verbatimTextOutput("renderprint")
              )# mainPanel
          )
        ),
        
        # Visualization of the PCA
        
        conditionalPanel("output.pcaReactive",
                         fluidPage(
          sidebarLayout(
            sidebarPanel(
              selectInput(inputId = "visualizePCA", label =  "Select PCA visualization",
                          choices = c("VizDimReduction","DimPlot","DimHeatmap"),selected = "VizDimReduction"),
              conditionalPanel(condition = "input.visualizePCA == 'VizDimReduction'",
                               numericInput(inputId = "vizdims", label =  "Number of Dimensions to show", value = 2, min = 1, max = Inf, step = 1)
                               ),
              conditionalPanel(condition = "input.visualizePCA == 'DimHeatmap'",
                               numericInput(inputId = "heatdims", label =  "Number of Dimensions to show", value = 6, min = 1, max = Inf, step = 1),
                               numericInput(inputId = "cellNumber", label =  "Number of Cells to show", value = 500, min = 1, max = Inf, step = 1)
                               ),
              hr(),
              actionButton(inputId = "pcaGraphImput", label = "Validate Selection")
            ), # sidebarPanel
            mainPanel(
              plotOutput("dimRedPlot"),
              conditionalPanel("output.downloadPCA && input.visualizePCA == 'VizDimReduction'",
                               h4(strong("Plot download options")),
                               column(6,numericInput(inputId = "widthViz",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                               column(6,numericInput(inputId = "heightViz",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                               column(6,numericInput(inputId = "dpiViz",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                               column(6,selectInput(inputId = "deviceViz",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                               downloadButton("downloadVizDimReduction", "Download")
              ), # ConditionalPanel
              conditionalPanel("output.downloadPCA && input.visualizePCA == 'DimPlot'",
                               h4(strong("Plot download options")),
                               column(6,numericInput(inputId = "widthPCA",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                               column(6,numericInput(inputId = "heightPCA",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                               column(6,numericInput(inputId = "dpiPCA",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                               column(6,selectInput(inputId = "devicePCA",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                               downloadButton("downloadPCAplot", "Download")
              ), # ConditionalPanel
              conditionalPanel("output.downloadPCA && input.visualizePCA == 'DimHeatmap'",
                               h4(strong("Plot download options")),
                               column(6,numericInput(inputId = "widthHeatmap",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                               column(6,numericInput(inputId = "heightHeatmap",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                               column(6,numericInput(inputId = "dpiHeatmap",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                               column(6,selectInput(inputId = "deviceHeatmap",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                               downloadButton("downloadDimHeatmap", "Download")
              ) # ConditionalPanel
            )# mainPanel
          )
        ))
)