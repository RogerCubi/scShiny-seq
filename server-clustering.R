observe({
  clusteringReactive()
})

clusteringReactive <-
  eventReactive(input$clusteringSelect,
                ignoreNULL = TRUE, {
                  withProgress(message = "Performing the dataset Clustering, please wait",{
                    print("clusteringReactive")
                    
                    ngsData <- dimensionalityReactive()$ngsData
                    
                    ngsData <- FindNeighbors(ngsData, dims = 1:input$dimNumClustering)
                    ngsData <- FindClusters(ngsData, resolution = input$dimResolution)
                  })
                  withProgress(message = "Running non-linear dimensional reduction (UMAP/tSNE), please wait",{

                    ngsData <- RunUMAP(ngsData, dims = 1:input$dimNumClustering)

                    # Examine and visualize PCA results a few different ways
                    plotUmap <- DimPlot(ngsData, reduction = "umap")
                    output$umapPlot <- renderPlot(plotUmap)
                    
                    #Save ElbowPlot 
                    output$downloadUmapPlot <- downloadHandler(
                      filename = function() {
                        paste0("umapPlot.", input$deviceUmap)
                      },
                      content = function(file) {
                        ggsave(file, plotUmap, device = input$deviceUmap, width = input$widthUmap, height = input$heightUmap, units = "cm", dpi = input$dpiUmap)
                      }
                    )

                  })
                  output$nextStepSaveOrDE <- renderText({"Next step: Save the analysis file or continue to the differentially expressed genes"})
                  return(list("ngsData"=ngsData))  
                }
  )


output$downloadClusteringPlot <- reactive({
  
  return(!is.null(clusteringReactive()))
  
})
outputOptions(output, 'downloadClusteringPlot', suspendWhenHidden=FALSE)







