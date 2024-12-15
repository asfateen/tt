import os
from dotenv import load_dotenv
import json

load_dotenv()

class Config:
    FIREBASE_DATABASE_URL = "https://batee5-5fd11-default-rtdb.firebaseio.com/"
    FIREBASE_CREDENTIALS = json.loads(os.getenv('FIREBASE_CREDENTIALS', '{}'))