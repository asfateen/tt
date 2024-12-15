import os
import json
import firebase_admin
from firebase_admin import credentials, db
from dotenv import load_dotenv

load_dotenv()

class FirebaseService:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(FirebaseService, cls).__new__(cls)
            cls._instance._initialize()
        return cls._instance

    def _initialize(self):
        if not firebase_admin._apps:
            try:
                cred_dict = json.loads(os.getenv('FIREBASE_CREDENTIALS'))
                cred = credentials.Certificate(cred_dict)
                firebase_admin.initialize_app(cred, {
                    'databaseURL': 'https://batee5-5fd11-default-rtdb.firebaseio.com/'
                })
                self.db = db.reference()
                self._ensure_test_data()
            except Exception as e:
                print(f"Firebase initialization error: {str(e)}")
                raise

    def _ensure_test_data(self):
        """Ensure some test data exists in the database"""
        try:
            products_ref = self.db.child('products')
            existing_products = products_ref.get()
            
            if not existing_products:
                test_data = {
                    'electronics': {
                        'product1': {
                            'name': 'Test Product 1',
                            'price': 99.99,
                            'description': 'This is a test product',
                            'category': 'electronics'
                        }
                    },
                    'clothing': {
                        'product2': {
                            'name': 'Test Product 2',
                            'price': 49.99,
                            'description': 'This is another test product',
                            'category': 'clothing'
                        }
                    }
                }
                products_ref.set(test_data)
                print("Test data initialized in Firebase")
            else:
                print("Existing data found in Firebase")
                
        except Exception as e:
            print(f"Error ensuring test data: {str(e)}")

    def get_products(self, category=None):
        try:
            products_ref = self.db.child('products')
            if category:
                products = products_ref.child(category).get()
            else:
                products = products_ref.get()
            
            if products is None:
                print("No products found in Firebase")
                return []
                
            print(f"Retrieved products from Firebase: {products}")
            return products
            
        except Exception as e:
            print(f"Error getting products: {str(e)}")
            raise

    def get_product(self, category, product_id):
        try:
            return self.db.child('products').child(category).child(product_id).get()
        except Exception as e:
            print(f"Error getting product: {str(e)}")
            raise

    def get_categories(self):
        return self.db.child('categories').get()

    def get_category(self, category_id):
        return self.db.child('categories').child(category_id).get()

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
