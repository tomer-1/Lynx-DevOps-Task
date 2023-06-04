import os

DB_URI = os.getenv("DB_URI", "sqlite:///data.db")
PORT = os.getenv("PORT", 8000)
