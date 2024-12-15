from flask import Flask
from flask_cors import CORS
from app.routes import categories, products, test

def create_app():
    app = Flask(__name__)
    CORS(app, resources={
        r"/api/*": {
            "origins": ["*"],  # In production, replace with your Flutter app's domain
            "methods": ["GET", "POST", "PUT", "DELETE"],
            "allow_headers": ["Content-Type"]
        }
    })

    # Register blueprints
    app.register_blueprint(categories.bp)
    app.register_blueprint(products.bp)
    app.register_blueprint(test.bp)

    return app
