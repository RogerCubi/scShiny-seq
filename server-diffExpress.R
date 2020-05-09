


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
                      output$DEclusterTable <- DT::renderDataTable((ngsData.markers  %>% group_by(cluster) %>% top_n(n = input$DEgenNumb, wt = power)))
                    }
                    else {
                      output$DEclusterTable <- DT::renderDataTable((ngsData.markers  %>% group_by(cluster) %>% top_n(n = input$DEgenNumb, wt = avg_logFC)))
                    }
                  return(list("clusters"= ngsData.markers))  
                }
                  )
                  }
  )

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
                      output$DEcluster1Table <- DT::renderDataTable((cbind(gene = rownames(ngsData.markers1),ngsData.markers1)  %>% top_n(n = input$DEgenNumb1, wt = power)))
                    }
                    else {
                    output$DEcluster1Table <- DT::renderDataTable((cbind(gene = rownames(ngsData.markers1),ngsData.markers1)  %>% top_n(n = input$DEgenNumb1, wt = avg_logFC)))
                    #output$DEcluster1Table <- DT::renderDataTable(head((cbind(gene = rownames(ngsData.markers1),ngsData.markers1)),input$DEgenNumb1))
                    }
                  })}
  )

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
                      output$DEcluster2Table <- DT::renderDataTable((cbind(gene = rownames(ngsData.markers2),ngsData.markers2)  %>% top_n(n = input$DEgenNumb2, wt = power)))
                    }
                    else {
                      output$DEcluster2Table <- DT::renderDataTable((cbind(gene = rownames(ngsData.markers2),ngsData.markers2)  %>% top_n(n = input$DEgenNumb2, wt = avg_logFC)))
                    }
                  })}
  )

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
                  
                  output$clusterHeatmap <- renderPlot({DoHeatmap(ngsData, features = selectedGenes$gene) + NoLegend()})
                  
                  }) 








