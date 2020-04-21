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
                    
                  }
                  )})
# for (i in 1:length(myValues$exprList)) {
#   
#   exprPattern = myValues$exprList[i]
#   exprName = names(myValues$exprList[i])
#   
#   pattern.genes <- grep(pattern = exprPattern, x = rownames(x = GetAssayData(object = pbmc)), value = TRUE)

#     #v3
#     if(length(pattern.genes) > 1)
#       percent.pattern <- Matrix::colSums(x = pbmcRawData[pattern.genes, ]) / Matrix::colSums(x = pbmcRawData)
#     else
#       percent.pattern <- pbmcRawData[pattern.genes, ] / Matrix::colSums(x = pbmcRawData)
#     
#     pbmc <- AddMetaData(object = pbmc, metadata = percent.pattern, col.name = paste("percent.",exprName, sep = ""))
#     
#     #v3
#     pbmc[[paste0("percent.",exprName)]] <- percent.pattern
#     
#     myValues$scriptCommands[[paste0("metadata",i)]] = paste0('pbmc[[','"percent.',exprName,'"]] <- ','PercentageFeatureSet(pbmc, pattern = "',myValues$exprList[i],'")')
#   }
# }
# 
# 
# if(length(input$filterSpecGenes) > 0)
# {
#   
#   if(length(input$filterSpecGenes) > 1)
#     percent.pattern <- Matrix::colSums(pbmcRawData[input$filterSpecGenes, ])/Matrix::colSums(pbmcRawData)
#   else
#     percent.pattern <- pbmcRawData[input$filterSpecGenes, ]/Matrix::colSums(pbmcRawData)
#   
#   pbmc <- AddMetaData(object = pbmc, metadata = percent.pattern, col.name = paste0("percent.",input$customGenesLabel))
#   
# }
# 
# if(length(input$filterPasteGenes) > 0)
# {
#   
#   if(length(input$filterPasteGenes) > 1)
#     percent.pattern <- Matrix::colSums(pbmcRawData[input$filterPasteGenes, ])/Matrix::colSums(pbmcRawData)
#   else
#     percent.pattern <- pbmcRawData[input$filterPasteGenes, ]/Matrix::colSums(pbmcRawData)
#   
#   pbmc <- AddMetaData(object = pbmc, metadata = percent.pattern, col.name = paste0("percent.",input$pasteGenesLabel))
#   