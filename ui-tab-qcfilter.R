tabItem(tabName = "qcFilterTab",
        
        fluidRow(
          
          column(12,
                 h3(strong("QC & Filter (Preprocessing)")),
                 hr(),
                 column(12,
                        column(6,
                               checkboxInput("mitoFilter", "Show mitocondrial genes",value = TRUE, width = NULL)
                        ),
                        column(6,
                               actionButton("submit_data","validate selection", style = "width: 100%"))
                        )

                 )
          ),
        fluidRow(
          hr(),
          column(12,
                 plotOutput("qc_violin")),
          hr(),
          column(12,
                 plotOutput("qc_scatter")),
          hr(),
          column(12,
                 numericInput("maxThreshold",
                              label="Maximum threshold selection",min=1,max=Inf,value=2000),
                 numericInput("minThreshold",
                              label="Minimum threshold selection",min=0,max=Inf,value=200),
                 numericInput("maxMito",
                              label="Maximal mitocondrial genes per cell selection",min=0,max=Inf,value=5),
                 actionButton("submit_threshold","Submit Threshold", style = "width: 100%"))
          )
        )
          
        




