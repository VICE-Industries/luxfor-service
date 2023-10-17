ARG PYTHON_VERSION=3.11
FROM python:${PYTHON_VERSION}-slim

COPY main.py Pipfile* /
WORKDIR /

RUN python3 -m pip --no-cache-dir install -U 'pipenv==2022.9.24'
RUN pipenv install --system --deploy

CMD python3 /main.py

EXPOSE 80/tcp

LABEL "org.opencontainers.image.vendor"="23 Technologies GmbH"
