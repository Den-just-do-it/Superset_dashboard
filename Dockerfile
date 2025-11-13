FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libffi-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
COPY superset_config.py .
COPY superset_import_entrypoint.sh .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8088

ENV FLASK_APP=superset
ENV SUPERSET_HOME=/app/superset_home
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV SUPERSET_LOAD_EXAMPLES=False
ENV SUPERSET_SECRET_KEY="jA4qkvIMzFBtT8uaFASnrS3nftBqn315VHl8FOpIKaY7Ei"

ENV SUPERSET_ADMIN_USERNAME=guest
ENV SUPERSET_ADMIN_FIRST_NAME=Guest
ENV SUPERSET_ADMIN_LAST_NAME=User
ENV SUPERSET_ADMIN_EMAIL=guest@example.com
ENV SUPERSET_ADMIN_PASSWORD=guest

CMD ["./superset_import_entrypoint.sh"]
