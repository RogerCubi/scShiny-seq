observe({
  ThresholdDataReactive()
  if (!is.null(reactiveSeuratObject()$ngsData)){
    ngsData <- reactiveSeuratObject()$ngsData
    ngsData[["percent.mt"]] <- PercentageFeatureSet(ngsData, pattern = "^MT-")
    
    features <- FetchData(object = ngsData, vars = "nFeature_RNA")
    maxFeatures <- max(features)
    countsRNA <- FetchData(object = ngsData, vars = "nCount_RNA")
    maxCounts <- max(countsRNA)
    mito <- FetchData(object = ngsData, vars = "percent.mt")
    maxMito <- round(max(mito))
    
    updateSliderInput(session = session, inputId = "featureThreshold", value = c(0,maxFeatures+10), max = maxFeatures+10)
    updateSliderInput(session = session, inputId = "countsThreshold", value = c(0,maxCounts+10), max = maxCounts+10)
    updateSliderInput(session = session, inputId = "mitocondrialThreshold", value = maxMito+10, max = maxMito+5)
  }
  
})


ThresholdDataReactive <- eventReactive(input$upload_data,
                               ignoreNULL = TRUE,
                               {
                                 
                                 #ngsData <- reactiveSeuratObject()$ngsData
                                 
                                 if (!is.null(reactiveSeuratObject()$ngsData)){
                                   ngsData <- reactiveSeuratObject()$ngsData
                                   ngsData[["percent.mt"]] <- PercentageFeatureSet(ngsData, pattern = "^MT-")
                                   
                                   # Features
                                   minThreshFeaturesA = round(min(pbmc[["nFeature_RNA"]][,1]),4)
                                   maxThreshFeaturesA = round(max(pbmc[["nFeature_RNA"]][,1]),4)
                                   minThreshFeatures = minThreshFeaturesA - 0.05*(maxThreshFeaturesA - minThreshFeaturesA)
                                   maxThreshFeatures = maxThreshFeaturesA + 0.05*(maxThreshFeaturesA - minThreshFeaturesA)
                                   
                                   #Counts
                                   minThreshCountsA = round(min(pbmc[["nCount_RNA"]][,1]),4)
                                   maxThreshCountsA = round(max(pbmc[["nCount_RNA"]][,1]),4)
                                   minThreshCounts = minThreshCountsA - 0.05*(maxThreshCountsA - minThreshCountsA)
                                   maxThreshCounts = maxThreshCountsA + 0.05*(maxThreshCountsA - minThreshCountsA)
                                   
                                   #Mitocondrial
                                   minThreshMtA = round(min(pbmc[["percent.mt"]][,1]),4)
                                   maxThreshMtA = round(max(pbmc[["percent.mt"]][,1]),4)
                                   minThreshMt = minThreshMtA - 0.05*(maxThreshMtA - minThreshMtA)
                                   maxThreshMt = maxThreshMtA + 0.05*(maxThreshMtA - minThreshMtA)
                                   
                                   output$violinFeature <- renderPlot(VlnPlot(ngsData, features = "nFeature_RNA", ncol = 1,cols= "red",group.by = "orig.ident") %>%
                                                                        + geom_hline(yintercept = input$featureThreshold[1],color = 'red',linetype = "dashed", size = 1) %>%
                                                                        + geom_text(x=1,y=input$featureThreshold[1], label="low.threshold", vjust=2, hjust=0,color = "red",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
                                                                        + geom_hline(yintercept = input$featureThreshold[2],color = 'blue',linetype = "dashed", size = 1) %>%
                                                                        + geom_text(x=1,y=input$featureThreshold[2], label="high.threshold", vjust=-1, hjust=0, color = "blue",size = 5,fontface = "bold", alpha = 0.5, family=c("serif", "mono")[2]) %>%
                                                                        + scale_y_continuous(limits=c(minThreshFeatures - 0.1*(maxThreshFeatures - minThreshFeatures),maxThreshFeatures + 0.1*(maxThreshFeatures - minThreshFeatures)))
                                                                      
                                                                      )
                                   output$violinCounts <- renderPlot(VlnPlot(ngsData, features = "nCount_RNA", ncol = 1,cols= "red")%>%
                                                                       + geom_hline(yintercept = input$countsThreshold[1],color = 'red',linetype = "dashed", size = 1) %>%
                                                                       + geom_text(x=1,y=input$countsThreshold[1], label="low.threshold", vjust=2, hjust=0,color = "red",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
                                                                       + geom_hline(yintercept = input$countsThreshold[2],color = 'blue',linetype = "dashed", size = 1) %>%
                                                                       + geom_text(x=1,y=input$countsThreshold[2], label="high.threshold", vjust=-1, hjust=0, color = "blue",size = 5,fontface = "bold", alpha = 0.5, family=c("serif", "mono")[2]) %>%
                                                                       + scale_y_continuous(limits=c(minThreshCounts - 0.1*(maxThreshCounts - minThreshCounts),maxThreshCounts + 0.1*(maxThreshCounts - minThreshCounts)))
                                                                     
                                                                     )
                                   output$violinMito <- renderPlot(VlnPlot(ngsData, features = "percent.mt", ncol = 1,cols= "red")%>%
                                                                     + geom_hline(yintercept = input$mitocondrialThreshold[1],color = 'red',linetype = "dashed", size = 1) %>%
                                                                     + geom_text(x=1,y=input$mitocondrialThreshold, label="high.threshold", vjust=2, hjust=0,color = "red",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
                                                                     + scale_y_continuous(limits=c(minThreshMt - 0.1*(maxThreshMt - minThreshMt),maxThreshMt + 0.5*(maxThreshMt - minThreshMt)))
                                   )
                                 }
                                 
  
  
  
}

)








# observe({
#   analyzeDataReactive()
# })
# 
# analyzeDataReactive <-
#   eventReactive(input$submit_data,
#                 ignoreNULL = FALSE, {
#                   withProgress(message = "Analyzing Single Cell data, please wait",{
#                     print("analysisCountDataReactive")
#                     
#                     ngsData <- reactiveSeuratObject()$ngsData
#                     
#                     shiny::setProgress(value = 0.3, detail = " Applying Filters ...")
#                     
#                     #######
#                     #ngsRawData <- GetAssayData(object = ngsData, slot = "counts")
#                     
#                     if(input$mitoFilter == TRUE)
#                     {
#                       ngsData[["percent.mt"]] <- PercentageFeatureSet(ngsData, pattern = "^MT-")
#                       output$qc_violin <- renderPlot(VlnPlot(ngsData, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3,cols= "red"))
#                       plot1 <- FeatureScatter(ngsData, feature1 = "nCount_RNA", feature2 = "percent.mt",cols= "red")
#                       plot2 <- FeatureScatter(ngsData, feature1 = "nCount_RNA", feature2 = "nFeature_RNA",cols= "red")
#                       output$qc_scatter <- renderPlot(plot1 + plot2)
#                     }
#                     else{
#                       output$qc_violin <- renderPlot(VlnPlot(ngsData, features = c("nFeature_RNA", "nCount_RNA"), ncol = 2,cols= "red"))
#                       output$qc_scatter <- renderPlot(FeatureScatter(ngsData, feature1 = "nCount_RNA", feature2 = "nFeature_RNA",cols= "red"))
#                     }
#                     
#                     return(list('ngsData'=ngsData))                      
#                   })})
# 
# 
# # Threshold_val <- reactive({
# #   min_thresh <- input$minThreshold
# #   max_thresh <- input$maxThreshold
# #   max_mito <-  input$maxMito
# # })
# 
# # Threshold_val1 <- reactive({input$minThreshold
# # })
# # Threshold_val2 <- reactive({input$maxThreshold
# # })
# # Threshold_val3 <- reactive({input$maxMito
# # })
# 
# 
# 
# 
# observe({
#   analyzeThresholdReactive()
# })
# analyzeThresholdReactive <-
#   eventReactive(input$submit_threshold,
#                 ignoreNULL = TRUE, {
#                   print(input$maxThreshold)
#                   print(input$minThreshold)
#                   print(input$maxMito)
# 
#                   ngsData <- reactiveSeuratObject()$ngsData
#                   ngsData[["percent.mt"]] <- PercentageFeatureSet(ngsData, pattern = "^MT-")
#                   ngsData <- subset(ngsData, subset = nFeature_RNA > 200 & nFeature_RNA < 2000 & percent.mt < 5)
#                   # withProgress(message = "Threshold selected",{
#                   #   print("Threshold_selected")
#                   # 
#                   #   ngsData <- reactiveSeuratObject()$ngsData
#                   #   ngsData[["percent.mt"]] <- PercentageFeatureSet(ngsData, pattern = "^MT-")
#                   #   shiny:: validate(
#                   #     need(!is.null(input$minThreshold)&&!is.null(input$maxThreshold)&&!is.null(input$maxMito),
#                   #          message = "You need to add a valid number")
#                   #   )
#                   #   #######
#                   # 
#                     # min_thresh <-  input$minThreshold
#                     # max_thresh <-  input$maxThreshold
#                     # max_mito <-  input$maxMito
#                     # print(min_thresh)
#                     # print(max_thresh)
#                     # print(max_mito)
#                     #pbmcRawData <- GetAssayData(object = pbmc, slot = "counts")
#                     #ngsData <- subset(ngsData, subset = nFeature_RNA > min_thresh & nFeature_RNA < max_thresh & percent.mt < max_mito)
#                     #ngsData <- subset(ngsData, subset = nFeature_RNA > Threshold_val1() & nFeature_RNA < Threshold_val2() & percent.mt < Threshold_val3())
#                     #ngsData <- subset(ngsData, subset = nFeature_RNA > 200 & nFeature_RNA < 2000 & percent.mt < 5)
# 
#                     #ngsData <- subset(ngsData, subset = nFeature_RNA > input$minThreshold & nFeature_RNA < input$maxThreshold & percent.mt < input$maxMito)
#                     # if(input$mitoFilter == TRUE)
#                     # {
#                     #   ngsData <- subset(ngsData, subset = nFeature_RNA > input$minThreshold & nFeature_RNA < input$maxThreshold & percent.mt < input$maxMito)
#                     # }
#                     # else{
#                     #   ngsData <- subset(ngsData, subset = nFeature_RNA > input$minThreshold & nFeature_RNA < input$maxThreshold)
#                     # }
#                   print("done")
#                   return(list('ngsData'=ngsData)) 
#                   # 
#                   #   })
#                   })
