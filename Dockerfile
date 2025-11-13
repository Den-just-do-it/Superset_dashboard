FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
COPY superset_config.py .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8088

ENV FLASK_APP=superset
ENV SUPERSET_HOME=/app/superset_home
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV SUPERSET_LOAD_EXAMPLES=False
ENV SUPERSET_SECRET_KEY="jA4qkvIMzFBtT8uaFASnrS3nftBqn315VHl8FOpIKaY7EiRJmIe"

ENV SUPERSET_ADMIN_USERNAME=guest
ENV SUPERSET_ADMIN_FIRST_NAME=Guest
ENV SUPERSET_ADMIN_LAST_NAME=User
ENV SUPERSET_ADMIN_EMAIL=guest@example.com
ENV SUPERSET_ADMIN_PASSWORD=guest

CMD ["sh", "-c", "superset db upgrade && superset fab create-admin --username $SUPERSET_ADMIN_USERNAME --firstname $SUPERSET_ADMIN_FIRST_NAME --lastname $SUPERSET_ADMIN_LAST_NAME --email $SUPERSET_ADMIN_EMAIL --password $SUPERSET_ADMIN_PASSWORD && superset init && superset run -p 8088 -h 0.0.0.0"]
