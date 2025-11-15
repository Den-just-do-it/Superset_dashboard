FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    build-essential gcc libpq-dev libffi-dev unzip git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /app/requirements.txt
COPY superset_config.py /app/superset_config.py
COPY superset_import_entrypoint.sh /app/superset_import_entrypoint.sh
COPY data /app/data
COPY superset_home /app/superset_home

RUN chmod +x /app/superset_import_entrypoint.sh

RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r /app/requirements.txt

ENV FLASK_APP=superset
ENV SUPERSET_HOME=/app/superset_home
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV SUPERSET_LOAD_EXAMPLES=False

EXPOSE 8088

CMD ["./superset_import_entrypoint.sh"]
