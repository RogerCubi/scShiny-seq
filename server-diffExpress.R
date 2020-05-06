


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
  DEclusterReactive1()
  # DEclusterReactive3()
})

DEclusterReactive1 <-
  eventReactive(input$allValidate,
                ignoreNULL = TRUE, {
                  withProgress(message = "Performing the DE analysis, please wait",{
                    print("DEclusterReactive")
                    
                    ngsData <- clusteringReactive()$ngsData
                    
                    # find markers for every cluster compared to all remaining cells
                    ngsData.markers <- FindAllMarkers(ngsData, only.pos = input$onlyPos, min.pct = input$min.pct, logfc.threshold = input$logfcThreshold, ,test.use = input$DEtests1) 
                    
                    print("Find markers done")
                    output$DEclusterTable <- renderTable((ngsData.markers %>% group_by(cluster) %>% top_n(n = input$DEgenNumb, wt = avg_logFC)))

                  
                  #return(list("ngsData"=ngsData))  
                })}
  )

observe({
  DEclusterReactive2()
  # DEclusterReactive3()
})
DEclusterReactive2 <-
  eventReactive(input$clusterValidate,
                ignoreNULL = TRUE, {
                  withProgress(message = "Performing the DE analysis, please wait",{
                    print("DEclusterReactive2")
                    
                    ngsData <- clusteringReactive()$ngsData
                    
                    # find markers for every cluster compared to all remaining cells
                    ngsData.markers1 <- FindMarkers(ngsData, ident.1 = input$clusterNum, only.pos = input$onlyPos1, min.pct = input$min.pct1, logfc.threshold = input$logfcThreshold1, ,test.use = input$DEtests1) 
                    
                    print("Find markers done")
                    #output$DEcluster1Table <- renderTable((cbind(gene = rownames(ngsData.markers1),ngsData.markers1)  %>% top_n(n = input$DEgenNumb1, wt = avg_logFC)))
                    output$DEcluster1Table <- renderTable(head((cbind(gene = rownames(ngsData.markers1),ngsData.markers1)),input$DEgenNumb1))
                    
                    #return(list("ngsData"=ngsData))  
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
                    
                    ngsData <- clusteringReactive()$ngsData
                    
                    # find markers for every cluster compared to all remaining cells
                    ngsData.markers2 <- FindMarkers(ngsData, ident.1 = input$clusterNum1, ident.2 = input$clusterNum2,only.pos = input$onlyPos2, min.pct = input$min.pct2, logfc.threshold = input$logfcThreshold2,test.use = input$DEtests2) 
                    
                    print("Find markers done")
                    #output$DEcluster2Table <- renderTable((cbind(gene = rownames(ngsData.markers2),ngsData.markers2)  %>% top_n(n = input$DEgenNumb2, wt = avg_logFC)))
                    output$DEcluster2Table <- renderTable(head((cbind(gene = rownames(ngsData.markers2),ngsData.markers2)),input$DEgenNumb2))
                    
                    
                    #return(list("ngsData"=ngsData))  
                  })}
  )








