
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
parse_title <- config$title %||% Sys.getenv("TITLE") 
parse_doi <- config$doi %||% Sys.getenv("DOI") %||% "10.1038/nbt.3192"
parse_datatype <- config$datatype %||% Sys.getenv("DATATYPE") %||% "scRNAseq"
parse_species <- config$species %||% Sys.getenv("SPECIES") %||% "Homo sapiens"
parse_destinationFolder <- config$destinationFolder %||% Sys.getenv("DESTINATION_FOLDER") %||% "pbmc_signac_sub"
parse_inputfile <- config$input_file %||% Sys.getenv("INPUT_FILE") %||% "extdata/pbmc_signac_sub.rds"
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
createDataSet(appconf, pbmc, LOCKER = TRUE,
              datafolder = data_folder)
dir(file.path(data_folder, parse_destinationFolder))
scRNAseqApp(app_path = publish_folder)

sessionInfo()