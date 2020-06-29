observe({
  normalizeReactive()
  
  if (!is.null(analyzeThresholdReactive()$ngsData)){
    ngsData <- analyzeThresholdReactive()$ngsData
    
    updateNumericInput(session,inputId = "nfeatures", max = length(rownames(ngsData)) )

  }
})

normalizeReactive <-
  eventReactive(input$submit_norm,
                ignoreNULL = FALSE, {
                  withProgress(message = "Normalizing and scaling data, please wait",{
                    print("normalizeReactive")
                    
                    ngsData <- analyzeThresholdReactive()$ngsData
                    
                    shiny::setProgress(value = 0.3, detail = " Normalizing ...")
                    

                    ngsData <- NormalizeData(ngsData, normalization.method = input$normalization, scale.factor = input$scale)
                    
                    shiny::setProgress(value = 0.5, detail = " Identifying highly variable features ...")
                    
                    ngsData <- FindVariableFeatures(ngsData, selection.method = input$selmethod, nfeatures = input$nfeatures)
                    
                    # shiny::setProgress(value = 0.8, detail = " Scaling the data ...")
                    # 
                    # all.genes <- rownames(pbmc)
                    # pbmc <- ScaleData(pbmc, features = all.genes)
                    print("Job done")
                    
                    # Identify the x most highly variable genes
                    topX <- head(VariableFeatures(ngsData), input$points)
                    plot1 <- VariableFeaturePlot(ngsData)
                    plot2 <- LabelPoints(plot = plot1, points = topX, repel = TRUE)
                    output$feature_scatter <- renderPlot(plot1 + plot2)
                    #Save plot1
                    output$downloadFeatureScatter1 <- downloadHandler(
                      filename = function() {
                        paste0("ScatterPlotNormalization.", input$deviceFS1)
                      },
                      content = function(file) {
                        ggsave(file, plot1, device = input$deviceFS1, width = input$widthFS1, height = input$heightFS1, units = "cm", dpi = input$dpiFS1)
                      }
                    )
                    #Save plot2
                    output$downloadFeatureScatter2 <- downloadHandler(
                      filename = function() {
                        paste0("ScatterPlotNormalization.", input$deviceFS2)
                      },
                      content = function(file) {
                        ggsave(file, plot2, device = input$deviceFS2, width = input$widthFS2, height = input$heightFS2, units = "cm", dpi = input$dpiFS2)
                      }
                    )
                    
                    #Scaling the data
                    shiny::setProgress(value = 0.8, detail = " Scaling data ...")
                    all.genes <- rownames(ngsData)
                    ngsData <- ScaleData(ngsData, features = all.genes)
                    ## output$nextStepDimRed <- renderText({"Next step: Linear dimensional reduction"})
                    output$nextStepDimRed <- renderUI({
                        actionButton("done_norm",
                                     "Next step: Linear dimensional reduction")
                    })
                    
                    return(list('ngsData'=ngsData))                      
                  })})

output$downloadNormalizeReactive <- reactive({
  
  return(!is.null(normalizeReactive()))
  
})
outputOptions(output, 'downloadNormalizeReactive', suspendWhenHidden=FALSE)


