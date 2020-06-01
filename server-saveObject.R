
# Download rds of analysis

observe({
  objectClassReactive()
})

objectClassReactive <- reactive({
  
  ngsData <- clusteringReactive()$ngsData
  
  if (!is.null(ngsData)){
    
    if(input$ObjectClass=="Seurat"){
    return(list("ngsData"=ngsData))
    }
    
    else if (input$ObjectClass=="SingleCellExperiment(SCE)"){
      
    ngsData@active.assay <- 'RNA'
    ngsData <- as.SingleCellExperiment(ngsData)
    return(list("ngsData"=ngsData))
    }
  }
}
)

output$downloadData <- downloadHandler(
  
  filename = function() {
    paste(input$projectname, ".rds", sep = "")
  },
  content = function(file) {
      saveRDS(objectClassReactive()$ngsData, file)
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
    
    if(class(ngsData)=="SingleCellExperiment"){
      
      ngsData <- as.Seurat(ngsData, counts = "counts", data = "logcounts",assay = "RNA")
    }
    
    print("Analisys loaded")
    
    if (!is.null(ngsData)){
      output$loadInfo <- renderText(expr = "File loaded succesfuly!")
      }
    return(list("ngsData"=ngsData))
  })
  }
  )