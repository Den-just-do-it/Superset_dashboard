FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app


COPY requirements.txt .
COPY superset_config.py .
COPY superset_home ./superset_home
COPY data ./data

RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /app/superset_home/uploads

EXPOSE 8088

ENV SUPERSET_HOME=/app/superset_home
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV FLASK_APP=superset

CMD ["sh", "-c", "superset db upgrade && superset init && superset run -p 8088 -h 0.0.0.0"]
