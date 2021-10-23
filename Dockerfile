FROM rocker/verse
MAINTAINER Nicole Kramer <nekramer@live.unc.edu>
RUN R -e "install.packages(c('rvest', 'tidyverse'))"
