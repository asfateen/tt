from flask import Flask, jsonify, request
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

    @app.before_request
    def log_request_info():
        print('Headers:', dict(request.headers))
        print('Method:', request.method)
        print('URL:', request.url)

    @app.after_request
    def after_request(response):
        response.headers.add('Access-Control-Allow-Origin', '*')
        response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
        response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
        print('Response Status:', response.status)
        print('Response Headers:', dict(response.headers))
        return response

    @app.route('/api/health', methods=['GET'])
    def health_check():
        return jsonify({"status": "healthy"})

    # Register blueprints
    app.register_blueprint(categories.bp)
    app.register_blueprint(products.bp)
    app.register_blueprint(test.bp)

    return app