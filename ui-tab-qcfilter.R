tabItem(tabName = "qcFilterTab",
        
        fluidRow(
                titlePanel("Filter Cells"),
                p("At this step you can filter the cells, select a threshold to define a 'gate'"),
                column(12,
                       column(4,
                              verticalLayout(plotOutput("violinFeature"),
                                             sliderInput("featureThreshold", label = "Feature threshold selection", min = 0, 
                                                         max = 100, value = c(0, 100)),
                                             textOutput("numberCellsFeature"),
                                             wellPanel(h4(strong("Plot download options")),
                                                       numericInput(inputId = "widthF",label = "Plot width (in cm)", value = 15,min = 1,max = 100),
                                                       numericInput(inputId = "heightF",label = "Plot height (in cm)", value = 10,min = 1,max = 100),
                                                       numericInput(inputId = "dpiF",label = "Plot resolution", value = 300,min = 1,max = 1000),
                                                       selectInput(inputId = "deviceF",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png"),
                                                       downloadButton("downloadFeatureThreshold", "Download")
                                                       ))),
                       
                       column(4,
                              verticalLayout(plotOutput("violinCounts"),
                                             sliderInput("countsThreshold", label = "Feature threshold selection", min = 0, 
                                                         max = 100, value = c(0, 100)),
                                             textOutput("numberCellsCounts"),
                                             wellPanel(h4(strong("Plot download options")),
                                                       numericInput(inputId = "widthC",label = "Plot width (in cm)", value = 15,min = 1,max = 100),
                                                       numericInput(inputId = "heightC",label = "Plot height (in cm)", value = 10,min = 1,max = 100),
                                                       numericInput(inputId = "dpiC",label = "Plot resolution", value = 300,min = 1,max = 1000),
                                                       selectInput(inputId = "deviceC",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png"),
                                                       downloadButton("downloadCountsThreshold", "Download")
                                             ))),
                       column(4,
                              verticalLayout(plotOutput("violinMito"),
                                             sliderInput("mitocondrialThreshold", label = "Feature threshold selection", min = 0, 
                                                         max = 100, value =  100),
                                             textOutput("numberCellsMito"),
                                             wellPanel(h4(strong("Plot download options")),
                                                       numericInput(inputId = "widthM",label = "Plot width (in cm)", value = 15,min = 1,max = 100),
                                                       numericInput(inputId = "heightM",label = "Plot height (in cm)", value = 10,min = 1,max = 100),
                                                       numericInput(inputId = "dpiM",label = "Plot resolution", value = 300,min = 1,max = 1000),
                                                       selectInput(inputId = "deviceM",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png"),
                                                       downloadButton("downloadMitoThreshold", "Download")
                                             )))
                       
                       )
                       ), # fluidRow
        fluidRow(column(6,
                        verticalLayout(
                                tags$style("#numberCellsThreshold {font-size:16px;color:black;display:block;position:relative;text-align:left; }"),
                                textOutput("numberCellsThreshold"),
                                actionButton("submit_threshold","Submit Threshold", style = "width: 100%")
                        )),
                 column(6,
                        tags$style("#nextStepNormalization {font-size:18px;color:red;display:block;position:relative;text-align:center; }"),
                        textOutput("nextStepNormalization")
                        )
                        
        )
        )

