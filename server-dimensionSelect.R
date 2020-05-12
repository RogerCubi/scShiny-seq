observe({
  dimensionalityReactive()
})

dimensionalityReactive <-
  eventReactive(input$dimImput,
                ignoreNULL = FALSE, {
                  withProgress(message = "Determining the dimensionality of the dataset, please wait",{
                    print("dimensionalityReactive")
                    
                    ngsData <- pcaReactive()$ngsData
                    
                    ngsData <- JackStraw(ngsData, num.replicate = input$replicateNum)
                    ngsData <- ScoreJackStraw(ngsData, dims = 1:input$dimNum)
                    
                    # Examine and visualize PCA results a few different ways
                    plotDim <- JackStrawPlot(ngsData, dims = 1:input$dimNumGraph)
                    output$dimSelPlot <- renderPlot(plotDim)
                    
                    #Save JackStrawPlot 
                    output$downloadDimplot <- downloadHandler(
                      filename = function() {
                        paste0("JackStrawPlot.", input$deviceDim)
                      },
                      content = function(file) {
                        ggsave(file, plotDim, device = input$deviceDim, width = input$widthDim, height = input$heightDim, units = "cm", dpi = input$dpiDim)
                      }
                    )
                    
                    plotElbow <- ElbowPlot(ngsData)
                    output$elbowPlot <- renderPlot(plotElbow)
                    
                    #Save ElbowPlot 
                    output$downloadElbowPlot <- downloadHandler(
                      filename = function() {
                        paste0("ElbowPlot.", input$deviceElb)
                      },
                      content = function(file) {
                        ggsave(file, plotElbow, device = input$deviceElb, width = input$widthElb, height = input$heightElb, units = "cm", dpi = input$dpiElb)
                      }
                    )
                  })
                  output$nextStepClustering <- renderText({"Next step: Cell Clustering"})
                  return(list("ngsData"=ngsData))  
                }
  )

output$downloadDimensionsPlot <- reactive({
  
  return(!is.null(dimensionalityReactive()))
  
})
outputOptions(output, 'downloadDimensionsPlot', suspendWhenHidden=FALSE)


