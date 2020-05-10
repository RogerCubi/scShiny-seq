
observe({
 
  if(!is.null(clusteringReactive())){ 
    
    ngsData = clusteringReactive()$ngsData
    
    genesToPlot = rownames( GetAssayData(ngsData, slot = "scale.data") )
    updateSelectizeInput(session,'genesToVlnPlot', choices=genesToPlot)
    updateSelectizeInput(session,'genesToFeaturePlot', choices=genesToPlot)
    updateSelectizeInput(session,'genesToRidgePlot', choices=genesToPlot)
  }

})

observe({
  
  if(!is.null(loadClusteringReactive())){ 
    
    ngsData = loadClusteringReactive()$ngsData
    
    genesToPlot = rownames( GetAssayData(ngsData, slot = "scale.data") )
    updateSelectizeInput(session,'genesToVlnPlot', choices=genesToPlot)
    updateSelectizeInput(session,'genesToFeaturePlot', choices=genesToPlot)
    updateSelectizeInput(session,'genesToRidgePlot', choices=genesToPlot)
  }
  
})

observe({
  violinReactive()
})


violinReactive <-
  eventReactive(input$validateVlnPlot,
                ignoreNULL = TRUE, {
                  withProgress(message = "Preparing the Violin plot, please wait",{
                    print("DEclusterReactive")
                    
                    if(!is.null(loadClusteringReactive())){
                      ngsData <- loadClusteringReactive()$ngsData
                    }
                    else {
                      ngsData <- clusteringReactive()$ngsData
                    }
                    
                    output$violinPlot <- renderPlot(VlnPlot(ngsData, features = input$genesToVlnPlot, slot = "counts", log = input$selectLog))
                  })
                })

observe({
  featureReactive()
})


featureReactive <-
  eventReactive(input$validateFeaturePlot,
                ignoreNULL = TRUE, {
                  withProgress(message = "Performing the DE analysis, please wait",{
                    print("DEclusterReactive")
                    
                    if(!is.null(loadClusteringReactive())){
                      ngsData <- loadClusteringReactive()$ngsData
                    }
                    else {
                      ngsData <- clusteringReactive()$ngsData
                    }
                    
                    output$featurePlot <- renderPlot(FeaturePlot(ngsData, features = input$genesToFeaturePlot))
                  })
                })

observe({
  ridgeReactive()
})


ridgeReactive <-
  eventReactive(input$validateRidgePlot,
                ignoreNULL = TRUE, {
                  withProgress(message = "Performing the DE analysis, please wait",{
                    print("DEclusterReactive")
                    
                    if(!is.null(loadClusteringReactive())){
                      ngsData <- loadClusteringReactive()$ngsData
                    }
                    else {
                      ngsData <- clusteringReactive()$ngsData
                    }
                    
                    output$ridgePlot <- renderPlot(RidgePlot(ngsData, features = input$genesToRidgePlot))
                  })
                })