tabItem(tabName = "filterNormSelectTab",

        fluidRow(column(
          12,
          h4(strong("Normalizing the data")),
          p("After removing unwanted cells from the dataset, the next step is to normalize the data. By default, 
            is employed a global-scaling normalization method “LogNormalize” that normalizes the feature expression
            measurements for each cell by the total expression, multiplies this by a scale factor (10,000 by default),
            and log-transforms the result.")
        ),
        hr(),
        column(12,
               h4(strong("Data Normalization")),
               column(6,
                      selectInput("normalization", "Normalization Method", choices = "LogNormalize")
                      ),
               column(6,
                      numericInput("scale", "Scale Factor", value = 10000, min = 1, max = Inf))
               ),
        hr(),
        column(12,
               h4(strong("Detection of variable genes across the single cells")),
               p("Then a subset of features that exhibit high cell-to-cell variation in the dataset are calculated 
                 (i.e, they are highly expressed in some cells, and lowly expressed in others). 
                 Focusing on these genes in downstream analysis helps to highlight biological signal in single-cell datasets as is described in "
                 , a("Brennecke et.al.",href="https://www.nature.com/articles/nmeth.2645")),
               p("You can select 3 methods to choose the top variable features:"),
               tags$ul(
                       tags$li("vst: First, fits a line to the relationship of log(variance) and log(mean) using local polynomial regression (loess). 
                               Then standardizes the feature values using the observed mean and expected variance (given by the fitted line).
                               Feature variance is then calculated on the standardized values after clipping to a maximum (see clip.max parameter)."),
                       tags$li("mean.var.plot (mvp): First, uses a function to calculate average expression (mean.function) and dispersion (dispersion.function) for each feature. 
                               Next, divides features into num.bin (deafult 20) bins based on their average expression, and calculates z-scores for dispersion within each bin. 
                               The purpose of this is to identify variable features while controlling for the strong relationship between variability and average expression."),
                       tags$li("dispersion (disp): selects the genes with the highest dispersion values.")),
               h4(strong("Scaling the data")),
               p("Finally, a linear transformation (‘scaling’) is applied,
                 this scaling is a standard pre-processing step prior to dimensional reduction techniques like PCA."),
               p("The scaling:"),
               tags$ul(
                       tags$li("Shifts the expression of each gene, so that the mean expression across cells is 0."),
                       tags$li("Scales the expression of each gene, so that the variance across cells is 1.
                               (This step gives equal weight in downstream analyses, so that highly-expressed genes do not dominate).")),
               column(6,
                      selectInput("selmethod", "Selection Method", choices = c("vst", "mvp", "disp"))),
               column(6,
                      numericInput("nfeatures", "Features number", value = 2000, min = 0, max = Inf))),
        column(12,  
               column(6,
                      p(strong("Validate selection")),
                      actionButton("submit_norm","Normalize / Find Var. Features / Scale Data", style = "width: 100%")),
               column(6,
                      numericInput("points", "Features to show", value = 10, min = 0, max = 200)),
               # column(6,
               #        actionButton("submit_norm","Normalize / Find Var. Features / Scale Data", style = "width: 100%")),
               # column(6,
               #        selectInput("meanFunc", "Mean Function", choices = "ExpMean")),
               # column(6,
               #        selectInput("dispFunc", "Dispersion Function", choices = "LogVMR")),
               # column(6,
               #        numericInput("XlowCutOff", "X Low Cut-off value", value = 0.0125, min = 0, max = Inf)),
               # column(6,
               #        numericInput("XhighCutOff", "X High Cut-off value", value = 3, min = 0, max = Inf)),
               # column(6,
               #        numericInput("YCutOff", "Y Cut-off value", value = 0.5, min = 0, max = Inf))
               
        ),
        # hr(),
        # column(12,
        #        h4(strong("Scaling the data and removing unwanted sources of variation")),
        #        selectInput("scale_var", "Variables to regress out", choices = "nCount_RNA", multiple = FALSE)),
        hr(),
        hr(),
        fluidRow(column(12)),
        fluidRow(column(12,
               plotOutput("feature_scatter")),
               conditionalPanel("output.downloadNormalizeReactive",
                                
               column(6,wellPanel(h4(strong("Plot download options")),
                                  numericInput(inputId = "widthFS1",label = "Plot width (in cm)", value = 15,min = 1,max = 100),
                                  numericInput(inputId = "heightFS1",label = "Plot height (in cm)", value = 10,min = 1,max = 100),
                                  numericInput(inputId = "dpiFS1",label = "Plot resolution", value = 300,min = 1,max = 1000),
                                  selectInput(inputId = "deviceFS1",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png"),
                                  downloadButton("downloadFeatureScatter1", "Download"))
               ),
               column(6,wellPanel(h4(strong("Plot download options")),
                                  numericInput(inputId = "widthFS2",label = "Plot width (in cm)", value = 15,min = 1,max = 100),
                                  numericInput(inputId = "heightFS2",label = "Plot height (in cm)", value = 10,min = 1,max = 100),
                                  numericInput(inputId = "dpiFS2",label = "Plot resolution", value = 300,min = 1,max = 1000),
                                  selectInput(inputId = "deviceFS2",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png"),
                                  downloadButton("downloadFeatureScatter2", "Download"))
               )
               )),
        fluidRow(column(12,
                        uiOutput('nextStepDimRed')
                        ))
        
        )
)

