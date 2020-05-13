tabItem(tabName = "clusteringTab",
        
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              # selectInput(inputId = "reductTech", label = "Dimensional reduction technique",choices = c("umap","tsne")),
              numericInput(inputId = "dimNumClustering", label =  "Number of significant dimensions", value = 10, min = 1, max = 1000, step = 1),
              numericInput(inputId = "dimResolution", label =  "Resolution or 'Granularity'", value = 0.5, min = 0.1, max = 10, step = 0.1),
              actionButton(inputId = "clusteringSelect", label = "Validate Selection"),
              tags$style("#nextStepSaveOrDE {font-size:18px;color:red;display:block;position:relative;text-align:center; }"),
              textOutput("nextStepSaveOrDE")
            ),
            mainPanel(
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