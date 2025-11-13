FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    default-libmysqlclient-dev \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY superset_config.py /app/superset_config.py
COPY data/ /app/data/

RUN useradd -ms /bin/bash superset
USER superset

ENV SUPERSET_HOME=/app
ENV FLASK_APP=superset

CMD bash -c "\
    superset db upgrade && \
    superset import-dashboards -p /app/data/dashboards/dashboard_export_20251113T112241.zip && \
    superset run -p 8088 --host 0.0.0.0"
