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
                      plot1 <- VizDimLoadings(ngsData, dims = 1:input$vizdims, reduction = "pca")
                      output$dimRedPlot <- renderPlot(plot1)
                      #Save plot1
                      output$downloadVizDimReduction <- downloadHandler(
                        filename = function() {
                          paste0("VizDimLoadings.", input$deviceViz)
                        },
                        content = function(file) {
                          ggsave(file, plot1, device = input$deviceViz, width = input$widthViz, height = input$heightViz, units = "cm", dpi = input$dpiViz)
                        }
                      )
                    }
                    else if (input$visualizePCA == "DimPlot"){
                      plot2 <- DimPlot(ngsData, reduction = "pca")
                      output$dimRedPlot <- renderPlot(plot2)
                      #Save plot2
                      output$downloadPCAplot <- downloadHandler(
                        filename = function() {
                          paste0("PCA.", input$devicePCA)
                        },
                        content = function(file) {
                          ggsave(file, plot2, device = input$devicePCA, width = input$widthPCA, height = input$heightPCA, units = "cm", dpi = input$dpiPCA)
                        }
                      )
                    }
                    else if (input$visualizePCA == "DimHeatmap"){
                      # plot3 <- DimHeatmap(ngsData, dims = 1:input$heatdims, cells = input$cellNumber, balanced = TRUE)
                      output$dimRedPlot <- renderPlot(DimHeatmap(ngsData, dims = 1:input$heatdims, cells = input$cellNumber, balanced = TRUE))
                      #Save plot3
                      output$downloadDimHeatmap <- downloadHandler(
                        filename = function() {
                          paste0("DimHeatmap.", input$deviceHeatmap)
                        },
                        content = function(file) {
                          ggsave(file, DimHeatmap(ngsData, dims = 1:input$heatdims, cells = input$cellNumber, balanced = TRUE), device = input$deviceHeatmap, width = input$widthHeatmap, height = input$heightHeatmap, units = "cm", dpi = input$dpiHeatmap)
                        }
                      )
                    }
                  })
                  
                  #return(list("ngsData"=ngsData))  
                }
  )

output$downloadPCA <- reactive({
  
  return(!is.null(pcaPlotReactive()))
  
})
outputOptions(output, 'downloadPCA', suspendWhenHidden=FALSE)














