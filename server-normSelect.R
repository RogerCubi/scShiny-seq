observe({
  normalizeReactive()
})

normalizeReactive <-
  eventReactive(input$submit_norm,
                ignoreNULL = FALSE, {
                  withProgress(message = "Normalizing and scaling data, please wait",{
                    print("normalizeReactive")
                    
                    ngsData <- ThresholdDataReactive()$ngsData
                    
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
                    
                    #Scaling the data
                    shiny::setProgress(value = 0.8, detail = " Scaling data ...")
                    all.genes <- rownames(ngsData)
                    ngsData <- ScaleData(ngsData, features = all.genes)
                    return(list('ngsData'=ngsData))                      
                  })})



