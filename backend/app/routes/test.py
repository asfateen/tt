from flask import Blueprint, jsonify
from app.services.firebase_service import FirebaseService

bp = Blueprint('test', __name__, url_prefix='/api/test')
firebase_service = FirebaseService()

@bp.route('/connection', methods=['GET'])
def test_connection():
    try:
        # Try to access Firebase
        firebase_service.db.get()
        return jsonify({
            "status": "success",
            "message": "Successfully connected to Firebase",
            "backend_status": "running"
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e),
            "backend_status": "running"
        }), 500