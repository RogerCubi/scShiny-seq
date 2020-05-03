tabItem(tabName = "pcaTab",
        
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              numericInput(inputId = "PCs_to_Show", label =  "Number of PCs to show", value = 6, min = 1, max = Inf, step = 1),
              numericInput(inputId = "genes_to_Show", label =  "Number of Genes to show", value = 5, min = 1, max = Inf, step = 1),
              actionButton(inputId = "pcaImput", label = "Validate Selection")
            ),
            mainPanel(
              verbatimTextOutput("renderprint")
              )# mainPanel
          )
        )
)