tabItem(tabName = "clusteringTab",
        
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              numericInput(inputId = "dimNumClustering", label =  "Number of significant dimensions", value = 10, min = 1, max = 1000, step = 1),
              numericInput(inputId = "dimResolution", label =  "Resolution or 'Granularity'", value = 0.5, min = 0.1, max = 10, step = 0.1),
              actionButton(inputId = "clusteringSelect", label = "Validate Selection"),
              tags$style("#nextStepSaveOrDE {font-size:18px;color:red;display:block;position:relative;text-align:center; }"),
              textOutput("nextStepSaveOrDE")
            ),
            mainPanel(
              plotOutput("umapPlot")
            )# mainPanel
          )
        ),
)