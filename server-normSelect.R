observe({
  normalizeReactive()
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
                    return(list('pbmc'=ngsData))                      
                  })})


