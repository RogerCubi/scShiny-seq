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
        )
)
#         fluidRow(
#           
#           column(12,
#                  h3(strong("QC & Filter (Preprocessing)")),
#                  hr(),
#                  column(12,
#                         column(6,
#                                checkboxInput("mitoFilter", "Show mitocondrial genes",value = TRUE, width = NULL)
#                         ),
#                         column(6,
#                                actionButton("submit_data","validate selection", style = "width: 100%"))
#                  )
#                  
#           )
#         ),
#         fluidRow(
#           hr(),
#           column(12,
#                  plotOutput("qc_violin")),
#           hr(),
#           column(12,
#                  plotOutput("qc_scatter")),
#           hr(),
#           column(12,
#                  # numericInput("maxThreshold",
#                  #              label="Maximum threshold selection",min=1,max=Inf,value=2000),
#                  # numericInput("minThreshold",
#                  #              label="Minimum threshold selection",min=0,max=Inf,value=200),
#                  
#                  numericInput("maxMito",
#                               label="Maximal mitocondrial genes per cell selection",min=0,max=Inf,value=5),
#                  actionButton("submit_threshold","Submit Threshold", style = "width: 100%"))
#         )
# )
