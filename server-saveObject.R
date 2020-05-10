
# Download rds of analysis

output$downloadData <- downloadHandler(
  
  filename = function() {
    paste(input$projectname, ".rds", sep = "")
  },
  content = function(file) {
    saveRDS(clusteringReactive(), file)
  }
)


observe({
  loadClusteringReactive()
})

# Load file
loadClusteringReactive <- reactive({
  withProgress(message = "Loading the analysis file, please wait",{
    print("loadObjectReactive")
    
    inFile <- input$savedAnalysis
    
    if (is.null(inFile))
      return(NULL)
    
    ngsData <- readRDS(inFile$datapath, refhook = NULL)
    
    print("Analisys loaded")
    
    if (!is.null(ngsData)){
      output$loadInfo <- renderText(expr = "File loaded succesfuly!")
      }
    return(list("ngsData"=ngsData))
  })
  }
  )