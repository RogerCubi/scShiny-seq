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
                    
                    ngsData <- normalizeReactive()$ngsData
                    
                    ngsData <- RunPCA(ngsData, features = VariableFeatures(object = ngsData))
                    
                    # Examine and visualize PCA results a few different ways
                    output$renderprint <- renderPrint({print(ngsData[["pca"]], dims = 1:input$PCs_to_Show, nfeatures = input$genes_to_Show)})
                  })
                  
                  return(list("ngsData"=ngsData))  
                }
  )