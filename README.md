# scShiny-seq

This Shiny aplication allows the user to perform a single cell analysis using the "Seurat - Guided Clustering Tutorial" (https://satijalab.org/seurat/v3.1/pbmc3k_tutorial.html) and the SC3 clustering. pipelines (https://bioconductor.org/packages/devel/bioc/vignettes/SC3/inst/doc/SC3.html#de-and-marker-genes)

The seurat pipeline was inspired and some parts adapted of the shiny aplication seurat V3 (https://github.com/satijalab/seurat)
Most of the text describing the analysis options is extracted from the "Seurat Guided Clustering Tutorial" (https://satijalab.org/seurat/v3.1/pbmc3k_tutorial.html)

The progression throw the pipeline is represented in the image below:


<img src="https://github.com/RogerCubi/scShiny-seq/blob/version2/www/Pipeline.png?raw=true" height="480" width="300">

The following analysis steps: differentially expressed genes, visualizing marker expression and SC3 Clustering, can be performed after the Cell Clustering step or from a saved analysis file. To work properly, the saved analysis file should correspond an analysis after the Cell Clustering

Please, note as described in Duò et. al. (https://f1000research.com/articles/7-1141) SC3 Clustering is several orders of magnitude slower than Seurat, also, SC3 estimation of cluster number has a tendency towards overestimation.

