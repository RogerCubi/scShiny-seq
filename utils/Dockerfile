# Dockerfile for scShiny-seq
#
# R 3.6.3 shiny-server app exposed in 3838
# 
# Izaskun Mallona
# 22 June 2020

# docker build -t scshinyseq .
# docker run --rm -p 3838:3838 --name test scshinyseq 
# docker exec -it test /bin/bash

FROM rocker/shiny:3.6.2

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    git \
    libxml2 \
    libxml2-dev \
    r-cran-rstan \
    r-cran-xml
  

# install R packages required 
RUN R -e "install.packages('devtools', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rstan', repos='http://cran.rstudio.com/')"

# bioC 3.9

RUN R -e "BiocManager::install(version = '3.9', ask = FALSE)"

RUN R -e "devtools::install_version('shiny', version = '1.4.0.2', repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_version('shinydashboard', version = '0.7.1', repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_version('shinyFiles', version = '0.8.0', repos='http://cran.rstudio.com/')"

RUN R -e "devtools::install_version('survival', version = '3.1-12', repos='http://cran.rstudio.com/')"

RUN R -e "devtools::install_version('Hmisc', version = '4.4-0', repos='http://cran.rstudio.com/')"

RUN R -e "devtools::install_version('patchwork', version = '1.0.0', repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_version('DT', version = '0.13', repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_version('ggplot2', version = '3.3.1', repos='http://cran.rstudio.com/')"

RUN R -e "devtools::install_version('Seurat', version = '3.1.5', repos='http://cran.rstudio.com/')"
RUN R -e "BiocManager::install(c('DESeq2', 'GenomicRanges', 'SC3', 'MAST', 'scater', 'SingleCellExperiment'), version = '3.9')"

# code

RUN mkdir -p /srv/shiny-server/scShiny-seq

COPY scShiny-seq /srv/shiny-server/scShiny-seq

RUN unzip /srv/shiny-server/scShiny-seq/www/hg19/matrix.mtx.zip -d /srv/shiny-server/scShiny-seq/www/hg19/

COPY shiny-server.conf /etc/shiny-server

# COPY R /srv/shiny-server/R

# select port
EXPOSE 3838

# allow permission
RUN sudo chown -R shiny:shiny /srv/shiny-server

# run app
CMD ["/usr/bin/shiny-server.sh"]

