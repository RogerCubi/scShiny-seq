library(SingleCellExperiment)
library(SC3)
library(scater)
library(Seurat)


so <- readRDS("/Users/rogercubi/Dropbox/MasterBioinformatica/TFM/scShiny-seq/www/Project1_tsne.rds", refhook = NULL)
so@active.assay <- 'RNA'

sce <- as.SingleCellExperiment(so)

head(sce)
rownames(sce)

rowData(sce)$feature_symbol <- rownames(sce)
sce <- sce[!duplicated(rowData(sce)$feature_symbol), ]

counts(sce) <- as.matrix(counts(sce))
normcounts(sce) <- as.matrix(normcounts(sce))
logcounts(sce) <- as.matrix(logcounts(sce))

sce <- sc3(sce, ks = 5:15, biology = TRUE, n_cores=4)

saveRDS(sce, file = "/Users/rogercubi/Dropbox/MasterBioinformatica/TFM/sceFileAnalysis.rds", ascii = FALSE, version = NULL,
        compress = TRUE, refhook = NULL)

sc3_interactive(sce)

plotPCA(
  sce, 
  colour_by = "sc3_15_clusters", 
  size_by = "sc3_15_log2_outlier_score"
)


sc3_plot_consensus(sce, k = 3)

sc3_plot_consensus(
  sce, k = 15, 
  show_pdata = c(
    "seurat_clusters",
    "sc3_15_clusters", 
    "sc3_15_log2_outlier_score"
  )
)

sc3_plot_silhouette(sce, k = 3)

sc3_plot_expression(sce, k = 3)

#It is also possible to annotate cells (columns of the expression matrix) with any column of the colData slot of the sce object.
sc3_plot_expression(
  sce, k = 4, 
  show_pdata = c(
    "seurat_clusters", 
    "log10_total_features",
    "sc3_4_clusters", 
    "sc3_4_log2_outlier_score"
  )
)


sc3_plot_de_genes(sce, k = 3)


sc3_plot_de_genes(
  sce, k = 4, 
  show_pdata = c(
    "seurat_clusters",
    "sc3_3_clusters", 
    "sc3_3_log2_outlier_score"
  )
)


#Marker Genes
sc3_plot_markers(sce, k = 4)


sc3_plot_markers(
  sce, k = 3, 
  show_pdata = c(
    "seurat_clusters", 
    "log10_total_features",
    "sc3_3_clusters", 
    "sc3_3_log2_outlier_score"
  )
)


sce <- sc3_estimate_k(sce)


str(metadata(sce)$sc3)




