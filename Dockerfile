FROM python:3.12-slim

USER root

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libpq-dev \
    libffi-dev \
    unzip \
    git \
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
ENV SUPERSET_SECRET_KEY="supersecretkey"
ENV SUPERSET_ADMIN_USERNAME=guest
ENV SUPERSET_ADMIN_FIRST_NAME=Guest
ENV SUPERSET_ADMIN_LAST_NAME=User
ENV SUPERSET_ADMIN_EMAIL=guest@example.com
ENV SUPERSET_ADMIN_PASSWORD=guest

EXPOSE 8088

CMD ["./superset_import_entrypoint.sh"]
