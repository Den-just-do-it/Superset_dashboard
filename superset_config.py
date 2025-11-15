# -*- coding: utf-8 -*-
SECRET_KEY = "supersecretkey"

# База Superset (локальная, для metadata)
SQLALCHEMY_DATABASE_URI = "sqlite:////app/superset_home/superset.db"

# Пути
SUPERSET_HOME = "/app/superset_home"
DATA_DIR = SUPERSET_HOME
UPLOAD_FOLDER = f"{DATA_DIR}/uploads"
MAX_CONTENT_LENGTH = 100 * 1024 * 1024

from flask_appbuilder.security.manager import AUTH_DB
AUTH_TYPE = AUTH_DB
AUTH_USER_REGISTRATION = True
AUTH_ROLE_PUBLIC = "Public"
AUTH_USER_REGISTRATION_ROLE = AUTH_ROLE_PUBLIC

INITIAL_ADMIN_USER = {
    "username": "guest",
    "password": "guest",
    "first_name": "Guest",
    "last_name": "User",
    "email": "guest@example.com",
    "roles": ["Admin"]
}

DATABASES = {
    "clickhouse_retail": {
        "SQLALCHEMY_URI": "clickhouse+connect://default:@localhost:8123/retail",
        "EXTRA": {}
    }
}

DEBUG = True
