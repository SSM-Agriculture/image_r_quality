FROM rocker/r-base:4.5.1

ENV DEBIAN_FRONTEND=noninteractive
ENV OTEL_SDK_DISABLED=true

# ------------------------------------------------------------------------------
# Dépendances système
# ------------------------------------------------------------------------------

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        make \
        g++ \
        pkg-config \
        cmake \
        libuv1 \
        libuv1-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libgit2-dev \
        pandoc && \
    rm -rf /var/lib/apt/lists/*


# ------------------------------------------------------------------------------
# Packages R qualité
# ------------------------------------------------------------------------------

RUN R --vanilla --slave -e "\
install.packages(\
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
    'testthat',\
    'knitr',\
    'rmarkdown',\
    'pkgdown',\
    'htmltools'\
  ),\
  repos='https://cloud.r-project.org',\
  Ncpus=max(1, parallel::detectCores() - 1L)\
)"


# ------------------------------------------------------------------------------
# Installation rsonar
# ------------------------------------------------------------------------------

RUN R --vanilla --slave -e "\
remotes::install_github(\
  'ddotta/rsonar',\
  dependencies=TRUE,\
  upgrade='never'\
)"


# ------------------------------------------------------------------------------
# Vérification finale
# ------------------------------------------------------------------------------

RUN R --vanilla --slave <<'EOF'

cat("============================================\n")
cat("R quality image validation\n")
cat("============================================\n\n")

cat("R version:\n")
print(R.version.string)

cat("\nLibrary paths:\n")
print(.libPaths())


pkgs <- c(
  "rsonar",
  "lintr",
  "styler",
  "covr",
  "goodpractice",
  "cli",
  "jsonlite",
  "xml2",
  "glue",
  "fs",
  "rlang",
  "withr",
  "testthat",
  "knitr",
  "rmarkdown",
  "pkgdown",
  "htmltools"
)


cat("\nPackage availability:\n")

print(
  data.frame(
    package = pkgs,
    installed = pkgs %in% rownames(installed.packages())
  )
)


cat("\nLoading packages:\n")

invisible(
  lapply(
    pkgs,
    library,
    character.only = TRUE
  )
)


cat("\nChecking rsonar:\n")
library(rsonar)

print(packageVersion("rsonar"))


cat("\nImage validation OK\n")

EOF
