tabItem(tabName = "dimTab",
        
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              numericInput(inputId = "replicateNum", label =  "Number of Permutations", value = 100, min = 1, max = 10000, step = 1),
              numericInput(inputId = "dimNum", label =  "Number of Dimensions to calculate", value = 20, min = 1, max = 1000, step = 1),
              numericInput(inputId = "dimNumGraph", label =  "Number of Dimensions to Show", value = 15, min = 1, max = 1000, step = 1),
              actionButton(inputId = "dimImput", label = "Validate Selection"),
              tags$style("#nextStepClustering {font-size:18px;color:red;display:block;position:relative;text-align:center; }"),
              textOutput("nextStepClustering")
            ),
            mainPanel(
              h4(strong("Determine the ‘dimensionality’ of the dataset")),
              p("To overcome the extensive technical noise in any single feature for scRNA-seq data,
              Seurat clusters cells based on their PCA scores, with each PC essentially representing a
              ‘metafeature’ that combines information across a correlated feature set. 
              The top principal components therefore represent a robust compression of the dataset. 
              However, how many componenets should we choose to include? 10? 20? 100?"),
              p("In ", a("Macosko et al",href="https://www.cell.com/fulltext/S0092-8674(15)00549-8"), ", is implemented a resampling test inspired by the JackStraw procedure. 
                randomly is permuted a subset of the data (1% by default) and rerun PCA, 
                constructing a ‘null distribution’ of feature scores, and repeat this procedure. 
                a ‘significant’ PCs is identified as those who have a strong enrichment of low p-value features."),
              p(strong("The JackStrawPlot function"), "provides a visualization tool for comparing the distribution of p-values for each PC with a uniform distribution (dashed line). 
                ‘Significant’ PCs will show a strong enrichment of features with low p-values (solid curve above the dashed line)."),
              plotOutput("dimSelPlot"),
              conditionalPanel("output.downloadDimensionsPlot",
                               h4(strong("Plot download options")),
                               column(6,numericInput(inputId = "widthDim",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                               column(6,numericInput(inputId = "heightDim",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                               column(6,numericInput(inputId = "dpiDim",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                               column(6,selectInput(inputId = "deviceDim",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                               downloadButton("downloadDimplot", "Download")
              ), # ConditionalPanel
              hr(),
              p("An alternative heuristic method generates an", strong("‘Elbow plot’:"), 
                " a ranking of principle components based on the percentage of variance explained by each one.
                Using the 'elbow method', suggest that the majority of true signal is captured in the PCs before the appearance of an 'elbow' in the plot."),
              plotOutput("elbowPlot"),
              conditionalPanel("output.downloadDimensionsPlot",
                               h4(strong("Plot download options")),
                               column(6,numericInput(inputId = "widthElb",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                               column(6,numericInput(inputId = "heightElb",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                               column(6,numericInput(inputId = "dpiElb",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                               column(6,selectInput(inputId = "deviceElb",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                               downloadButton("downloadElbowPlot", "Download")
              ), # ConditionalPanel
              p("Identifying the true dimensionality of a dataset can be challenging/uncertain for the user.
                The Seurat pipeline therefore suggest these three approaches to consider. 
                The first is more supervised, exploring PCs to determine relevant sources of heterogeneity, and could be used in conjunction with GSEA for example. 
                The second implements a statistical test based on a random null model, but is time-consuming for large datasets, and may not return a clear PC cutoff. 
                The third is a heuristic that is commonly used, and can be calculated instantly.")
            )# mainPanel
          )
        )
)







