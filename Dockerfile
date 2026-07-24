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
# Validation de l'image
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
  "htmltools"
)


cat("\nPackage availability:\n")

status <- pkgs %in% rownames(installed.packages())

print(
  data.frame(
    package = pkgs,
    installed = status
  )
)


if (!all(status)) {
  stop(
    "Missing packages: ",
    paste(pkgs[!status], collapse = ", ")
  )
}


cat("\nrsonar version:\n")
print(packageVersion("rsonar"))


cat("\nValidation OK\n")

EOF
