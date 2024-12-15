from flask import Flask, jsonify
from flask_cors import CORS
from app.routes import categories, products, test

def create_app():
    app = Flask(__name__)
    
    # Development CORS setup - DO NOT USE IN PRODUCTION!
    CORS(app, 
         resources={r"/*": {"origins": "*"}},
         supports_credentials=True,
         allow_headers=["Content-Type", "Authorization"],
         methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"])

    @app.route('/api/health', methods=['GET'])
    def health_check():
        return jsonify({"status": "healthy"})

    # Register blueprints
    app.register_blueprint(categories.bp)
    app.register_blueprint(products.bp)
    app.register_blueprint(test.bp)

    return app