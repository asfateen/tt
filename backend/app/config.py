import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    FIREBASE_DATABASE_URL = "https://batee5-5fd11-default-rtdb.firebaseio.com/"
    FIREBASE_CREDENTIALS_PATH = os.getenv("FIREBASE_CREDENTIALS_PATH")
