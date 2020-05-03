tabItem(tabName = "pcaTab",
        
        # Launch the PCA
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              numericInput(inputId = "PCs_to_Show", label =  "Number of PCs to show", value = 6, min = 1, max = Inf, step = 1),
              numericInput(inputId = "genes_to_Show", label =  "Number of Genes to show", value = 5, min = 1, max = Inf, step = 1),
              actionButton(inputId = "pcaImput", label = "Validate Selection")
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
              plotOutput("dimRedPlot")
            )# mainPanel
          )
        ))
)