observe({
  pcaReactive()
})

pcaReactive <-
  eventReactive(input$pcaImput,
                ignoreNULL = FALSE, {
                  withProgress(message = "Performing linear dimensional reduction, please wait",{
                    print("pcaReactive")
                    
                    ngsData <- normalizeReactive()$ngsData
                    
                    ngsData <- RunPCA(ngsData, features = VariableFeatures(object = ngsData))
                    
                    # Examine and visualize PCA results a few different ways
                    output$renderprint <- renderPrint({print(ngsData[["pca"]], dims = 1:input$PCs_to_Show, nfeatures = input$genes_to_Show)})
                  })
                  output$nextStepDimensionality <- renderText({"Explore the PCA visualizations or go to the next step: Determine the Dimensionality"})
                  return(list("ngsData"=ngsData))  
                  }
                )


output$pcaReactive <- reactive({
  
  return(!is.null(pcaReactive()))
  
})
outputOptions(output, 'pcaReactive', suspendWhenHidden=FALSE)


observe({
  pcaPlotReactive()
})

pcaPlotReactive <-
  eventReactive(input$pcaGraphImput,
                ignoreNULL = FALSE, {
                  withProgress(message = "Generating the plot, please wait",{
                    print("pcaPlotReactive")
                    
                    ngsData <- pcaReactive()$ngsData
                    
                    if (input$visualizePCA == "VizDimReduction"){
                      output$dimRedPlot <- renderPlot(VizDimLoadings(ngsData, dims = 1:input$vizdims, reduction = "pca"))
                    }
                    else if (input$visualizePCA == "DimPlot"){
                      output$dimRedPlot <- renderPlot(DimPlot(ngsData, reduction = "pca"))
                    }
                    else if (input$visualizePCA == "DimHeatmap"){
                      output$dimRedPlot <- renderPlot(DimHeatmap(ngsData, dims = 1:input$heatdims, cells = input$cellNumber, balanced = TRUE))
                    }
                  })
                  
                  #return(list("ngsData"=ngsData))  
                }
  )