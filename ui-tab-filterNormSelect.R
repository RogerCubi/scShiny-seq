tabItem(tabName = "filterNormSelectTab",

        fluidRow(column(
          12,
          h3(strong("Normalize, Select Var. Features, Scale Data")),
        ),
        hr(),
        column(12,
               h4(strong("Data Normalization")),
               column(6,
                      selectInput("normalization", "Normalization Method", choices = "LogNormalize")
                      ),
               column(6,
                      numericInput("scale", "Scale Factor", value = 1000, min = 1, max = Inf))
               ),
        hr(),
        column(12,
               h4(strong("Detection of variable genes across the single cells")),
               column(6,
                      selectInput("selmethod", "Selection Method", choices = "vst")),
               column(6,
                      numericInput("nfeatures", "Features number", value = 2000, min = 0, max = Inf))
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
        column(12,
               actionButton("submit_norm","Normalize / Find Var. Features / Scale Data", style = "width: 100%"))
        
        )
)

