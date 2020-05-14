
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
                    
                    violin_Plot <- VlnPlot(ngsData, features = input$genesToVlnPlot, slot = "counts", log = input$selectLog)
                    output$violinPlot <- renderPlot(violin_Plot)
                    
                    output$downloadViolinButton <- downloadHandler(
                      filename = function() {
                        paste0("VlnPlot",input$genesToVlnPlot,".",input$deviceViolinPlot)
                      },
                      content = function(file) {
                        ggsave(file, violin_Plot, device = input$deviceViolinPlot, width = input$widthViolinPlot, height = input$heightViolinPlot, units = "cm", dpi = input$dpiViolinPlot)
                      }
                    )
                    
                  })
                })


output$downloadViolinPlot <- reactive({
  
  return(!is.null(violinReactive()))
  
})
outputOptions(output, 'downloadViolinPlot', suspendWhenHidden=FALSE)

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
                    
                    if (input$reductTechFeature == "umap"){
                      output$featurePlot <- renderPlot(FeaturePlot(ngsData, features = input$genesToFeaturePlot, reduction = input$reductTechFeature))
                    }
                    else if (input$reductTechFeature == "tsne"){
                      output$featurePlot <- renderPlot(FeaturePlot(ngsData, features = input$genesToFeaturePlot, reduction = input$reductTechFeature))
                    }

                    #Downloading functions
                    output$downloadFeaturePlotButton <- downloadHandler(
                      filename = function() {
                        paste0("FeaturePlot",input$genesToFeaturePlot,".",input$deviceFeaturePlot)
                      },
                      content = function(file) {
                        ggsave(file, FeaturePlot(ngsData, features = input$genesToFeaturePlot, reduction = input$reductTechFeature), device = input$deviceFeaturePlot, width = input$widthFeaturePlot, height = input$heightFeaturePlot, units = "cm", dpi = input$dpiFeaturePlot)
                      }
                    )
                  })
                })

output$downloadFeaturePlot <- reactive({
  
  return(!is.null(featureReactive()))
  
})
outputOptions(output, 'downloadFeaturePlot', suspendWhenHidden=FALSE)

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
                    
                    ridge_plot <- RidgePlot(ngsData, features = input$genesToRidgePlot)
                    output$ridgePlot <- renderPlot(ridge_plot)
                    
                    #Downloading functions
                    output$downloadRidgePlotButton <- downloadHandler(
                      filename = function() {
                        paste0("FeaturePlot",input$genesToRidgePlot,".",input$deviceRidgePlot)
                      },
                      content = function(file) {
                        ggsave(file, ridge_plot, device = input$deviceRidgePlot, width = input$widthRidgePlot, height = input$heightRidgePlot, units = "cm", dpi = input$dpiRidgePlot)
                      }
                    )
                  })
                })

output$downloadRidgePlot <- reactive({
  
  return(!is.null(ridgeReactive()))
  
})
outputOptions(output, 'downloadRidgePlot', suspendWhenHidden=FALSE)
