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
                    output$dimSelPlot <- renderPlot(JackStrawPlot(ngsData, dims = 1:input$dimNumGraph))
                    output$elbowPlot <- renderPlot(ElbowPlot(ngsData))
                  })
                  
                  return(list("ngsData"=ngsData))  
                }
  )

