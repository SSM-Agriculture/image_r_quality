FROM rocker/r-base:4.5.1

ENV DEBIAN_FRONTEND=noninteractive

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
        libgit2-dev && \
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# Packages R
# ------------------------------------------------------------------------------

RUN R -q -e "install.packages( \
    c( \
      'remotes', \
      'lintr', \
      'styler', \
      'covr', \
      'goodpractice', \
      'cli', \
      'jsonlite', \
      'xml2', \
      'glue', \
      'fs', \
      'rlang', \
      'withr', \
      'testthat' \
    ), \
    repos='https://cloud.r-project.org', \
    Ncpus=max(1, parallel::detectCores() - 1L) \
)"

# ------------------------------------------------------------------------------
# rsonar
# ------------------------------------------------------------------------------

RUN R -q -e "remotes::install_github('ddotta/rsonar')"

# ------------------------------------------------------------------------------
# Vérification de l'image
# ------------------------------------------------------------------------------

RUN R -q <<'EOF'
cat("============================================\n")
cat("R quality image successfully built\n")
cat("============================================\n\n")

cat("R version\n")
print(R.version.string)

cat("\nLibrary paths\n")
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
  "testthat"
)

cat("\nInstalled packages\n")
print(
  data.frame(
    package = pkgs,
    installed = pkgs %in% rownames(installed.packages())
  )
)

cat("\nLoading packages...\n")

invisible(lapply(pkgs, library, character.only = TRUE))

cat("All packages successfully loaded.\n\n")

sessionInfo()
EOF
