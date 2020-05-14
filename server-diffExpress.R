


observe({
  
  if(!is.null(clusteringReactive()))
  {
    ngsData = clusteringReactive()$ngsData
    
    updateSelectizeInput(session,'clusterNum',
                         choices=levels(ngsData), selected = 0)
    updateSelectizeInput(session,'clusterNum1',
                         choices=levels(ngsData), selected = 0)
    updateSelectizeInput(session,'clusterNum2',
                         choices=levels(ngsData), selected = 1)

  }
  
})

observe({
  
  if(!is.null(loadClusteringReactive()))
  {
    ngsData = loadClusteringReactive()$ngsData
    
    updateSelectizeInput(session,'clusterNum',
                         choices=levels(ngsData), selected = 0)
    updateSelectizeInput(session,'clusterNum1',
                         choices=levels(ngsData), selected = 0)
    updateSelectizeInput(session,'clusterNum2',
                         choices=levels(ngsData), selected = 1)
    
  }
  
})


observe({
  DEclusterReactive1()
})


DEclusterReactive1 <-
  eventReactive(input$allValidate,
                ignoreNULL = TRUE, {
                  withProgress(message = "Performing the DE analysis, please wait",{
                    print("DEclusterReactive")
                    
                    if(!is.null(loadClusteringReactive())){
                      ngsData <- loadClusteringReactive()$ngsData
                    }
                    else {
                      ngsData <- clusteringReactive()$ngsData
                    }
                      
                    # find markers for every cluster compared to all remaining cells
                    ngsData.markers <- FindAllMarkers(ngsData, only.pos = input$onlyPos, min.pct = input$min.pct, logfc.threshold = input$logfcThreshold,test.use = input$DEtests) 
                    #DEanalysis$ngsData.markers <- ngsData.markers
                    print("Find markers done")
                    if (input$DEtests == "roc"){
                      table1 <- (ngsData.markers  %>% group_by(cluster) %>% top_n(n = input$DEgenNumb, wt = power))
                      output$DEclusterTable <- DT::renderDataTable(table1)
                    }
                    else {
                      table1 <- (ngsData.markers  %>% group_by(cluster) %>% top_n(n = input$DEgenNumb, wt = avg_logFC))
                      output$DEclusterTable <- DT::renderDataTable(table1)
                    }
                    
                    output$downloadDEclusterTable <- downloadHandler(
                      filename = function() {
                        paste0("Clusters_DE",".csv")
                      },
                      content = function(file) {
                        write.csv(table1, file, row.names = FALSE)
                      }
                    )
                  return(list("clusters"= ngsData.markers))  
                }
                  )
                  }
  )

output$reactive1Download <- reactive({
  
  return(!is.null(DEclusterReactive1()))
  
})
outputOptions(output, 'reactive1Download', suspendWhenHidden=FALSE)

observe({
  DEclusterReactive2()
})
DEclusterReactive2 <-
  eventReactive(input$clusterValidate,
                ignoreNULL = TRUE, {
                  withProgress(message = "Performing the DE analysis, please wait",{
                    print("DEclusterReactive2")
                    
                    if(!is.null(loadClusteringReactive())){
                      ngsData <- loadClusteringReactive()$ngsData
                    }
                    else {
                      ngsData <- clusteringReactive()$ngsData
                    }
                    
                    # find markers for every cluster compared to all remaining cells
                    ngsData.markers1 <- FindMarkers(ngsData, ident.1 = input$clusterNum, only.pos = input$onlyPos1, min.pct = input$min.pct1, logfc.threshold = input$logfcThreshold1,test.use = input$DEtests1) 
                    
                    print("Find markers done")
                    if (input$DEtests1 == "roc"){
                      table2 <- (cbind(gene = rownames(ngsData.markers1),ngsData.markers1)  %>% top_n(n = input$DEgenNumb1, wt = power))
                      output$DEcluster1Table <- DT::renderDataTable(table2)
                    }
                    else {
                      table2 <-(cbind(gene = rownames(ngsData.markers1),ngsData.markers1)  %>% top_n(n = input$DEgenNumb1, wt = avg_logFC))
                      output$DEcluster1Table <- DT::renderDataTable(table2)
                    #output$DEcluster1Table <- DT::renderDataTable(head((cbind(gene = rownames(ngsData.markers1),ngsData.markers1)),input$DEgenNumb1))
                    }
                    output$downloadDEcluster1Table <- downloadHandler(
                      filename = function() {
                        paste0("Cluster_",input$clusterNum,"_DE",".csv")
                      },
                      content = function(file) {
                        write.csv(table2, file, row.names = FALSE)
                      }
                    )
                    return(list("ngsData"=ngsData))
                  })}
  )

output$reactive2Download <- reactive({
  
  return(!is.null(DEclusterReactive2()))
  
})
outputOptions(output, 'reactive2Download', suspendWhenHidden=FALSE)

observe({
DEclusterReactive3()
})
DEclusterReactive3 <-
  eventReactive(input$clusterVsClusterValidate,
                ignoreNULL = TRUE, {
                  withProgress(message = "Performing the DE analysis, please wait",{
                    print("DEclusterReactive3")
                    
                    if(!is.null(loadClusteringReactive())){
                      ngsData <- loadClusteringReactive()$ngsData
                    }
                    else {
                      ngsData <- clusteringReactive()$ngsData
                    }
                    
                    # find markers for every cluster compared to all remaining cells
                    ngsData.markers2 <- FindMarkers(ngsData, ident.1 = input$clusterNum1, ident.2 = input$clusterNum2,only.pos = input$onlyPos2, min.pct = input$min.pct2, logfc.threshold = input$logfcThreshold2,test.use = input$DEtests2) 
                    
                    print("Find markers done")
                    
                    if (input$DEtests2 == "roc"){
                      table3 <- (cbind(gene = rownames(ngsData.markers2),ngsData.markers2)  %>% top_n(n = input$DEgenNumb2, wt = power))
                      output$DEcluster2Table <- DT::renderDataTable(table3)
                    }
                    else {
                      table3 <- (cbind(gene = rownames(ngsData.markers2),ngsData.markers2)  %>% top_n(n = input$DEgenNumb2, wt = avg_logFC))
                      output$DEcluster2Table <- DT::renderDataTable(table3)
                    }
                    
                    output$downloadDEcluster2Table <- downloadHandler(
                      filename = function() {
                        paste0("Cluster_",input$clusterNum1,"Vs","cluster_",input$clusterNum2, ".csv")
                      },
                      content = function(file) {
                        write.csv(table3, file, row.names = FALSE)
                      }
                    )
                    return(list("ngsData"=ngsData))
                  })}
  )

output$reactive3Download <- reactive({
  
  return(!is.null(DEclusterReactive3()))
  
})
outputOptions(output, 'reactive3Download', suspendWhenHidden=FALSE)

#heatmap
observe({
  DEclusterReactive4()
})


DEclusterReactive4 <-
  eventReactive(input$heatmapClusterValidate,
                ignoreNULL = TRUE, {
                  
                  validate(need(DEclusterReactive1()$clusters,
                                message = "You need to find all markers for all clusters previously. this can be done in the Find all markers tab."))
                  
                  if(!is.null(loadClusteringReactive())){
                    ngsData <- loadClusteringReactive()$ngsData
                  }
                  else {
                    ngsData <- clusteringReactive()$ngsData
                  }
                  clusters <- DEclusterReactive1()$clusters
                  
                  selectedGenes <- (clusters %>% group_by(cluster) %>% top_n(n = input$DEgenNumb3, wt = avg_logFC)) 
                  
                  plotClusterHeatmap <- DoHeatmap(ngsData, features = selectedGenes$gene) %>%
                    + NoLegend()
                  
                  output$clusterHeatmap <- renderPlot({plotClusterHeatmap})
                  
                  #Save DoHeatmap 
                  output$downloadClusterHeatmap <- downloadHandler(
                    filename = function() {
                      paste0("DE_Heatmap",".", input$deviceClusterHeatmap)
                    },
                    content = function(file) {
                      ggsave(file, plotClusterHeatmap, device = input$deviceClusterHeatmap, width = input$widthClusterHeatmap, height = input$heightClusterHeatmap, units = "cm", dpi = input$dpiClusterHeatmap)
                    }
                  )
                  
                  }) 




output$downloadClusterHeatmapPlot <- reactive({
  
  return(!is.null(DEclusterReactive4()))
  
})
outputOptions(output, 'downloadClusterHeatmapPlot', suspendWhenHidden=FALSE)



