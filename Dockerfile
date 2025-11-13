FROM apache/superset:5.0.0

COPY superset_config.py /app/pythonpath/

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8088

CMD ["superset", "run", "-h", "0.0.0.0", "-p", "8088", "--with-threads", "--reload", "--debugger"]
