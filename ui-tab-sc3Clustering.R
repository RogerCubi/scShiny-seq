tabItem(tabName = "sc3Tab",
        fluidPage(
          fluidRow(
            actionButton(inputId = "seuratToSce", label = "Prepare data for SC3 clustering"),
            checkboxInput(inputId = "estimateK",label = "Estimate the optimal number of clusters k in the dataset"),
            textOutput(outputId = "sc3ClusterNumber")
          ),
          conditionalPanel("output.sc3ReactiveDone",
            fluidRow(
            hr(),
            p("At this point you can select a range of number of clusters to analyse."),
            numericInput(inputId = "minK", label = "Lower cluster interval",value = 4,min = 1,max = Inf,step = 1),
            numericInput(inputId = "maxK", label = "Upper cluster interval",value = 8,min = 1,max = Inf,step = 1),
            actionButton(inputId = "sc3Analysis", label = "Start the SC3 clustering"),
            hr()
            
          ) #fluidRow
          
        ), # conditionalPanel
        
        
        conditionalPanel("output.sc3AnalysisDone",
                         
                         tabsetPanel(
                           
                           tabPanel(title = "Consensus Matrix",
                                    fluidPage(
                                      sidebarLayout(
                                        sidebarPanel(
                                          sliderInput("clustersCM",label = "Number of clusters k", min = 1, max = 50, value = 2, step = 1, round = TRUE, ticks = FALSE),# animate = animationOptions(interval = 2000, loop = FALSE)),
                                          checkboxGroupInput(inputId = "annotateCM",label = "Annotate cell options", choices = c()),
                                          actionButton(inputId = "runCMgenes", label = "Validate selection")
                                        ),
                                        mainPanel(
                                          p("The consensus matrix is a N by N matrix, where N is the number of cells in the input dataset. 
                                        It represents similarity between the cells based on the averaging of clustering results from all 
                                        combinations of clustering parameters. 
                                        Similarity 0 (blue) means that the two cells are always assigned to different clusters. 
                                        In contrast, similarity 1 (red) means that the two cells are always assigned to the same cluster. 
                                        The consensus matrix is clustered by hierarchical clustering and has a diagonal-block structure. 
                                        Intuitively, the perfect clustering is achieved when all diagonal blocks are completely red and all 
                                        off-diagonal elements are completely blue."),
                                          hr(),
                                          plotOutput(outputId = "plotCMgenes", height = "800px")
                                        )
                                      ),
                                      
                                    ) #fluidPage
                                    
                                    ), # tabPanel
                           tabPanel(title = "Silhouette Plot",
                                    fluidPage(
                                      sidebarLayout(
                                        sidebarPanel(
                                          sliderInput("clustersSilhouette",label = "Number of clusters k", min = 1, max = 50, value = 2, step = 1, round = TRUE, ticks = FALSE),# animate = animationOptions(interval = 2000, loop = FALSE)),
                                          actionButton(inputId = "runSilhouette", label = "Validate selection")
                                        ),
                                        mainPanel(
                                          p("A silhouette is a quantitative measure of the diagonality of the consensus matrix. 
                                        An average silhouette width (shown at the bottom left of the silhouette plot) varies 
                                        from 0 to 1, where 1 represents a perfectly block-diagonal consensus matrix and 0 represents 
                                        a situation where there is no block-diagonal structure. 
                                        The best clustering is achieved when the average silhouette width is close to 1."),
                                          hr(),
                                          plotOutput(outputId = "plotSilhouette")
                                        )
                                      ),
                                      
                                    ) #fluidPage
                                    
                           ), # tabPanel
                           tabPanel(title = "Expression Matrix",
                                    fluidPage(
                                      sidebarLayout(
                                        sidebarPanel(
                                          sliderInput("clustersEM",label = "Number of clusters k", min = 1, max = 50, value = 2, step = 1, round = TRUE, ticks = FALSE),# animate = animationOptions(interval = 2000, loop = FALSE)),
                                          checkboxGroupInput(inputId = "annotateEM",label = "Annotate cell options", choices = c()),
                                          actionButton(inputId = "runEMgenes", label = "Validate selection")
                                        ),
                                        mainPanel(
                                          p("The expression panel represents the original input expression matrix (cells in columns and genes in rows) 
                                        after cell and gene filters. Genes are clustered by kmeans with k = 100 (dendrogram on the left) and the heatmap 
                                        represents the expression levels of the gene cluster centers after log2-scaling."),
                                          hr(),
                                          plotOutput(outputId = "plotEMgenes", height = "800px")
                                        )
                                      ),
                                      
                                    ) #fluidPage
                                    
                           ), # tabPanel
                           tabPanel(title = "Cluster Stability",
                                    fluidPage(
                                      sidebarLayout(
                                        sidebarPanel(
                                          sliderInput("clustersCS",label = "Number of clusters k", min = 1, max = 50, value = 2, step = 1, round = TRUE, ticks = FALSE),
                                          actionButton(inputId = "runCEgenes", label = "Validate selection")
                                        ),
                                        mainPanel(
                                          p("Stability index shows how stable each cluster is accross the selected range of ks. 
                                        The stability index varies between 0 and 1, where 1 means that the same cluster appears 
                                        in every solution for different k."),
                                          hr(),
                                          plotOutput(outputId = "plotCEgenes")
                                        )
                                      ),
                                      
                                    )
                                   
                           ), # tabPanel
                           tabPanel(title = "DE genes",
                                    fluidPage(
                                      sidebarLayout(
                                        sidebarPanel(
                                          sliderInput("clustersDEgenes",label = "Number of clusters k", min = 1, max = 50, value = 2, step = 1, round = TRUE, ticks = FALSE),# animate = animationOptions(interval = 2000, loop = FALSE)),
                                          checkboxGroupInput(inputId = "annotateDEgenes",label = "Annotate cell options", choices = c()),
                                          actionButton(inputId = "runDEgenes", label = "Validate selection")
                                        ),
                                        mainPanel(
                                          p("Differential expression is calculated using the non-parametric Kruskal-Wallis test. 
                                        A significant p-value indicates that gene expression in at least one cluster stochastically dominates one other cluster. 
                                        SC3 provides a list of all differentially expressed genes with 
                                        adjusted p-values < 0.01 and plots gene expression profiles of the 50 genes with the lowest p-values. 
                                        Note that the calculation of differential expression after clustering can introduce a bias in the distribution of p-values, 
                                        and thus we advise to use the p-values for ranking the genes only."),
                                          hr(),
                                          plotOutput(outputId = "plotDEgenes", height = "800px")
                                        )
                                      ),
      
                                    ) #fluidPage
                                  
                           ), # tabPanel
                           tabPanel(title = "Marker Genes",
                                    fluidPage(
                                      sidebarLayout(
                                        sidebarPanel(
                                          sliderInput("clustersMG",label = "Number of clusters k", min = 1, max = 50, value = 2, step = 1, round = TRUE, ticks = FALSE),# animate = animationOptions(interval = 2000, loop = FALSE)),
                                          checkboxGroupInput(inputId = "annotateMG",label = "Annotate cell options", choices = c()),
                                          actionButton(inputId = "runMarkerGenes", label = "Validate selection")
                                        ),
                                        mainPanel(
                                          p("To find marker genes, for each gene a binary classifier is constructed based on the mean cluster expression values. 
                                        The classifier prediction is then calculated using the gene expression ranks. 
                                        The area under the receiver operating characteristic (ROC) curve is used to quantify the accuracy of the prediction. 
                                        A p-value is assigned to each gene by using the Wilcoxon signed rank test. 
                                        By default the genes with the area under the ROC curve (AUROC) > 0.85 and 
                                        with the p-value < 0.01 are selected and the top 10 marker genes of each cluster are visualized in this heatmap."),
                                          hr(),
                                          plotOutput(outputId = "plotMarkerGenes", height = "800px")
                                        )
                                      ),
                                      
                                      
                                      
                                      
                                    ) #fluidPage
                           ) # tabPanel
                         ) # tabsetPanel
                         
                           
                         
                         
        ) # conditionalPanel
        )  #fluidPage
)
