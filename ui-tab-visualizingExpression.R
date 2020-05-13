tabItem(tabName = "plotMarkerTab",
        
        fluidPage(
          tabsetPanel(
            tabPanel(title = "Violin plot",
                     selectInput(inputId = "genesToVlnPlot",label = "Select the genes to plot",choices = c(), multiple = TRUE),
                     checkboxInput(inputId = "selectLog",label = 'Use logaritmic scale',value = FALSE),
                     actionButton(inputId = "validateVlnPlot",label = "Validate selection"),
                     plotOutput("violinPlot")
            ),
            
            tabPanel(title = "Feature plot",
                     selectInput(inputId = "genesToFeaturePlot",label = "Select the genes to plot",choices = c(), multiple = TRUE),
                     actionButton(inputId = "validateFeaturePlot",label = "Validate selection"),
                     plotOutput("featurePlot")
            ),
            
            tabPanel(title = "Ridge plot",
                     selectInput(inputId = "genesToRidgePlot",label = "Select the genes to plot",choices = c(), multiple = TRUE),
                     actionButton(inputId = "validateRidgePlot",label = "Validate selection"),
                     plotOutput("ridgePlot")
                     
            )# tabPanel
          )
        )
        
        ) #tabItem 