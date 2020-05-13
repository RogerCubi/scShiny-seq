observe({
  clusteringReactive()
})

clusteringReactive <-
  eventReactive(input$clusteringSelect,
                ignoreNULL = TRUE, {
                  withProgress(message = "Performing the dataset Clustering, please wait",{
                    print("clusteringReactive")
                    
                    ngsData <- dimensionalityReactive()$ngsData
                    
                    ngsData <- FindNeighbors(ngsData, dims = 1:input$dimNumClustering)
                    ngsData <- FindClusters(ngsData, resolution = input$dimResolution)
                  })
                  withProgress(message = "Running non-linear dimensional reduction (UMAP/tSNE), please wait",{

                    ngsData <- RunUMAP(ngsData, dims = 1:input$dimNumClustering)
                    ngsData <- RunTSNE(ngsData, dims = 1:input$dimNumClustering, method = "FIt-SNE")

                    # # Examine and visualize PCA results a few different ways
                    # 
                    # if (input$reductTech == "umap"){
                    #   plotUmapTsne <- DimPlot(ngsData, reduction = input$reductTech)
                    # }
                    # else{
                    #   plotUmapTsne <- DimPlot(ngsData, reduction = input$reductTech)
                    # }
                    # output$tsneUmapPlot <- renderPlot(plotUmapTsne)
                    # 
                    # #Save ElbowPlot 
                    # output$downloadUmapPlot <- downloadHandler(
                    #   filename = function() {
                    #     paste0(input$reductTech,".", input$deviceUmap)
                    #   },
                    #   content = function(file) {
                    #     ggsave(file, plotUmapTsne, device = input$deviceUmap, width = input$widthUmap, height = input$heightUmap, units = "cm", dpi = input$dpiUmap)
                    #   }
                    # )

                  })
                  output$nextStepSaveOrDE <- renderText({"Next step: Save the analysis file or continue to the differentially expressed genes"})
                  return(list("ngsData"=ngsData))  
                }
  )


observe(
  clusteringPlot()
)

clusteringPlot <- reactive({
  
  ngsDataPlot <- clusteringReactive()$ngsData
  # Examine and visualize PCA results a few different ways
  
if (!is.null(ngsDataPlot)){
  if (input$reductTech == "umap"){
    plotUmapTsne <- DimPlot(ngsDataPlot, reduction = input$reductTech)
    output$tsneUmapPlot <- renderPlot(plotUmapTsne)
  }
  else if (input$reductTech == "tsne"){
    plotUmapTsne <- DimPlot(ngsDataPlot, reduction = input$reductTech)
    output$tsneUmapPlot <- renderPlot(plotUmapTsne)
  }
  
  
  #Save ElbowPlot 
  output$downloadUmapPlot <- downloadHandler(
    filename = function() {
      paste0(input$reductTech,".", input$deviceUmap)
    },
    content = function(file) {
      ggsave(file, plotUmapTsne, device = input$deviceUmap, width = input$widthUmap, height = input$heightUmap, units = "cm", dpi = input$dpiUmap)
    }
  )
}}
)

output$downloadClusteringPlot <- reactive({
  
  return(!is.null(clusteringReactive()))
  
})
outputOptions(output, 'downloadClusteringPlot', suspendWhenHidden=FALSE)







