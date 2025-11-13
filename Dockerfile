FROM python:3.10-slim


RUN apt-get update && \
    apt-get install -y build-essential libpq-dev git && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /app
COPY . /app


RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt


CMD ["superset", "run", "-p", "8088", "--with-threads", "--reload", "--debugger"]
