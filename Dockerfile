# docker build -t mgrclient .
# This dockerfile builds an environment that can use the MG-RAST Python tools and MG-RAST R package.
# ca. 2018-03-14

FROM ubuntu:16.04
MAINTAINER trimble@anl.gov

RUN apt-get update  &&  apt-get install -y git r-base 
RUN apt-get install -y python python-dev python-setuptools python-pytest

RUN apt-get install -y libcurl4-openssl-dev libssl-dev  # needed by R devtools

RUN R -e "install.packages(c('devtools', 'RJSONIO'), repos = 'http://cran.us.r-project.org')" && R -e "library(devtools); install_github(repo='MG-RSAT/MGRASTer') ; install_github(repo='MG-RAST/matR')"
#RUN apt-get install -y jellyfish
 
RUN git clone http://github.com/MG-RAST/MG-RAST-Tools && cd MG-RAST-Tools && python setup.py build && python setup.py install 

#ENV PATH="/home/MG-RAST-Tools/scripts:${PATH}"

