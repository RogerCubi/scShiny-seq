tabItem(tabName = "qcFilterTab",
        
        fluidRow(
                titlePanel("Filter Cells"),
                p("At this step you can filter the cells, select a threshold to define a 'gate'"),
                column(12,
                       column(4,
                              verticalLayout(plotOutput("violinFeature"),
                                             sliderInput("featureThreshold", label = "Feature threshold selection", min = 0, 
                                                         max = 100, value = c(0, 100)),
                                             textOutput("numberCellsFeature"))),
                       
                       column(4,
                              verticalLayout(plotOutput("violinCounts"),
                                             sliderInput("countsThreshold", label = "Feature threshold selection", min = 0, 
                                                         max = 100, value = c(0, 100)),
                                             textOutput("numberCellsCounts"))),
                       column(4,
                              verticalLayout(plotOutput("violinMito"),
                                             sliderInput("mitocondrialThreshold", label = "Feature threshold selection", min = 0, 
                                                         max = 100, value =  100),
                                             textOutput("numberCellsMito")))
                       
                       )
                       ), # fluidRow
        hr(),
        br(),
        fluidRow(column(6,
                        verticalLayout(
                                textOutput("numberCellsThreshold"),
                                actionButton("submit_threshold","Submit Threshold", style = "width: 100%")
                        )),
                 column(6,
                        tags$style("#nextStepNormalization {font-size:18px;color:red;display:block;position:relative;text-align:center; }"),
                        textOutput("nextStepNormalization")
                        )
                        
        )
        )

