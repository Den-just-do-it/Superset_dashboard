# -*- coding: utf-8 -*-
import os

SQLALCHEMY_DATABASE_URI = os.environ.get(
    'SUPERSET_DATABASE_URI',
    'clickhouse+connect://default:PASSWORD@HOST:8123/retail'
)

SECRET_KEY = os.environ.get('SUPERSET_SECRET_KEY', 'change_this_to_a_random_string')

ADMIN_USERNAME = os.environ.get('SUPERSET_ADMIN_USERNAME', 'admin')
ADMIN_PASSWORD = os.environ.get('SUPERSET_ADMIN_PASSWORD', 'admin')

UPLOAD_FOLDER = '/app/uploads'
IMG_UPLOAD_FOLDER = '/app/uploads/images'

# CACHE_CONFIG = {
#     'CACHE_TYPE': 'RedisCache',
#     'CACHE_DEFAULT_TIMEOUT': 300,
#     'CACHE_KEY_PREFIX': 'superset_',
#     'CACHE_REDIS_URL': 'redis://redis:6379/0',
# }

