from flask import Blueprint, jsonify
from app.services.firebase_service import FirebaseService

bp = Blueprint('test', __name__, url_prefix='/api/test')
firebase_service = FirebaseService()

@bp.route('/connection', methods=['GET'])
def test_connection():
    try:
        return jsonify({
            "status": "success",
            "message": "Backend connection successful",
            "backend_status": "running"
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e),
            "backend_status": "error",
            "error_details": str(e)
        }), 500

@bp.route('/health', methods=['GET'])
def health_check():
    return {'status': 'success', 'message': 'Server is running'}, 200