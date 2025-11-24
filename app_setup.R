
# Set default Shiny port
options(shiny.port = 3838)
options(shiny.host = "0.0.0.0")

library(scRNAseqApp)
library(Seurat)

if (!requireNamespace("yaml", quietly = TRUE)) stop("Please install yaml package in the image")
cfg_path <- Sys.getenv("APP_CONFIG", unset = "app_config.yaml")
config <- list()
if (file.exists(cfg_path)) config <- yaml::read_yaml(cfg_path)

publish_folder <- config$app_dir %||% Sys.getenv("APP_DIR")
data_folder <- config$data_dir %||% Sys.getenv("DATA_DIR")
parse_title <- Sys.getenv("TITLE") %||% config$title
parse_doi <- config$doi %||% "10.1038/nbt.3192"
parse_datatype <- Sys.getenv("DATATYPE")  %||%  config$datatype
parse_species <- Sys.getenv("SPECIES") %||% config$species
parse_destinationFolder <- Sys.getenv("TITLE") %||% config$destinationFolder
parse_inputfile <- Sys.getenv("INPUT_FILE") %||% config$input_file
#%||% "extdata/pbmc_signac_sub.rds"
# publish_folder=Sys.getenv("APP_DIR")
# data_folder=Sys.getenv("DATA_DIR")


print(publish_folder)
print(list.files(publish_folder, recursive = TRUE))

scInit(app_path=publish_folder)

input <- file.path("extdata", parse_inputfile)
pbmc <- readRDS(input)
appconf <- createAppConfig(
  title = parse_title,
  destinationFolder = parse_destinationFolder,
  species = parse_species,
  doi = parse_doi,
  datatype = parse_datatype)
createDataSet(appconf, pbmc, LOCKER = FALSE,
              datafolder = data_folder)
dir(file.path(data_folder, parse_destinationFolder))
scRNAseqApp(app_path = publish_folder)

sessionInfo()