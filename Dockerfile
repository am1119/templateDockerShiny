FROM bioconductor/bioconductor_docker:RELEASE_3_19

# install Bioc
RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); install.packages('BiocManager')" && \
    Rscript -e "BiocManager::install(ask=FALSE)" && \
    # install the package itself
    Rscript -e "BiocManager::install('scRNAseqApp')"

RUN Rscript -e "install.packages('remotes'); remotes::install_github('timoast/signac')"

ENV APP_DIR="/app/scRNAseqApp_project"
ENV DATA_DIR="/app/scRNAseqApp_project/data"

USER root

RUN mkdir -p $APP_DIR $DATA_DIR
RUN chown rstudio:rstudio $APP_DIR $DATA_DIR


# Switch to rstudio user for runtime
USER rstudio

# Add the app setup script
ADD app_setup.R $APP_DIR/app_setup.R
COPY /extdata/ $APP_DIR/extdata/

# Expose Shiny port
EXPOSE 3838

WORKDIR $APP_DIR

# Run the app only at container runtime, not during build
ENTRYPOINT ["Rscript", "app_setup.R"]
