tabItem(tabName = "clusteringTab",
        
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              # selectInput(inputId = "reductTech", label = "Dimensional reduction technique",choices = c("umap","tsne")),
              numericInput(inputId = "dimNumClustering1", label =  "Select first dimension", value = 1, min = 1, max = 1000, step = 1),
              numericInput(inputId = "dimNumClustering2", label =  "Number of significant dimensions", value = 10, min = 1, max = 1000, step = 1),
              numericInput(inputId = "dimResolution", label =  "Resolution or 'Granularity'", value = 0.5, min = 0.1, max = 10, step = 0.1),
              actionButton(inputId = "clusteringSelect", label = "Validate Selection"),
              tags$style("#nextStepSaveOrDE {font-size:18px;color:red;display:block;position:relative;text-align:center; }"),
              textOutput("nextStepSaveOrDE")
            ),
            mainPanel(
              h4(strong("Cluster the cells")),
              p("Seurat v3 applies a graph-based clustering approach, building upon initial strategies in (",a("Macosko et al",href="https://www.cell.com/fulltext/S0092-8674(15)00549-8"),"). 
              Importantly, the distance metric which drives the clustering analysis (based on previously identified PCs) remains the same. 
              However, the seurat approach to partioning the cellular distance matrix into clusters has dramatically improved. 
              The seurat approach was heavily inspired by recent manuscripts which applied graph-based clustering approaches to scRNA-seq data ", a("[SNN-Cliq, Xu and Su, Bioinformatics, 2015]", href= "https://academic.oup.com/bioinformatics/article/31/12/1974/214505")," and CyTOF data ", a("[PhenoGraph, Levine et al., Cell, 2015]", href= "https://www.ncbi.nlm.nih.gov/pubmed/26095251"),". 
              Briefly, these methods embed cells in a graph structure - for example a K-nearest neighbor (KNN) graph, with edges drawn between cells with similar feature expression patterns, and then attempt to partition this graph into highly interconnected ‘quasi-cliques’ or ‘communities’.
              As in PhenoGraph, a KNN graph is constructed based on the euclidean distance in PCA space, and refine the edge weights between any two cells based on the shared overlap in their local neighborhoods (Jaccard similarity). 
              This step is performed using the FindNeighbors function, and takes as input the previously defined dimensionality of the dataset.
                To cluster the cells, we next apply modularity optimization techniques such as the Louvain algorithm (default) or SLM ",a("[SLM, Blondel et al., Journal of Statistical Mechanics]",href="https://iopscience.iop.org/article/10.1088/1742-5468/2008/10/P10008"),", to iteratively group cells together, with the goal of optimizing the standard modularity function. 
                The FindClusters function implements this procedure, and contains a resolution parameter that sets the ‘granularity’ of the downstream clustering, with increased values leading to a greater number of clusters.
                We find that setting this parameter between 0.4-1.2 typically returns good results for single-cell datasets of around 3K cells. Optimal resolution often increases for larger datasets. "),
              h4(strong("Non-linear dimensional reduction (UMAP/tSNE)")),
              p("Seurat offers several non-linear dimensional reduction techniques, here implemented tSNE and UMAP, to visualize and explore these datasets.
              The goal of these algorithms is to learn the underlying manifold of the data in order to place similar cells together in low-dimensional space.
                Cells within the graph-based clusters determined here should co-localize on these dimension reduction plots. "),
              radioButtons(inputId = "reductTech", label = "Dimensional reduction technique",choices = c("umap","tsne"),inline = TRUE),
              plotOutput("tsneUmapPlot"),
              conditionalPanel("output.downloadClusteringPlot",
                               h4(strong("Plot download options")),
                               column(6,numericInput(inputId = "widthUmap",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                               column(6,numericInput(inputId = "heightUmap",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                               column(6,numericInput(inputId = "dpiUmap",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                               column(6,selectInput(inputId = "deviceUmap",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                               downloadButton("downloadUmapPlot", "Download")
              ) # ConditionalPanel
            )# mainPanel
          )
        ),
)