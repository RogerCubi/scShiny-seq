tabItem(tabName = "diffExpTab",
        
        fluidPage(
          tabsetPanel(
            tabPanel(title = "Find all markers",
                     wellPanel(h4("Select the parameters:"),
                                fluidRow(column(6,numericInput(inputId = "min.pct",label = "Minimum percentage detection",value = 0.25, min = 0, max = 1,step = 0.05)),
                                         column(6,numericInput(inputId = "logfcThreshold",label = "logfc Threshold",value = 0.25, min = 0, max = Inf,step = 0.05))),
                               fluidRow(column(6,checkboxInput(inputId = "onlyPos",label = "Select only positive markers", value = FALSE)),
                                        column(6,selectInput(inputId = "DEtests",label = "DE analysis test",choices = c("wilcox",
                                                                                                                        "bimod",
                                                                                                                        "roc",
                                                                                                                        "t",
                                                                                                                        "poisson",
                                                                                                                        "negbinom",
                                                                                                                        "LR",
                                                                                                                        "MAST",
                                                                                                                        "DESeq2")))
                                        ),
                               actionButton(inputId = "allValidate",label = "Validate selection"),
                               hr(),
                               fluidRow(column(5,numericInput(inputId = "DEgenNumb", label = "Number of genes per cluster to show", value = 2,min = 1,max = Inf,step = 1))),
                               tableOutput("DEclusterTable")
                               )),
            tabPanel(title = "Find markers by cluster",
                     wellPanel(h4("Select the parameters:"),
                               fluidRow(column(6,numericInput(inputId = "min.pct1",label = "Minimum percentage detection",value = 0.25, min = 0, max = 1,step = 0.05)),
                                        column(6,numericInput(inputId = "logfcThreshold1",label = "logfc Threshold",value = 0.25, min = 0, max = Inf,step = 0.05))
                                        ),
                               checkboxInput(inputId = "onlyPos1",label = "Select only positive markers", value = FALSE),
                               fluidRow(column(6,selectInput("clusterNum", "Cluster Num (ident.1)",choices = c(1,2,3,4), selected = 1)),
                                        column(6,selectInput(inputId = "DEtests1",label = "DE analysis test",choices = c("wilcox",
                                                                                                                         "bimod",
                                                                                                                         "roc",
                                                                                                                         "t",
                                                                                                                         "poisson",
                                                                                                                         "negbinom",
                                                                                                                         "LR",
                                                                                                                         "MAST",
                                                                                                                         "DESeq2")))
                                        ),
                               actionButton(inputId = "clusterValidate",label = "Validate selection"),
                               hr(),
                               fluidRow(column(5,numericInput(inputId = "DEgenNumb1", label = "Number of genes to show", value = 2,min = 1,max = Inf,step = 1))),
                               tableOutput("DEcluster1Table")
                     )),
            tabPanel(title = "Find markers by cluster vs other clusters",
                     wellPanel(h4("Select the parameters:"),
                               fluidRow(column(6,numericInput(inputId = "min.pct2",label = "Minimum percentage detection",value = 0.25, min = 0, max = 1,step = 0.05)),
                                        column(6,numericInput(inputId = "logfcThreshold2",label = "logfc Threshold",value = 0.25, min = 0, max = Inf,step = 0.05))),
                               fluidRow(column(6,checkboxInput(inputId = "onlyPos2",label = "Select only positive markers", value = FALSE)),
                                        column(6,selectInput(inputId = "DEtests2",label = "DE analysis test",choices = c("wilcox",
                                                                                                      "bimod",
                                                                                                      "roc",
                                                                                                      "t",
                                                                                                      "poisson",
                                                                                                      "negbinom",
                                                                                                      "LR",
                                                                                                      "MAST",
                                                                                                      "DESeq2")))
                                        ),
                               fluidRow(column(6,selectInput("clusterNum1", "Cluster Num (ident.1)",choices = c(1,2,3,4), selected = 1)),
                                        column(6,selectInput("clusterNum2", "Cluster Num (ident.2)",choices = c(1,2,3,4), selected = 2))
                               ),
                               actionButton(inputId = "clusterVsClusterValidate",label = "Validate selection"),
                               hr(),
                               fluidRow(column(5,numericInput(inputId = "DEgenNumb2", label = "Number of genes  to show", value = 2,min = 1,max = Inf,step = 1))),
                               tableOutput("DEcluster2Table")
                     )),
            tabPanel(title = "Heatmap",)
          ) # tabsetPanel
        ) # fluidPage
) # tabItem