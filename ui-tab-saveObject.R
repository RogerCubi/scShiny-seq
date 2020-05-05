tabItem(tabName = "saveSeuratTab",
        wellPanel(
        fluidPage(h4(strong("Save the Seurat Object")),
          sidebarLayout(
            sidebarPanel(
              actionButton(inputId = "saveObject",label = "Save analysis", icon = icon("save") ),
            ),
            mainPanel(
              shinyDirButton("dir", "Input directory", "Upload"),
              verbatimTextOutput("dir", placeholder = TRUE),
              hr(),
              textInput(inputId = "filename", label = "Enter a name for the file"),
              #textOutput("saveInfo")
            )# mainPanel
          )
        )),
        wellPanel(
        fluidPage(h4(strong("Load a Seurat Object")),
                  sidebarLayout(
                    sidebarPanel(
                      actionButton(inputId = "loadObject",label = "Load analysis", icon = icon("file-upload")) 
                    ),
                    mainPanel(
                      fileInput(inputId = "savedAnalysis",label = "Select an analysis file",multiple = FALSE),
                      textOutput("loadInfo")
                    )# mainPanel
                  )
        )),
)
