

inputDataReactive <- reactive({
  
  print("inputting data")
  
  inFile <- input$datafile
  
  # Check if example selected, or if not then ask to upload a file.
  shiny:: validate(
    need( !is.null(inFile) | identical(input$data_file_type, "examplecounts"),
          message = "Please select a file")
  )
  
  if(!is.null(inFile) & input$data_file_type=="upload10x")
  {
    #js$addStatusIcon()
    shiny:: validate(
      need(dim(inFile)[1] == 3,
           message = "need 3 files, 1 .mtx and 2 .tsv")
    )
    
    
    filesdir = dirname(inFile[1,4])
    
    #inFile = inFile$datapath
    

    file.rename(inFile$datapath[1],paste0(filesdir,'/',inFile$name[1]))
    file.rename(inFile$datapath[2],paste0(filesdir,'/',inFile$name[2]))
    file.rename(inFile$datapath[3],paste0(filesdir,'/',inFile$name[3]))

    shiny::withProgress(message = "Reading 10X data, please wait ...",{
      
      # cellranger < 3.0
      if(any(list.files(filesdir) == "genes.tsv.gz"))
      {
        file.rename(file.path(filesdir,"genes.tsv.gz"), file.path(filesdir,"features.tsv.gz"))
      }
      
      shiny::setProgress(value = 0.8)
      
      pbmc.data <- Read10X(data.dir = filesdir)
      
      # scriptCommands$readCounts = paste0('counts.data <- Read10X(data.dir = "/path/to/10x/dir/")')
      # isolate({
      #   myValues$scriptCommands = scriptCommands
      # })
      
    })
    
    #js$collapse("uploadbox")
    return(list('data'=pbmc.data))
  } #From the upload10X
  
  else if(!is.null(inFile) & input$data_file_type=="uploadNonUmi")
  {
    #js$addStatusIcon("datainput","loading")
    
    inFile = inFile$datapath
    
    seqdata <- read.csv(inFile[1], header=TRUE, sep=",", row.names = 1)
    
    # scriptCommands$readCounts = paste0('counts.data <- read.csv("/path/to/csv/counts/file.csv", header=TRUE, sep=",", row.names = 1)')
    
    print('uploaded seqdata')
    if(ncol(seqdata) < 2) { # if file appears not to work as csv try tsv
      seqdata <- read.csv(inFile[1], header=TRUE, sep="\t", row.names = 1)
      
      # scriptCommands$readCounts = paste0('counts.data <- read.csv("/path/to/csv/counts/file.csv", header=TRUE, sep="\\t", row.names = 1)')
      
      print('changed to tsv, uploaded seqdata')
    }
    
    # isolate({
    #   myValues$scriptCommands = scriptCommands
    # })
    
    #js$addStatusIcon("datainput","done")
    #js$collapse("uploadbox")
    return(list('data'=seqdata))
  }
  else{
    if(input$data_file_type=="examplecounts")
    {
      #js$addStatusIcon("datainput","loading")
      pbmc.data <- Read10X(data.dir = "www/hg19/")
      
      # isolate({
      #   myValues$scriptCommands$readCounts = paste0('counts.data <- Read10X(data.dir = "/path/to/10x/dir/hg19/")')
      # })
      
      #js$addStatusIcon("datainput","done")
      #js$collapse("uploadbox")
      return(list('data'=pbmc.data))
    }
    else
    return(NULL)
  }
  
  
}) #inputDataReactive

# Render the table
output$countdataDT <- renderDataTable({
  tmp <- inputDataReactive()
  
  if(!is.null(tmp))
  {
    if(ncol(tmp$data) > 20)
      return(as.matrix(tmp$data[,1:20]))
    
    return(as.matrix(tmp$data))
    
  }
  
},
options = list(scrollX = TRUE)
) # renderDataTable

output$inputInfo <- renderText({
  
  tmp <- inputDataReactive()
  
  if(!is.null(tmp))
  {
    outStr = paste0(
      paste("dense size: ", object.size(x = as.matrix(x = tmp$data))),
      '\n',
      paste("sparse size: ", object.size(x = tmp$data)))
    
  }
  
  
})


# check if a file has been uploaded and create output variable to report this
output$fileUploaded <- reactive({
  
  return(!is.null(inputDataReactive()))
  
})
outputOptions(output, 'fileUploaded', suspendWhenHidden=FALSE)

observe({
  initSeuratObjReactive()
})

initSeuratObjReactive <-
  eventReactive(input$upload_data,
                ignoreNULL = TRUE,
                {
                  withProgress(message = "Initializing Seurat Object, please wait",{
                    
                    
                    updateCollapse(session,id =  "input_collapse_panel", open="analysis_panel",
                                   style = list("analysis_panel" = "success",
                                                "data_panel"="primary"))
                    
                    rawData = inputDataReactive()$data
                    #js$addStatusIcon("datainput","loading")
                    
                    
                    pbmc <- CreateSeuratObject(counts = rawData, min.cells = input$mincells, min.features = input$mingenes,
                                               project = input$projectname, names.delim = "\\-", names.field = 2)
                    
                    # myValues$scriptCommands$createSeurat = paste0('pbmc <- CreateSeuratObject(counts = counts.data, min.cells = ',input$mincells,', min.features = ',input$mingenes,',
                    #                            project = "',input$projectname,'")')
                    
                    # if(all(is.na(Idents(pbmc)))) {
                    #   idents <- rep.int("1", times = length(Idents(pbmc)))
                    #   pbmc[['orig.ident']] <- idents
                    #   Idents(pbmc) <- "1"
                    # }
                    
                    # shiny::setProgress(value = 0.8, detail = "Done.")
                    # js$addStatusIcon("datainput","done")
                    # shinyjs::show(selector = "a[data-value=\"qcFilterTab\"]")
                    # js$addStatusIcon("qcFilterTab","next")
                    # 
                    # shinyjs::runjs("window.scrollTo(0, 0)")
                    output$qc_violin <- renderPlot(VlnPlot(pbmc, features = c("nFeature_RNA", "nCount_RNA"), ncol = 2,cols= "red"))
                    output$qc_scatter <- renderPlot(FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "nFeature_RNA",cols= "red"))
                    return(list('pbmc'=pbmc))
                  })})







