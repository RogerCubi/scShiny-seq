tabItem(tabName = "plotMarkerTab",
        
        fluidPage(
          tabsetPanel(
            tabPanel(title = "Violin plot",
                     selectInput(inputId = "genesToVlnPlot",label = "Select the genes to plot",choices = c(), multiple = TRUE),
                     checkboxInput(inputId = "selectLog",label = 'Use logaritmic scale',value = FALSE),
                     actionButton(inputId = "validateVlnPlot",label = "Validate selection"),
                     plotOutput("violinPlot"),
                     conditionalPanel("output.downloadViolinPlot",
                                      h4(strong("Plot download options")),
                                      column(6,numericInput(inputId = "widthViolinPlot",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                                      column(6,numericInput(inputId = "heightViolinPlot",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                                      column(6,numericInput(inputId = "dpiViolinPlot",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                                      column(6,selectInput(inputId = "deviceViolinPlot",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                                      downloadButton("downloadViolinButton", "Download"))
            ),
            
            tabPanel(title = "Feature plot",
                     column(6,selectInput(inputId = "genesToFeaturePlot",label = "Select the genes to plot",choices = c(), multiple = TRUE),
                     actionButton(inputId = "validateFeaturePlot",label = "Validate selection")),
                     column(6,radioButtons(inputId = "reductTechFeature", label = "Dimensional reduction technique",choices = c("umap","tsne"),inline = TRUE)),
                     fluidRow(column(12,plotOutput("featurePlot"))),
                     fluidRow(conditionalPanel("output.downloadFeaturePlot",
                                      h4(strong("Plot download options")),
                                      column(6,numericInput(inputId = "widthFeaturePlot",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                                      column(6,numericInput(inputId = "heightFeaturePlot",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                                      column(6,numericInput(inputId = "dpiFeaturePlot",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                                      column(6,selectInput(inputId = "deviceFeaturePlot",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                                      downloadButton("downloadFeaturePlotButton", "Download")))
            ),
            
            tabPanel(title = "Ridge plot",
                     selectInput(inputId = "genesToRidgePlot",label = "Select the genes to plot",choices = c(), multiple = TRUE),
                     actionButton(inputId = "validateRidgePlot",label = "Validate selection"),
                     plotOutput("ridgePlot"),
                     conditionalPanel("output.downloadRidgePlot",
                                      h4(strong("Plot download options")),
                                      column(6,numericInput(inputId = "widthRidgePlot",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                                      column(6,numericInput(inputId = "heightRidgePlot",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                                      column(6,numericInput(inputId = "dpiRidgePlot",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                                      column(6,selectInput(inputId = "deviceRidgePlot",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                                      downloadButton("downloadRidgePlotButton", "Download"))
                     
            )# tabPanel
          )
        )
        
        ) #tabItem 