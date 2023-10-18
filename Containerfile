ARG PYTHON_VERSION=3.11
FROM python:${PYTHON_VERSION}-slim

ARG USER_ID=45000
ARG GROUP_ID=45000

COPY main.py Pipfile* /
WORKDIR /

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libusb-1.0-0 \
    && groupadd -g $GROUP_ID dragon \
    && useradd -g dragon -u $USER_ID -m -d /var/lib/dragon dragon \
    && usermod -a -G plugdev dragon \
    && apt-get clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN python3 -m pip --no-cache-dir install -U 'pipenv==2022.9.24'
RUN pipenv install --system --deploy

USER dragon

CMD python3 /main.py

EXPOSE 80/tcp

LABEL "org.opencontainers.image.vendor"="23 Technologies GmbH"
