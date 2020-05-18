tabItem(tabName = "intro",
        fluidPage(
          titlePanel("Introduction to scShinySeq"),
          p("This Shiny aplication allows the user to perform a single cell analysis using the 
            ",a("Seurat - Guided Clustering Tutorial pipeline",href="https://satijalab.org/seurat/v3.1/pbmc3k_tutorial.html")," ,
            and also implements the ",a("SC3 clustering",href="https://bioconductor.org/packages/devel/bioc/vignettes/SC3/inst/doc/SC3.html#de-and-marker-genes")),
          p("The seurat pipeline was inspired and some parts adapted of the shiny aplication ",a("seurat V3",href="https://github.com/satijalab/seurat")),
          p("The progression throw the pipeline is represented in the image below:"),
          hr(),
          img(src = "Pipeline.png", height = 600, width = 400, style="display: block; margin-left: auto; margin-right: auto;"),
          hr(),
          p("The following analysis steps: differentially expressed genes, visualizing marker expression and SC3 Clustering, can be performed after 
            the Cell Clustering step or from a saved analysis file. To work properly, the saved analysis file should correspond an analysis after the Cell Clustering;"),
          p("Please, note as described in ",a("Duò et. al.",href="https://f1000research.com/articles/7-1141"),"  SC3 Clustering is several orders of magnitude slower than Seurat, also, SC3 estimation of cluster number has a tendency towards overestimation.")
        )
)


