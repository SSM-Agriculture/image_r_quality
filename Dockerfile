FROM rocker/r-base:4.5.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        pkg-config \
        cmake \
        libuv1 \
        libuv1-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libgit2-dev \
        make \
        g++ && \
    rm -rf /var/lib/apt/lists/*


RUN R -q -e "install.packages(\
    c(\
      'remotes',\
      'lintr',\
      'styler',\
      'covr',\
      'goodpractice',\
      'cli',\
      'jsonlite',\
      'xml2',\
      'glue',\
      'fs',\
      'rlang',\
      'withr',\
      'testthat'\
    ),\
    repos='https://cloud.r-project.org',\
    Ncpus=max(1, parallel::detectCores() - 1L)\
)"


RUN R -q -e "remotes::install_github('ddotta/rsonar')"


RUN R -q -e "
cat('R library paths:\\n')
print(.libPaths())

cat('\\nInstalled packages:\\n')
print(c(
  'rsonar',
  'lintr',
  'styler',
  'covr',
  'goodpractice',
  'fs'
) %in% rownames(installed.packages()))

sessionInfo()
"
