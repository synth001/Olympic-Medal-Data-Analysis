# Dockerfile for Olympic Medal Analysis

FROM rocker/r-ver:4.3.2

# Install Linux dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev libcurl4-gnutls-dev libxml2-dev \
    texlive-latex-base texlive-latex-extra texlive-fonts-recommended \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
WORKDIR /app
COPY . /app

# Install R packages
RUN Rscript -e "install.packages(c('tidyverse','countrycode','WDI','maps','viridis','corrplot','rmarkdown'), repos='https://cloud.r-project.org/')"

# Default command: run analysis then render report
CMD ["bash", "-lc", "make all"]
