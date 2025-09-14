
# Set default Shiny port
options(shiny.port = 3838)
options(shiny.host = "0.0.0.0")

library(scRNAseqApp)
library(Seurat)

publish_folder=Sys.getenv("APP_DIR")
data_folder=Sys.getenv("DATA_DIR")


print(publish_folder)
print(list.files(publish_folder, recursive = TRUE))

scInit(app_path=publish_folder)

pbmc_rds <- "extdata/pbmc_signac_sub.rds"
pbmc <- readRDS(pbmc_rds)
appconf <- createAppConfig(
  title="pbmc small protected",
  destinationFolder = "pbmc_protected",
  species = "Homo sapiens",
  doi="10.1038/nbt.3192",
  datatype = "scRNAseq")
createDataSet(appconf, pbmc, LOCKER = TRUE,
              datafolder = data_folder)
dir(file.path(data_folder, "pbmc_protected"))
scRNAseqApp(app_path = publish_folder)

sessionInfo()