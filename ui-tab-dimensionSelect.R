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
              plotOutput("elbowPlot"),
              conditionalPanel("output.downloadDimensionsPlot",
                               h4(strong("Plot download options")),
                               column(6,numericInput(inputId = "widthElb",label = "Plot width (in cm)", value = 15,min = 1,max = 100)),
                               column(6,numericInput(inputId = "heightElb",label = "Plot height (in cm)", value = 10,min = 1,max = 100)),
                               column(6,numericInput(inputId = "dpiElb",label = "Plot resolution", value = 300,min = 1,max = 1000)),
                               column(6,selectInput(inputId = "deviceElb",label = "File type",choices = c("png","pdf","jpeg", "tiff", "bmp", "svg"), selected = "png")),
                               downloadButton("downloadElbowPlot", "Download")
              ) # ConditionalPanel
            )# mainPanel
          )
        )
)







