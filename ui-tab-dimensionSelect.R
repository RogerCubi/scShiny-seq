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
              hr(),
              plotOutput("elbowPlot")
            )# mainPanel
          )
        ),
)







