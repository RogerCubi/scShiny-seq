
# Load the PBMC dataset

# if (is.null(reactiveInputData())){
#   output$infotable <- renderText("Please, load your own 10X files or select the PBMC dataset")
# }

observe({
  reactiveInputData()
})

# Reactive object storing the seurat object with the data
reactiveInputData <- reactive({
    
  # The input of files selected
  infile <- input$loadfiles
  
  if (input$datatype == "uploadNonUmi" & !is.null(infile)){

    infile = infile$datapath

    seqdata <- read.csv(infile[1], header=TRUE, sep=",", row.names = 1)

    if(ncol(seqdata) < 2) { # if file appears not to work as csv try tsv
      seqdata <- read.csv(infile[1], header=TRUE, sep="\t", row.names = 1)
      print('changed to tsv, uploaded seqdata')

    return(list('data'=seqdata))
    }
  }
  
  # if own data is selected and I already selected the files
  if (input$datatype == "10xdata" & !is.null(infile)){
    
    # condition to execute the if conditional, if not, write the message and stop the conditional
    shiny:: validate(
      need(dim(infile)[1] == 3,
           message = "You need 3 files, 1 .mtx and 2 .tsv")
      )
    
    #dirname() function gets the directory name of a file.
    filesdir = dirname(infile[1,4]) # Column 4 = datapath of fileInput
    
    file.rename(infile$datapath[1],paste0(filesdir,'/',infile$name[1]))
    file.rename(infile$datapath[2],paste0(filesdir,'/',infile$name[2]))
    file.rename(infile$datapath[3],paste0(filesdir,'/',infile$name[3]))
    
      
      # cellranger < 3.0
      if(any(list.files(filesdir) == "genes.tsv.gz"))
      {
        file.rename(file.path(filesdir,"genes.tsv.gz"), file.path(filesdir,"features.tsv.gz"))
      }
    ngs.data <- Read10X(data.dir = filesdir)
    return(list('data'=ngs.data))
  }
  
  else if (input$datatype == "pbmcdata"){
    ngs.data <- Read10X(data.dir = "www/hg19/")
    return(list('data'=ngs.data))
    }

})


output$loadData = DT::renderDataTable({
  tmp <- reactiveInputData()
  
  if (!is.null(tmp)){
    if(ncol(tmp$data) > 20)
      return(as.matrix(tmp$data[,1:20]))
    
    return(as.matrix(tmp$data))
  }
},
options = list(scrollX = TRUE))



output$fileUploaded <- reactive({
  
  return(!is.null(reactiveInputData()))
  
})
outputOptions(output, 'fileUploaded', suspendWhenHidden=FALSE)


output$tableInfo <- renderText({
  tmp <- reactiveInputData()
  
  if (!is.null(tmp)){
      line1 <- paste("Number of genes: ", nrow(tmp$data))
      line2 <- paste("Number of cells: ", ncol(tmp$data))
      paste(line1, line2, sep="\n")
     }
  })

output$tableInfoLenght <- renderText({
  tmp <- reactiveInputData()
  
  if (!is.null(reactiveInputData()$data)){
    if (ncol(tmp$data) > 20){
      paste0("Note: data contains ", ncol(tmp$data), " columns, only the first 20 will show here.")
    }
    else{
      paste0("Note: data contains ", ncol(tmp$data), " columns.")
    }
  }
})
# Initialize the Seurat object with the raw (non-normalized data).
observe({
  reactiveSeuratObject()
})

# Reactive expression that starts when reactive upload_data changes
reactiveSeuratObject <- eventReactive(input$upload_data,
                                 ignoreNULL = TRUE,
                                 {
                                   withProgress(message = "Initializing Seurat Object, please wait",{
                                     rawData =  reactiveInputData()$data
                                     ngsData <- CreateSeuratObject(counts = rawData, min.cells = input$mincells,
                                                                   min.features = input$mingenes,project = input$projectname)
                                     #names.delim = "\\-", names.field = 2
                                     shiny::setProgress(value = 0.8, detail = "Done.")
                                     print(ngsData)
                                     
                                     output$nextStep1 <- renderUI({
                                         actionButton("done_input_data", "Next step: QC & Filter")
                                     })
                                     return(list("ngsData"=ngsData))
                                   })
                                 }
                                 )
