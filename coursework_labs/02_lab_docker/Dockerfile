FROM rocker/shiny:4.3.1
# comes preinstalled with a bunch of packages

RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev

RUN R -e "install.packages(('palmerpenguins'), \
    repos = 'https://packagemanager.posit.co/cran/__linux__/jammy/latest')"
    
RUN rm /srv/shiny-server/index.html
ruN rm -rf /srv/shiny-server/sample-apps

COPY ./apps/* /srv/shiny-server/

CMD ["/usr/bin/shiny-server"]