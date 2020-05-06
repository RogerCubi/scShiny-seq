


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