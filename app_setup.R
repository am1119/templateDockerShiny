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


# Set default Shiny port
options(shiny.port = 3838)
options(shiny.host = "0.0.0.0")

library(scRNAseqApp)
library(Seurat)

publish_folder=tempdir()
scInit(app_path=publish_folder)

scRNAseqApp(app_path = publish_folder)

appconf <- createAppConfig(
            title="pbmc_small_test",
            destinationFolder = "pbmc_small_test",
            species = "Homo sapiens",
            doi="10.1038/nbt.3192",
            datatype = "scRNAseq",
            abstract = 'Put the description of the data here.')
createDataSet(
    appconf,
    pbmc_small,
    datafolder=file.path(publish_folder, "data"))
dir(file.path(publish_folder, 'data'))

sessionInfo()