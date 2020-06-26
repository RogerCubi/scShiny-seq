library(SC3)

observe({
  
  if(!is.null(sc3AnalysisReactive())){ 
    
    sce = sc3AnalysisReactive()$sce
    
    consensus <- metadata(sce)$sc3$consensus
    ks <- as.numeric(names(consensus))
    
    #Consensus Matrix
    updateSliderInput(session, inputId = "clustersCM", min = min(ks), max = max(ks), value = median(ks))
    updateCheckboxGroupInput(session = session,inputId = "annotateCM",choices = names(sce@colData@listData))
    #Silhouette Plot
    updateSliderInput(session, inputId = "clustersSilhouette", min = min(ks), max = max(ks), value = median(ks))
    updateCheckboxGroupInput(session = session,inputId = "annotateSilhouette",choices = names(sce@colData@listData))
    #Expression Matrix
    updateSliderInput(session, inputId = "clustersEM", min = min(ks), max = max(ks), value = median(ks))
    updateCheckboxGroupInput(session = session,inputId = "annotateEM",choices = names(sce@colData@listData))
    #Cluster Stability
    updateSliderInput(session, inputId = "clustersCS", min = min(ks), max = max(ks), value = median(ks))
    updateCheckboxGroupInput(session = session,inputId = "annotateCS",choices = names(sce@colData@listData))
    #DE genes
    updateSliderInput(session, inputId = "clustersDEgenes", min = min(ks), max = max(ks), value = median(ks))
    updateCheckboxGroupInput(session = session,inputId = "annotateDEgenes",choices = names(sce@colData@listData))
    #Marker Genes
    updateSliderInput(session, inputId = "clustersMG", min = min(ks), max = max(ks), value = median(ks))
    updateCheckboxGroupInput(session = session,inputId = "annotateMG",choices = names(sce@colData@listData))

  }
  
})




observe({
  
  if(!is.null(clusteringReactive())){ 
    
    ngsData = clusteringReactive()$ngsData
    
  }
  
})

observe({
  
  if(!is.null(loadClusteringReactive())){ 
    
    ngsData = loadClusteringReactive()$ngsData
    
  }
  
})



observe({
  sc3Reactive()

})


sc3Reactive <-
  eventReactive(input$seuratToSce,
                ignoreNULL = TRUE, {
                  withProgress(message = "Converting Seurat object to SCE and estimating the cluster number (k), please wait",{
                    print("SC3clusterReactive")

                    if(!is.null(loadClusteringReactive())){
                      ngsData <- loadClusteringReactive()$ngsData
                    }
                    else {
                      ngsData <- clusteringReactive()$ngsData
                    }
                    
                    if (!is.null(ngsData)){

                      ngsData@active.assay <- 'RNA'
                      
                      sce <- as.SingleCellExperiment(ngsData)
                      
                      head(sce)
                      rownames(sce)
                      
                      rowData(sce)$feature_symbol <- rownames(sce)
                      sce <- sce[!duplicated(rowData(sce)$feature_symbol), ]
                      
                      counts(sce) <- as.matrix(counts(sce))
                      # normcounts(sce) <- as.matrix(normcounts(sce))
                      logcounts(sce) <- as.matrix(logcounts(sce))
                      
                      if (input$estimateK == TRUE){
                      sce <- sc3_estimate_k(sce)
                      
                      
                      output$sc3ClusterNumber <- renderText(
                        paste0("The number of clusters determined by SC3 package is: ",as.character(metadata(sce)$sc3[["k_estimation"]]))
                        )
                      }
                    print("Finished the K estimation")
                    return(list("sce"=sce))  
                    }

                  }
                  )
                  }
                )


output$sc3ReactiveDone <- reactive({
  
  return(!is.null(sc3Reactive()))
  
})
outputOptions(output, 'sc3ReactiveDone', suspendWhenHidden=FALSE)

observe({
  sc3AnalysisReactive()
  
})  

sc3AnalysisReactive <-
  eventReactive(input$sc3Analysis,
                ignoreNULL = TRUE, {
                  withProgress(message = "Performing the SC3 clustering, please wait, this can be long...",{
                  sce <- sc3Reactive()$sce
                  
                  sce <- sc3(sce, ks = input$minK:input$maxK, biology = TRUE)
                  return(list("sce"=sce)) 
                  })
                }
  )

output$sc3AnalysisDone <- reactive({
  
  return(!is.null(sc3AnalysisReactive()))
  
})
outputOptions(output, 'sc3AnalysisDone', suspendWhenHidden=FALSE)

#Consensus Matrix
observe(
  sc3PlotCMReactive()
)

sc3PlotCMReactive <- 
  eventReactive(input$runCMgenes,
                ignoreNULL = TRUE,{  
                  
                  sce  <- sc3AnalysisReactive()$sce
                  
                  # Plot DE genes
                  output$plotCMgenes <- renderPlot(
                    sc3_plot_consensus(
                      sce, k = input$clustersCM, 
                      show_pdata = input$annotateCM
                    ))
                  
                })

#Silhouette Plot
observe(
  sc3PlotSilhouetteReactive()
)

sc3PlotSilhouetteReactive <- 
  eventReactive(input$runSilhouette,
                ignoreNULL = TRUE,{  
                  
                  sce  <- sc3AnalysisReactive()$sce
                  
                  # Plot DE genes
                  output$plotSilhouette <- renderPlot(
                    sc3_plot_silhouette(
                      sce, k = input$clustersSilhouette
                    ))
                  
                })


#Expression Matrix
observe(
  sc3PlotEMReactive()
)

sc3PlotEMReactive <- 
  eventReactive(input$runEMgenes,
                ignoreNULL = TRUE,{  
                  
                  sce  <- sc3AnalysisReactive()$sce
                  
                  # Plot DE genes
                  output$plotEMgenes <- renderPlot(
                    sc3_plot_expression(
                      sce, k = input$clustersEM, 
                      show_pdata = input$annotateEM
                    ))
                  
                })

#Cluster Stability
observe(
  sc3PlotCEReactive()
)

sc3PlotCEReactive <- 
  eventReactive(input$runCEgenes,
                ignoreNULL = TRUE,{  
                  
                  sce  <- sc3AnalysisReactive()$sce
                  
                  # Plot DE genes
                  output$plotCEgenes <- renderPlot(
                    sc3_plot_cluster_stability(
                      sce, k = input$clustersCS
                    ))
                  
                })


#DE genes
observe(
  sc3PlotDEReactive()
)

sc3PlotDEReactive <- 
  eventReactive(input$runDEgenes,
                ignoreNULL = TRUE,{  
                  
                  sce  <- sc3AnalysisReactive()$sce
                  
                  # Plot DE genes
                  output$plotDEgenes <- renderPlot(
                    sc3_plot_de_genes(
                      sce, k = input$clustersDEgenes, 
                      show_pdata = input$annotateDEgenes
                    ))
                  
                })

#Marker Genes
observe(
  sc3PlotMGReactive()
)

sc3PlotMGReactive <- 
  eventReactive(input$runMarkerGenes,
                ignoreNULL = TRUE,{  
                  
                  sce  <- sc3AnalysisReactive()$sce
                  
                  # Plot Marker Genes
                  output$plotMarkerGenes <- renderPlot(
                    sc3_plot_markers(
                      sce, k = input$clustersMG, 
                      show_pdata = input$annotateMG
                    ))
                  
                })

              
