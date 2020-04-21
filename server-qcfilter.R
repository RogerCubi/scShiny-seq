
observe({
  analyzeDataReactive()
})

analyzeDataReactive <-
  eventReactive(input$submit_data,
                ignoreNULL = FALSE, {
                  withProgress(message = "Analyzing Single Cell data, please wait",{
                    print("analysisCountDataReactive")
                    
                    pbmc <- initSeuratObjReactive()$pbmc
                
                    shiny::setProgress(value = 0.3, detail = " Applying Filters ...")
                    
                    #######
                    pbmcRawData <- GetAssayData(object = pbmc, slot = "counts")
                    
                    if(input$mitoFilter == TRUE)
                    {
                      pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")
                      output$qc_violin <- renderPlot(VlnPlot(pbmc, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3,cols= "red"))
                      plot1 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "percent.mt",cols= "red")
                      plot2 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "nFeature_RNA",cols= "red")
                      output$qc_scatter <- renderPlot(plot1 + plot2)
                    }
                    else{
                      output$qc_violin <- renderPlot(VlnPlot(pbmc, features = c("nFeature_RNA", "nCount_RNA"), ncol = 2,cols= "red"))
                      output$qc_scatter <- renderPlot(FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "nFeature_RNA",cols= "red"))
                    }

                   return(list('pbmc'=pbmc))                      
                  })})


minThresh <- reactive({
  input$minThreshold
})
maxThresh <- reactive({
  input$maxThreshold
})
maxMito <- reactive({
  input$maxMito
})

observe({
  analyzeThresholdReactive()
  minThresh
  maxThresh
  maxMito
})
analyzeThresholdReactive <-
  eventReactive(input$submit_threshold,
                ignoreNULL = FALSE, {
                  withProgress(message = "Threshold selected",{
                    print("Threshold_selected")
                    
                    pbmc <- initSeuratObjReactive()$pbmc
                    pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")
                    
                    #######
                    #pbmcRawData <- GetAssayData(object = pbmc, slot = "counts")
                    
                    if(input$mitoFilter == TRUE)
                    {
                      pbmc <- subset(pbmc, subset = nFeature_RNA > minThresh & nFeature_RNA < maxThresh & percent.mt < maxMito)
                    }
                    else{
                      pbmc <- subset(pbmc, subset = nFeature_RNA > minThresh & nFeature_RNA < maxThresh)
                    }
                    print("done")
                    return(list('pbmc'=pbmc)) 
                  })})
                     