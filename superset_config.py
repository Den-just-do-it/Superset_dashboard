SECRET_KEY = "jA4qkvIMzFBtT8uaFASnrS3nftBqn315VHl8FOpIKaY7EiRJmIe"

SQLALCHEMY_DATABASE_URI = "sqlite:////app/superset_home/superset.db" 
DATA_DIR = "/app/superset_home"
UPLOAD_FOLDER = f"{DATA_DIR}/uploads"
MAX_CONTENT_LENGTH = 100 * 1024 * 1024
DEBUG = True

from flask_appbuilder.security.manager import AUTH_DB

AUTH_TYPE = AUTH_DB                
AUTH_ROLE_PUBLIC = 'Gamma'        
AUTH_USER_REGISTRATION = True    
AUTH_USER_REGISTRATION_ROLE = AUTH_ROLE_PUBLIC

INITIAL_ADMIN_USER = {
    "username": "guest",
    "password": "guest",
    "first_name": "Guest",
    "last_name": "User",
    "email": "guest@example.com",
    "roles": ["Gamma"]
}
