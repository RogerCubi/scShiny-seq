# Select folder
shinyDirChoose(
  input,
  'dir',
  roots = c(home = '~'),
  filetypes = c('', 'txt', 'bigWig', "tsv", "csv", "bw")
)

global <- reactiveValues(datapath = getwd())

dir <- reactive(input$dir)

output$dir <- renderText({
  global$datapath
})

observeEvent(ignoreNULL = TRUE,
             eventExpr = {
               input$dir
             },
             handlerExpr = {
               if (!"path" %in% names(dir())) return()
               home <- normalizePath("~")
               global$datapath <-
                 file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
             })

observe({
  saveObjectReactive()
})

# Save file
saveObjectReactive <-
  eventReactive(input$saveObject,
                ignoreNULL = FALSE, {
                  withProgress(message = "Saving the analysis, please wait",{
                    print("saveObjectReactive")
                  
                    ngsData <- clusteringReactive()$ngsData
                    
                    # shiny:: validate(
                    #   need(!(is.null(ngsData)),
                    #        message = "You need to perform the clustering before saving the analysis")
                    # )
                    # 
                    # shiny:: validate(
                    #   need(!(is.null(input$filename)),
                    #        message = "Please, write a name for the file")
                    # )
                    saveRDS(ngsData, file = paste0(global$datapath,"/",input$filename,".rds"))
                    
                    #output$saveInfo <- renderText(expr = "File saved succesfuly!")
                    print("Analisys saved")
                  })
                  
                }
  )


observe({
  loadClusteringReactive()
})

# Load file
loadClusteringReactive <-
  eventReactive(input$loadObject,
                ignoreNULL = FALSE, {
                  withProgress(message = "Loading the analysis file, please wait",{
                    print("loadObjectReactive")

                    inFile <- input$savedAnalysis

                    if (is.null(inFile))
                      return(NULL)

                    ngsData <- readRDS(inFile$datapath, refhook = NULL)


                    print("Analisys loaded")

                    if (!is.null(ngsData)){
                      output$loadInfo <- renderText(expr = "File loaded succesfuly!")
                      }
                    return(list("ngsData"=ngsData))
                  })

                }
  )

