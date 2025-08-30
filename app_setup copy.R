# library("templateDockerShinyPkg")

# input_folder <- Sys.getenv("SHINY_INPUT_DIR")
# output_folder <- Sys.getenv("SHINY_OUTPUT_DIR")

# # read input data if it is present in the expected location, otherwise use 
# # the old faithful data
# if ((input_folder == '' || !dir.exists(input_folder))) {
#   x <- faithful$waiting
# } else {
#   data_obj_path <- file.path(input_folder, "data.rds")
#   if (!file.exists(data_obj_path)) {
#     x <- faithful$waiting
#   } else {
#     x <- readRDS(data_obj_path)
#   }
# }

# # generate app
# if (output_folder == '' || !dir.exists(output_folder)) {
#   app_template <- histogramApp(x)
# } else {
#   app_template <- histogramAppWithExport(x, outputDir = output_folder)
# }

# # run app
# out <- shiny::runApp(app_template, launch.browser = FALSE, port = 3838, host = "0.0.0.0")

# # save output from app if it is generated and the output folder exists
# if (exists("out")) {
#   if (output_folder == "" || !dir.exists(output_folder)) {
#     # there is data, but the output folder is mis-specified
#     # do nothing
#    } else {
#       saveRDS(out, file = file.path(output_folder, "template_output.rds"))
#       write.table(out$log, file = file.path(output_folder, "template_log.tab"), 
#                   row.names = FALSE, quote = FALSE, col.names = FALSE)
#   }
# } else {
#   # do nothing
# }


# app_setup.R

library(scRNAseqApp)
library(Seurat)


app_dir        <- "/app/scRNAseqApp_project"
data_folder    <- "/app/scRNAseqApp_project/data"
admin_user     <- "admin"
admin_password <- "scRNAseqApp"
app_title      <- "Dockerized scRNAseqApp"
app_desc       <- "Single-cell RNA-seq visualization app running via shiny::runApp"

# Initialize the app (overwrite=FALSE ensures we don't overwrite existing setup)
if (!dir.exists(app_dir)) {
  scInit(
    app_path        = app_dir,
    root            = admin_user,
    password        = admin_password,
    datafolder      = data_folder,
    overwrite       = FALSE,
    app_title       = app_title,
    app_description = app_desc
  )
}



# # Dataset configuration
# appconf <- createAppConfig(
#   title             = "pbmc_small",
#   destinationFolder = "pbmc_small",
#   species           = "Homo sapiens",
#   doi               = "10.1038/nbt.3192",
#   datatype          = "scRNAseq",
#   keywords          = c("PBMC", "immune cells"),
#   abstract          = "Small demonstration PBMC dataset."
# )

# # Only create the dataset if it doesn't exist
# dataset_path <- file.path(app_dir, data_folder, appconf$destinationFolder)
# if (!dir.exists(dataset_path)) {
#   createDataSet(
#     appconf     = appconf,
#     seu         = pbmc_small,
#     config      = NULL,
#     contrast    = NULL,
#     assayName   = "RNA",
#     gexSlot     = "data",
#     datafolder  = data_folder
#   )
# }


pbmc_rds <- "/app/extdata/pbmc_signac_sub.rds"
pbmc <- readRDS(pbmc_rds)
appconf <- createAppConfig(
  title="pbmc small protected",
  destinationFolder = "pbmc_protected",
  species = "Homo sapiens",
  doi="10.1038/nbt.3192",
  datatype = "scRNAseq")
createDataSet(appconf, pbmc, LOCKER = TRUE,
              datafolder = data_folder)
scRNAseqApp(app_path = publish_folder)

# Launch the Shiny app
# shiny::runApp(app_dir, host = "0.0.0.0", port = 3838)
