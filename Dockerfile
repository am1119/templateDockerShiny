FROM bioconductor/bioconductor_docker:RELEASE_3_19

# get the get put functions
# Update the package lists and install Python and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && apt-get clean


# Install Python dependencies using pip
RUN pip3 install galaxy-ie-helpers

# install Bioc
RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); install.packages('BiocManager')" && \
    Rscript -e "BiocManager::install(ask=FALSE)" && \
    # install the package itself
    Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); options(Ncpus = 2); BiocManager::install('scRNAseqApp')"

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
