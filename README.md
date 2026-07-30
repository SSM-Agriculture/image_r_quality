# 🐳 ssmagr/r-quality

Image Docker R prechargee pour les jobs CI de qualite (lint, style, tests).

## Contenu
- Base: `rocker/r-base:4.5.1`
- Dependances systeme utiles a la compilation de packages R
- Packages R installes a l'image build: `xml2`, `lintr`, `styler`, `testthat`, `covr`, `remotes`

## Publication sur Docker Hub
1. Push du repository sur GitHub.
2. Le workflow GitHub Actions publie l'image sur `docker.io/<dockerhub_username>/r-quality`.
3. Utiliser l'image dans la CI :

```yaml
image:
  name: <dockerhub_username>/r-quality:latest
```

## Configuration requise
Definir les secrets GitHub dans le repository:
- `DOCKERHUB_USERNAME`: votre username Docker Hub
- `DOCKERHUB_TOKEN`: un token d'accès Docker Hub

## Utilisation avec le template CI
Dans le projet consommateur, definir la variable CI:

```yaml
variables:
  R_QUALITY_IMAGE: <dockerhub_username>/r-quality:latest
```

Ainsi, `lintr` et `styler` ne sont plus reinstalles a chaque pipeline.
