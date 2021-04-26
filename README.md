# Python Level Up: Dockerize Your Python Apps

## py-debian-conda-flask-template

### Docker Instructions

#### Docker Build & Run App

```
docker build --target python-base -f Dockerfile -t py-debian-conda-flask .
docker run --user=appuser -p 5000:5000 --env APP_ENV=DEV py-debian-conda-flask
```

#### Docker Build & Run Tests

```
docker build --target testing -f Dockerfile -t py-debian-conda-flask .
docker run --user=appuser -p 5000:5000 --env APP_ENV=DEV py-debian-conda-flask
```

---

### Local Environment

#### Pre-requisites

- Install anaconda via homebrew e.g. `brew cask install anaconda`

#### Environment Setup

- Create conda environment via `conda env create -f conf/environment.yml`