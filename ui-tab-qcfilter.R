tabItem(tabName = "qcFilterTab",
        
        fluidRow(
                h4(strong("Data pre-processing:")),
                p("At this step you can explore QC metrics and filter cells based on a user-defined criteria."),
                p("A few QC metrics commonly used by the ", a("community",href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4758103/"), " include"),
                tags$ul(tags$li("The number of unique genes detected in each cell."),
                        tags$ul(
                                tags$li("Low-quality cells or empty droplets will often have very few genes."),
                                tags$li("Cell doublets or multiplets may exhibit an aberrantly high gene count.")),
                        tags$li("Similarly, the total number of molecules detected within a cell (correlates strongly with unique genes)."),
                        tags$li("The percentage of reads that map to the mitochondrial genome."),
                        tags$ul(
                                tags$li("Low-quality / dying cells often exhibit extensive mitochondrial contamination.")
                        )
                        
                ),
                column(12,
                       column(4,
                              verticalLayout(plotOutput("violinFeature"),
                                             sliderInput("featureThreshold", label = "Features threshold selection", min = 0, 
                                                         max = 1000, value = c(0, 1000)),
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
                                             sliderInput("countsThreshold", label = "Counts threshold selection", min = 0, 
                                                         max = 2000, value = c(0, 2000)),
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
                                             sliderInput("mitocondrialThreshold", label = "% Mitocondrial threshold selection", min = 0, 
                                                         max = 100, value =  10),
                                             textOutput("numberCellsMito"),
                                             wellPanel(h4(strong("Plot download options")),
                                                       numericInput(inputId = "widthM",label = "Plot width (in cm)", value = 15,min = 1,max = 100),
                                                       numericInput(inputId = "heightM",label = "Plot height (in cm)", value = 10,min = 1,max = 100),
                                                       numericInput(inputId = "dpiM",label = "Plot resolution", value = 300,min = 1,max = 1000),
                                                       selectInput(inputId = "deviceM",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png"),
                                                       downloadButton("downloadMitoThreshold", "Download")
                                             )))
                       
                       ),
                column(12,
                       plotOutput("qc_scatter"),
                       column(12,h4(strong("Plot download options")),
                              column(6,numericInput(inputId = "widthS",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                              column(6,numericInput(inputId = "heightS",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                              column(6,numericInput(inputId = "dpiS",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                              column(6,selectInput(inputId = "deviceS",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                              downloadButton("downloadScatter", "Download")
                              )
                       )
                       
                ), # fluidRow
        hr(),
        fluidRow(column(6,
                        verticalLayout(
                                tags$style("#numberCellsThreshold {font-size:16px;color:black;display:block;position:relative;text-align:left; }"),
                                textOutput("numberCellsThreshold"),
                                actionButton("submit_threshold","Submit Threshold", style = "width: 100%")
                        )),
                 column(6,
                        ## tags$style("#nextStepNormalization {font-size:18px;color:red;display:block;position:relative;text-align:center; }"),
                        ## textOutput("nextStepNormalization")
                        uiOutput('nextStepNormalization')

                        )
                        
        )
        )

