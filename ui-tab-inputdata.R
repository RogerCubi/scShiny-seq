tabItem(tabName = "datainput",
        hr(),
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              tags$style("#nextStep1 {font-size:16px;color:red;display:block;position:relative;text-align:center; }"),
              radioButtons("datatype", "Select the Data",
                           c("nonUMI Dataset" = "uploadNonUmi",
                             "10X Dataset" = "10xdata",
                             "PBMC Dataset" = "pbmcdata")),
              
              hr(),
              conditionalPanel(condition = "input.datatype=='uploadNonUmi' ||  input.datatype=='10xdata'",
                               fileInput("loadfiles", 'Select the data files', multiple = TRUE )),
              conditionalPanel(condition = "input.datatype=='10xdata'",
                               #fileInput("loadfiles", 'Select the data files', multiple = TRUE ),
                               p("10X Data: 1 .mtx file, and 2 .tsv files")),
              conditionalPanel(condition = "input.datatype=='uploadNonUmi'",
                               #fileInput("loadfiles", 'Select the data files', multiple = TRUE ),
                               p("CSV counts file")),
                              
              hr(),
              conditionalPanel("output.fileUploaded",
                               #box(title = "Initial Parameters", solidHeader = T, status = "primary", width = 12, collapsible = T,id = "uploadbox",
                                   p(strong("Initial Parameters")),
                                   textInput("projectname",
                                             value = "Project1", label = "Project Name"),
                                   numericInput("mincells",
                                                label="Minimum number of cells per gene",min=1,max=200,value=3),
                                   numericInput("mingenes",
                                                label="Minimum number of genes per cell",min=1,max=Inf,value=200),
                                   actionButton("upload_data","Validate Parameters", class = "button button-3d button-block button-pill button-caution", style = "width: 100%")
                                   
                               #)
              ), # ConditionalPanel
              hr(),
              textOutput("nextStep1")
              

            ), # sidebarPanel
            mainPanel(
              DT::dataTableOutput("loadData"),
              fluidRow(column(width = 5, textOutput("tableInfo")))
              
            )
          ) #sidebarLayout
        ) #fluidPage
        
        
        
        
        ) #tabItem 


