FROM rocker/shiny:4.3.1
# comes preinstalled with a bunch of packages

RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev

RUN R -e "install.packages(c('abbreviate','rmarkdown'), \
    repos = 'https://packagemanager.posit.co/cran/__linux__/jammy/latest')"

COPY ./apps/* /srv/shiny-server/

CMD ["/usr/bin/shiny-server"]