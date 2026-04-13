FROM rocker/r-base:4.5.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      libxml2-dev \
      libcurl4-openssl-dev \
      libssl-dev \
      libgit2-dev \
      make \
      g++ && \
    rm -rf /var/lib/apt/lists/*

RUN R -q -e "install.packages(c('xml2','lintr','styler','testthat','covr','remotes'), repos='https://cloud.r-project.org', Ncpus=max(1, parallel::detectCores() - 1L))"

RUN R -q -e "sessionInfo()"
