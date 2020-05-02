observe({
  analyzeDataReactive()
})

analyzeDataReactive <-
  eventReactive(input$submit_data,
                ignoreNULL = FALSE, {
                  withProgress(message = "Analyzing Single Cell data, please wait",{
                    print("analysisCountDataReactive")
                    
                    ngsData <- reactiveSeuratObject()$ngsData
                    
                    shiny::setProgress(value = 0.3, detail = " Applying Filters ...")
                    
                    #######
                    ngsRawData <- GetAssayData(object = ngsData, slot = "counts")
                    
                    if(input$mitoFilter == TRUE)
                    {
                      ngsData[["percent.mt"]] <- PercentageFeatureSet(ngsData, pattern = "^MT-")
                      output$qc_violin <- renderPlot(VlnPlot(ngsData, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3,cols= "red"))
                      plot1 <- FeatureScatter(ngsData, feature1 = "nCount_RNA", feature2 = "percent.mt",cols= "red")
                      plot2 <- FeatureScatter(ngsData, feature1 = "nCount_RNA", feature2 = "nFeature_RNA",cols= "red")
                      output$qc_scatter <- renderPlot(plot1 + plot2)
                    }
                    else{
                      output$qc_violin <- renderPlot(VlnPlot(ngsData, features = c("nFeature_RNA", "nCount_RNA"), ncol = 2,cols= "red"))
                      output$qc_scatter <- renderPlot(FeatureScatter(ngsData, feature1 = "nCount_RNA", feature2 = "nFeature_RNA",cols= "red"))
                    }
                    
                    #return(list('ngsData'=ngsData))                      
                  })})


# Threshold_val <- reactive({
#   min_thresh <- input$minThreshold
#   max_thresh <- input$maxThreshold
#   max_mito <-  input$maxMito
# })

Threshold_val1 <- reactive({input$minThreshold
})
Threshold_val2 <- reactive({input$maxThreshold
})
Threshold_val3 <- reactive({input$maxMito
})




observe({
  analyzeThresholdReactive()
})
analyzeThresholdReactive <-
  eventReactive(input$submit_threshold,
                ignoreNULL = TRUE, {
                  withProgress(message = "Threshold selected",{
                    print("Threshold_selected")
                    
                    ngsData <- reactiveSeuratObject()$ngsData
                    ngsData[["percent.mt"]] <- PercentageFeatureSet(ngsData, pattern = "^MT-")
                    shiny:: validate(
                      need(!is.null(input$minThreshold)&&!is.null(input$maxThreshold)&&!is.null(input$maxMito),
                           message = "You need 3 files, 1 .mtx and 2 .tsv")
                    )
                    #######
                    
                    min_thresh = input$minThreshold
                    max_thresh = input$maxThreshold
                    max_mito = input$maxMito
                    #pbmcRawData <- GetAssayData(object = pbmc, slot = "counts")
                    #ngsData <- subset(ngsData, subset = nFeature_RNA > min_thresh & nFeature_RNA < max_thresh & percent.mt < max_mito)
                    #ngsData <- subset(ngsData, subset = nFeature_RNA > Threshold_val1() & nFeature_RNA < Threshold_val2() & percent.mt < Threshold_val3())
                    ngsData <- subset(ngsData, subset = nFeature_RNA > 200 & nFeature_RNA < 2000 & percent.mt < 5)
                    
                    #ngsData <- subset(ngsData, subset = nFeature_RNA > input$minThreshold & nFeature_RNA < input$maxThreshold & percent.mt < input$maxMito)
                    # if(input$mitoFilter == TRUE)
                    # {
                    #   ngsData <- subset(ngsData, subset = nFeature_RNA > input$minThreshold & nFeature_RNA < input$maxThreshold & percent.mt < input$maxMito)
                    # }
                    # else{
                    #   ngsData <- subset(ngsData, subset = nFeature_RNA > input$minThreshold & nFeature_RNA < input$maxThreshold)
                    # }
                    print("done")
                    return('ngsData'=ngsData) 
                  })})
