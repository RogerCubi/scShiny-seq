observe({
  normalizeReactive()
})

normalizeReactive <-
  eventReactive(input$submit_norm,
                ignoreNULL = FALSE, {
                  withProgress(message = "Normalizing and scaling data, please wait",{
                    print("normalizeReactive")
                    
                    pbmc <- analyzeThresholdReactive()$pbmc
                    
                    shiny::setProgress(value = 0.3, detail = " Normalizing ...")
                    

                    pbmc <- NormalizeData(pbmc, normalization.method = "normalization", scale.factor = "scale")
                    
                    shiny::setProgress(value = 0.5, detail = " Identifying highly variable features ...")
                    
                    pbmc <- FindVariableFeatures(pbmc, selection.method = "selmethod", nfeatures = "nfeatures")
                    
                    # shiny::setProgress(value = 0.8, detail = " Scaling the data ...")
                    # 
                    # all.genes <- rownames(pbmc)
                    # pbmc <- ScaleData(pbmc, features = all.genes)
                    
                    return(list('pbmc'=pbmc))                      
                  })})


