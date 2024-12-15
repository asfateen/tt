from flask import Blueprint, jsonify
from flask_cors import CORS
from app.services.firebase_service import FirebaseService

bp = Blueprint('test', __name__)
CORS(bp)
firebase_service = FirebaseService()

@bp.route('/api/health', methods=['GET'])
def health_check():
    response = jsonify({
        'status': 'success',
        'message': 'Server is running'
    })
    response.headers.add('Access-Control-Allow-Origin', '*')
    return response

@bp.route('/api/test/connection', methods=['GET'])
def test_connection():
    try:
        response = jsonify({
            "status": "success",
            "message": "Backend connection successful",
            "backend_status": "running"
        })
        response.headers.add('Access-Control-Allow-Origin', '*')
        return response
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500