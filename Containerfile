ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-slim

ARG DEVELOPMENT=true
ENV PBR_VERSION=999.0.0

COPY . /app
WORKDIR /app

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
    && python3 -m pip --no-cache-dir install -U 'pip==23.2.1' 'pipenv==2022.9.24' \
    && pipenv install --system --deploy

RUN if [ $DEVELOPMENT = "true" ]; then rm -rf /app; mkdir -p /app; fi

RUN apt-get remove -y \
        build-essential \
        gcc \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

LABEL "org.opencontainers.image.vendor"="23 Technologies GmbH"
