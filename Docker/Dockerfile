###  ubuntu:20.04 LTS  image
FROM ubuntu:20.04 AS um-base
ARG version=${version:-1.0}
USER root
VOLUME ["/src"]
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
LABEL authors="David Laperriere dlaperriere@outlook.com"
MAINTAINER "David Laperriere dlaperriere@outlook.com"
LABEL version="${version:-1.0}"


## Set Time Zone 
ENV TIME_ZONE=America/New_York
ENV LOCALE_CODE en_US.UTF-8
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

## Install/update packages
RUN apt-get update && apt-get install -y \
  file \
  git \
  nano \
  && apt-get -qq clean    \
  && rm -rf /var/lib/apt/lists/*


### Build image with build tools 
FROM um-base AS um-with-buildtools
USER root

RUN apt-get update && apt-get install -y \
  build-essential \
  clang \
  clang-tidy \
  cmake \
  cppcheck \
  libcppunit-dev \
  gradle \
  make \
  openjdk-11-jdk \
  perl \
  python \
  python-pip-whl \
  python3 \
  python3-pip \
  python3-venv \
  libsqlite3-dev \
  r-base \
  r-recommended \  
  r-cran-biocmanager \
  r-cran-devtools \
  swig \
  virtualenv \
  && apt-get -qq clean    \
  && rm -rf /var/lib/apt/lists/*

# GEO_microarrays R required packages
RUN mkdir -p /tmp/Docker

COPY ./install_packages.R /tmp/Docker/
RUN R --no-save < /tmp/Docker/install_packages.R


ENTRYPOINT ["bash"]
