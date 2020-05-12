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
                                   print("ThresholdDataReactive")
                                   ngsData <- reactiveSeuratObject()$ngsData
                                   ngsData[["percent.mt"]] <- PercentageFeatureSet(ngsData, pattern = "^MT-")
                                   
                                   # Features
                                   minThreshFeaturesA = round(min(ngsData[["nFeature_RNA"]][,1]),4)
                                   maxThreshFeaturesA = round(max(ngsData[["nFeature_RNA"]][,1]),4)
                                   minThreshFeatures = minThreshFeaturesA - 0.05*(maxThreshFeaturesA - minThreshFeaturesA)
                                   maxThreshFeatures = maxThreshFeaturesA + 0.05*(maxThreshFeaturesA - minThreshFeaturesA)
                                   
                                   #Counts
                                   minThreshCountsA = round(min(ngsData[["nCount_RNA"]][,1]),4)
                                   maxThreshCountsA = round(max(ngsData[["nCount_RNA"]][,1]),4)
                                   minThreshCounts = minThreshCountsA - 0.05*(maxThreshCountsA - minThreshCountsA)
                                   maxThreshCounts = maxThreshCountsA + 0.05*(maxThreshCountsA - minThreshCountsA)
                                   
                                   #Mitocondrial
                                   minThreshMtA = round(min(ngsData[["percent.mt"]][,1]),4)
                                   maxThreshMtA = round(max(ngsData[["percent.mt"]][,1]),4)
                                   minThreshMt = minThreshMtA - 0.05*(maxThreshMtA - minThreshMtA)
                                   maxThreshMt = maxThreshMtA + 0.05*(maxThreshMtA - minThreshMtA)
                                   
                                   
                                   output$violinFeature <- renderPlot(VlnPlot(ngsData, features = "nFeature_RNA", ncol = 1,cols= "red",group.by = "orig.ident") %>%
                                                                        + ggtitle("Number of features per cell") %>%
                                                                        + geom_hline(yintercept = input$featureThreshold[1],color = 'blue',linetype = "dashed", size = 1) %>%
                                                                        + geom_text(x=1,y=input$featureThreshold[1], label="low.threshold", vjust=2, hjust=0,color = "blue",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
                                                                        + geom_hline(yintercept = input$featureThreshold[2],color = 'red',linetype = "dashed", size = 1) %>%
                                                                        + geom_text(x=1,y=input$featureThreshold[2], label="high.threshold", vjust=-1, hjust=0, color = "red",size = 5,fontface = "bold", alpha = 0.5, family=c("serif", "mono")[2]) %>%
                                                                        + scale_y_continuous(limits=c(minThreshFeatures - 0.1*(maxThreshFeatures - minThreshFeatures),maxThreshFeatures + 0.1*(maxThreshFeatures - minThreshFeatures)))

                                                                      )
                                   output$downloadFeatureThreshold <- downloadHandler(
                                     filename = function() {
                                       paste0("thresholdFeatures.", input$deviceF)
                                     },
                                     content = function(file) {
                                       ggsave(file, plot= VlnPlot(ngsData, features = "nFeature_RNA", ncol = 1,cols= "red",group.by = "orig.ident") %>%
                                                + ggtitle("Number of features per cell") %>%
                                                + geom_hline(yintercept = input$featureThreshold[1],color = 'blue',linetype = "dashed", size = 1) %>%
                                                + geom_text(x=1,y=input$featureThreshold[1], label="low.threshold", vjust=2, hjust=0,color = "blue",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
                                                + geom_hline(yintercept = input$featureThreshold[2],color = 'red',linetype = "dashed", size = 1) %>%
                                                + geom_text(x=1,y=input$featureThreshold[2], label="high.threshold", vjust=-1, hjust=0, color = "red",size = 5,fontface = "bold", alpha = 0.5, family=c("serif", "mono")[2]) %>%
                                                + scale_y_continuous(limits=c(minThreshFeatures - 0.1*(maxThreshFeatures - minThreshFeatures),maxThreshFeatures + 0.1*(maxThreshFeatures - minThreshFeatures))), device = input$deviceF, width = input$widthF, height = input$heightF, units = "cm", dpi = input$dpiF)
                                     }
                                   )

                                   
                                   output$violinCounts <- renderPlot(VlnPlot(ngsData, features = "nCount_RNA", ncol = 1,cols= "red")%>%
                                                                       + ggtitle("Number of counts per cell") %>%
                                                                       + geom_hline(yintercept = input$countsThreshold[1],color = 'blue',linetype = "dashed", size = 1) %>%
                                                                       + geom_text(x=1,y=input$countsThreshold[1], label="low.threshold", vjust=2, hjust=0,color = "blue",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
                                                                       + geom_hline(yintercept = input$countsThreshold[2],color = 'red',linetype = "dashed", size = 1) %>%
                                                                       + geom_text(x=1,y=input$countsThreshold[2], label="high.threshold", vjust=-1, hjust=0, color = "red",size = 5,fontface = "bold", alpha = 0.5, family=c("serif", "mono")[2]) %>%
                                                                       + scale_y_continuous(limits=c(minThreshCounts - 0.1*(maxThreshCounts - minThreshCounts),maxThreshCounts + 0.1*(maxThreshCounts - minThreshCounts)))
                                                                     
                                                                     )
                                   output$downloadCountsThreshold <- downloadHandler(
                                     filename = function() {
                                       paste0("thresholdCounts.", input$deviceC)
                                     },
                                     content = function(file) {
                                       ggsave(file, VlnPlot(ngsData, features = "nCount_RNA", ncol = 1,cols= "red")%>%
                                                + ggtitle("Number of counts per cell") %>%
                                                + geom_hline(yintercept = input$countsThreshold[1],color = 'blue',linetype = "dashed", size = 1) %>%
                                                + geom_text(x=1,y=input$countsThreshold[1], label="low.threshold", vjust=2, hjust=0,color = "blue",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
                                                + geom_hline(yintercept = input$countsThreshold[2],color = 'red',linetype = "dashed", size = 1) %>%
                                                + geom_text(x=1,y=input$countsThreshold[2], label="high.threshold", vjust=-1, hjust=0, color = "red",size = 5,fontface = "bold", alpha = 0.5, family=c("serif", "mono")[2]) %>%
                                                + scale_y_continuous(limits=c(minThreshCounts - 0.1*(maxThreshCounts - minThreshCounts),maxThreshCounts + 0.1*(maxThreshCounts - minThreshCounts))), device = input$deviceC, width = input$widthC, height = input$heightC, units = "cm", dpi = input$dpiC)
                                     }
                                   )
                                   
                                   output$violinMito <- renderPlot(VlnPlot(ngsData, features = "percent.mt", ncol = 1,cols= "red")%>%
                                                                     + ggtitle("% Mitocondrial counts") %>%
                                                                     + geom_hline(yintercept = input$mitocondrialThreshold[1],color = 'red',linetype = "dashed", size = 1) %>%
                                                                     + geom_text(x=1,y=input$mitocondrialThreshold, label="high.threshold", vjust=-1, hjust=0,color = "red",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
                                                                     + scale_y_continuous(limits=c(minThreshMt - 0.1*(maxThreshMt - minThreshMt),maxThreshMt + 0.5*(maxThreshMt - minThreshMt)))
                                   )
                                   
                                   output$downloadMitoThreshold <- downloadHandler(
                                     filename = function() {
                                       paste0("thresholdCounts.", input$deviceM)
                                     },
                                     content = function(file) {
                                       ggsave(file, VlnPlot(ngsData, features = "percent.mt", ncol = 1,cols= "red")%>%
                                                + ggtitle("% Mitocondrial counts") %>%
                                                + geom_hline(yintercept = input$mitocondrialThreshold[1],color = 'red',linetype = "dashed", size = 1) %>%
                                                + geom_text(x=1,y=input$mitocondrialThreshold, label="high.threshold", vjust=-1, hjust=0,color = "red",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
                                                + scale_y_continuous(limits=c(minThreshMt - 0.1*(maxThreshMt - minThreshMt),maxThreshMt + 0.5*(maxThreshMt - minThreshMt))), device = input$deviceM, width = input$widthM, height = input$heightM, units = "cm", dpi = input$dpiM)
                                     }
                                   )
                                   
                                   # Text Output Feature
                                   output$numberCellsFeature <- renderText({
                                     
                                     featureData <- FetchData(object = ngsData, vars = "nFeature_RNA")
                                     featureSeuratThreshold = ngsData[, which(x = featureData >  input$featureThreshold[1] & featureData < input$featureThreshold[2])]
                                     featureDataThreshold <- FetchData(object = featureSeuratThreshold, vars = "nFeature_RNA")
                                       
                                     paste0("Selected ",nrow(featureDataThreshold), " cells of a total of ", nrow(featureData))
                                     })
                                   
                                   # Text Output Counts
                                   output$numberCellsCounts <- renderText({
                                     
                                     countsData <- FetchData(object = ngsData, vars = "nCount_RNA")
                                     countsSeuratThreshold = ngsData[, which(x = countsData >  input$countsThreshold[1] & countsData < input$countsThreshold[2])]
                                     countsDataThreshold <- FetchData(object = countsSeuratThreshold, vars = "nCount_RNA")
                                     
                                     paste0("Selected ",nrow(countsDataThreshold), " cells of a total of ", nrow(countsData))
                                     })
                                   
                                   # Text Output Mitocondrial
                                   output$numberCellsMito <- renderText({
                                     
                                     mitoData <- FetchData(object = ngsData, vars = "percent.mt")
                                     mitoSeuratThreshold = ngsData[, which(x =  mitoData < input$mitocondrialThreshold[1])]
                                     mitoDataThreshold <- FetchData(object = mitoSeuratThreshold, vars = "percent.mt")
                                     
                                     paste0("Selected ",nrow(mitoDataThreshold), " cells of a total of ", nrow(mitoData))
                                   })
                                   
                                   plot1 <- FeatureScatter(ngsData, feature1 = "nCount_RNA", feature2 = "percent.mt",cols= "red")%>%
                                     + ggtitle("% Mitocondrial vs Counts")
                                   plot2 <- FeatureScatter(ngsData, feature1 = "nCount_RNA", feature2 = "nFeature_RNA",cols= "red")%>%
                                     + ggtitle("Number of features vs Counts")
                                   output$qc_scatter <- renderPlot(plot1 + plot2)
                                   
                                   output$downloadScatter <- downloadHandler(
                                     filename = function() {
                                       paste0("ScatterPlot.", input$deviceS)
                                     },
                                     content = function(file) {
                                       ggsave(file, (plot1 + plot2), device = input$deviceS, width = input$widthS, height = input$heightS, units = "cm", dpi = input$dpiS)
                                     }
                                   )
                                   
                                   # Text Output all
                                   output$numberCellsThreshold <- renderText({
                                     
                                     featureData <- FetchData(object = ngsData, vars = "nFeature_RNA")
                                     countsData <- FetchData(object = ngsData, vars = "nCount_RNA")
                                     mitoData <- FetchData(object = ngsData, vars = "percent.mt")

                                     allSeuratThreshold = ngsData[, which(x = featureData >  input$featureThreshold[1] & featureData < input$featureThreshold[2] &
                                                                            countsData >  input$countsThreshold[1] & countsData < input$countsThreshold[2] & 
                                                                            mitoData < input$mitocondrialThreshold[1])]
                                     allDataThreshold <- FetchData(object = allSeuratThreshold, vars = "nFeature_RNA")
                                     
                                     paste0("Overall threshold selection returns ",nrow(allDataThreshold), " cells of a total of ", nrow(featureData))
                                   })
                                   return(list('ngsData'=ngsData))
                                 }
                                 }
                               ) # ThresholdDataReactive


observe({
  analyzeThresholdReactive()
})
analyzeThresholdReactive <-
  eventReactive(input$submit_threshold,
                ignoreNULL = TRUE, {
                  print("analyzeThresholdReactive")
                  if (!is.null(reactiveSeuratObject()$ngsData)){
                  
                    ngsData <- ThresholdDataReactive()$ngsData
                    ngsData <- subset(ngsData, subset = nFeature_RNA > input$featureThreshold[1] & nFeature_RNA < input$featureThreshold[2] &
                                      nCount_RNA > input$countsThreshold[1] & nCount_RNA < input$countsThreshold[2] &
                                      percent.mt < input$mitocondrialThreshold)
                  print("done")
                  output$nextStepNormalization <- renderText({"Next step: Normalization"})
                  return(list('ngsData'=ngsData)) }
                }
  )


# plotThreshold <- reactive()
# plotThreshold$feature_RNA <- (VlnPlot(ngsData, features = "nFeature_RNA", ncol = 1,cols= "red",group.by = "orig.ident") %>%
#                                 + geom_hline(yintercept = input$featureThreshold[1],color = 'blue',linetype = "dashed", size = 1) %>%
#                                 + geom_text(x=1,y=input$featureThreshold[1], label="low.threshold", vjust=2, hjust=0,color = "blue",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
#                                 + geom_hline(yintercept = input$featureThreshold[2],color = 'red',linetype = "dashed", size = 1) %>%
#                                 + geom_text(x=1,y=input$featureThreshold[2], label="high.threshold", vjust=-1, hjust=0, color = "red",size = 5,fontface = "bold", alpha = 0.5, family=c("serif", "mono")[2]) %>%
#                                 + scale_y_continuous(limits=c(minThreshFeatures - 0.1*(maxThreshFeatures - minThreshFeatures),maxThreshFeatures + 0.1*(maxThreshFeatures - minThreshFeatures)))
#                               
# )
# output$violinFeature <- renderPlot(plotThreshold()$feature_RNA)
# # Downloadable csv of selected dataset ----
# output$downloadFeatureThreshold <- downloadHandler(
#   filename = function() {
#     paste("input$violinFeature", input$device, sep = "")
#   },
#   content = function(file) {
#     ggsave(file, plot= plotThreshold()$feature_RNA)
#   }
# )
# 
