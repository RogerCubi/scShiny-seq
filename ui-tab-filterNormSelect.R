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
                        tags$style("#nextStepDimRed {font-size:18px;color:red;display:block;position:relative;text-align:center; }"),
                        textOutput("nextStepDimRed")
                        ))
        
        )
)

