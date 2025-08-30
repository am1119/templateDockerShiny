# # 1. Base image with Shiny and R from Rocker
# FROM rocker/shiny:latest

# # 2. Install system dependencies
# RUN apt-get update && apt-get install -y \
#     libcurl4-openssl-dev \
#     libssl-dev \
#     libxml2-dev \
#     && rm -rf /var/lib/apt/lists/*

# # 3. Install Bioconductor and scRNAseqApp
# RUN R -e "if (!requireNamespace('BiocManager', quietly=TRUE)) install.packages('BiocManager')"
# RUN R -e "BiocManager::install('scRNAseqApp')"

# # 4. Copy the app (if using a local app.R or code)
# # COPY scRNAseqApp_shiny/ /srv/shiny-server/

# # 5. Set permissions (optional; rocker/shiny uses a shiny user)
# RUN chown -R shiny:shiny /srv/shiny-server/

# # 6. Expose Shiny port
# EXPOSE 3838

# # 7. Launch Shiny Server
# CMD ["/usr/bin/shiny-server"]



# # ARG 

FROM bioconductor/bioconductor_docker:RELEASE_3_19

# install Bioc
RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); install.packages('BiocManager')" && \
    Rscript -e "BiocManager::install(ask=FALSE)" && \
    # install the package itself
    Rscript -e "BiocManager::install('scRNAseqApp')"


ENV APP_DIR="/app/scRNAseqApp_project"
ENV DATA_DIR="/app/scRNAseqApp_project/data"

USER root

RUN mkdir -p /app/scRNAseqApp_project /app/scRNAseqApp_project/data /app/extdata
RUN chown rstudio:rstudio /app/scRNAseqApp_project /app/scRNAseqApp_project/data /app/extdata


# Switch to rstudio user for runtime
USER rstudio

# Add the app setup script
ADD app_setup.R $APP_DIR/app_setup.R
COPY /extdata/ /app/extdata/

# Expose Shiny port
EXPOSE 3838

WORKDIR $APP_DIR

# Run the app only at container runtime, not during build
ENTRYPOINT ["Rscript", "app_setup.R"]
