tabItem(tabName = "diffExpTab",
        
        fluidPage(
          h4(strong("Finding differentially expressed features (cluster biomarkers)")),
          p( "Seurat allows for pre-filtering of features or cells. The ",strong("Minimum percentage detection"),
             " argument requires a feature to be detected at a minimum percentage in either of the two groups of cells. 
                         The ",strong("logfc Threshold")," argument selects the genes with an average expression above the log-fold change selected.
                         Also its possible to select only the positive markers."),
          tags$ul(
            p("It is possible to perform DE analysis using alternative tests. "),
            tags$li("“wilcox” : Wilcoxon rank sum test (default)"),
            tags$li("“bimod” : Likelihood-ratio test for single cell feature expression, ", a("(McDavid et al., Bioinformatics, 2013)",href="https://www.ncbi.nlm.nih.gov/pubmed/23267174")),
            tags$li("“roc” : Standard AUC classifier"),
            tags$li("“t” : Student’s t-test"),
            tags$li("“poisson” : Likelihood ratio test assuming an underlying Poisson distribution. Use only for UMI-based datasets"),
            tags$li("“negbinom” : Likelihood ratio test assuming an underlying negative binomial distribution. Use only for UMI-based datasets"),
            tags$li("“LR” : Uses a logistic regression framework to determine differentially expressed genes. Constructs a logistic regression model predicting group membership based on each feature individually and compares this to a null model with a likelihood ratio test."),
            tags$li("“MAST” : GLM-framework that treates cellular detection rate as a covariate ", a("(Finak et al, Genome Biology, 2015)",href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4676162/")),
            tags$li("“DESeq2” : DE based on a model using the negative binomial distribution  ", a("(Love et al, Genome Biology, 2014)",href="https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8")),
          ),
          tabsetPanel(
            tabPanel(title = "Find all markers",
                     wellPanel(
                       h4(strong("Features diferentially expressef for all clusters")),
                       p("This panel will find the markers that define clusters via differential expression."),
                       h4("Select the parameters:"),
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
                               fluidRow(column(5,numericInput(inputId = "DEgenNumb", label = "Number of genes per cluster to show", value = 2,min = 1,max = Inf,step = 1)),
                                        column(6, conditionalPanel("output.reactive1Download",
                                                                   downloadButton("downloadDEclusterTable", "Download table")))
                                        ),
                               dataTableOutput("DEclusterTable")
                               )),
            tabPanel(title = "Find markers by cluster",
                     wellPanel(h4("Select the parameters:"),
                               fluidRow(column(6,numericInput(inputId = "min.pct1",label = "Minimum percentage detection",value = 0.25, min = 0, max = 1,step = 0.05)),
                                        column(6,numericInput(inputId = "logfcThreshold1",label = "logfc Threshold",value = 0.25, min = 0, max = Inf,step = 0.05))
                                        ),
                               checkboxInput(inputId = "onlyPos1",label = "Select only positive markers", value = FALSE),
                               fluidRow(column(6,selectInput("clusterNum", "Cluster Num (ident.1)",choices = c(1,2,3,4), selected = 1, multiple = TRUE)),
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
                               fluidRow(column(5,numericInput(inputId = "DEgenNumb1", label = "Number of genes to show", value = 2,min = 1,max = Inf,step = 1)),
                                        column(6, conditionalPanel("output.reactive2Download",
                                                                   downloadButton("downloadDEcluster1Table", "Download table")))
                                        ),
                               dataTableOutput("DEcluster1Table")
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
                               fluidRow(column(6,selectInput("clusterNum1", "Cluster Num (ident.1)",choices = c(1,2,3,4), selected = 1, multiple = TRUE)),
                                        column(6,selectInput("clusterNum2", "Cluster Num (ident.2)",choices = c(1,2,3,4), selected = 2, multiple = TRUE))
                               ),
                               actionButton(inputId = "clusterVsClusterValidate",label = "Validate selection"),
                               hr(),
                               fluidRow(column(6,numericInput(inputId = "DEgenNumb2", label = "Number of genes  to show", value = 2,min = 1,max = Inf,step = 1)),
                                        # Button
                                        column(6, conditionalPanel("output.reactive3Download",
                                                                   downloadButton("downloadDEcluster2Table", "Download table")))
                                        ),
                               
                               # Table outpot
                               dataTableOutput("DEcluster2Table")
                     )),
            tabPanel(title = "Heatmap",
                     fluidRow(
                       sidebarLayout(
                         sidebarPanel(hr(),
                                      numericInput(inputId = "DEgenNumb3", label = "Number of genes  to show", value = 2,min = 1,max = Inf,step = 1),
                                      actionButton(inputId = "heatmapClusterValidate",label = "Validate selection")),
                         mainPanel(titlePanel("Expressio heatmap"),
                                   p("Generates an expression heatmap for given cells and features. Select the number of genes to be represented in the graph."),
                                   p("This graph requires to find all cluster markers previosly. This can be done in the first tab: Find all markers." ))
                       )),
                     fluidRow(plotOutput("clusterHeatmap"),
                              conditionalPanel("output.downloadClusterHeatmapPlot",
                                               h4(strong("Plot download options")),
                                               column(6,numericInput(inputId = "widthClusterHeatmap",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                                               column(6,numericInput(inputId = "heightClusterHeatmap",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                                               column(6,numericInput(inputId = "dpiClusterHeatmap",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                                               column(6,selectInput(inputId = "deviceClusterHeatmap",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                                               downloadButton("downloadClusterHeatmap", "Download")))
                     ) # tabPanel
          ) # tabsetPanel
        ) # fluidPage
) # tabItem