import firebase_admin
from firebase_admin import credentials, db
from app.config import Config

class FirebaseService:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(FirebaseService, cls).__new__(cls)
            cls._instance._initialize()
        return cls._instance

    def _initialize(self):
        cred = credentials.Certificate(Config.FIREBASE_CREDENTIALS)
        firebase_admin.initialize_app(cred, {
            'databaseURL': Config.FIREBASE_DATABASE_URL
        })
        self.db = db.reference()

    def get_categories(self):
        return self.db.child('categories').get()

    def get_category(self, category_id):
        return self.db.child('categories').child(category_id).get()

    def get_products(self, category=None):
        if category:
            return self.db.child('products').child(category).get()
        return self.db.child('products').get()

    def get_product(self, category, product_id):
        return self.db.child('products').child(category).child(product_id).get()

    def create_product(self, category, product_data):
        new_product_ref = self.db.child('products').child(category).push()
        new_product_ref.set(product_data)
        return new_product_ref.key

    def update_product(self, category, product_id, product_data):
        self.db.child('products').child(category).child(product_id).update(product_data)
        return True

    def delete_product(self, category, product_id):
        self.db.child('products').child(category).child(product_id).delete()
        return True
