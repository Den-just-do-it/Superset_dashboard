FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mkdir -p /app/superset_home

COPY requirements.txt .
COPY superset_config.py .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8088

ENV FLASK_APP=superset
ENV SUPERSET_HOME=/app/superset_home

CMD ["sh", "-c", "superset db upgrade && superset init && superset run -p 8088 -h 0.0.0.0"]
