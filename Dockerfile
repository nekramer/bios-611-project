FROM rocker/verse
MAINTAINER Nicole Kramer <nekramer@live.unc.edu>
RUN R -e "install.packages(c('rvest', 'tidyverse', 'shiny', 'plotly', 'MLmetrics', 'remotes'))"
RUN R -e "remotes::install_github('apreshill/bakeoff')"
