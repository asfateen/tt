from flask import Blueprint, jsonify
from app.services.firebase_service import FirebaseService

bp = Blueprint('categories', __name__, url_prefix='/api/categories')
firebase_service = FirebaseService()

@bp.route('/', methods=['GET'])
def get_categories():
    categories = firebase_service.get_categories()
    return jsonify(categories)

@bp.route('/<category_id>', methods=['GET'])
def get_category(category_id):
    category = firebase_service.get_category(category_id)
    if category:
        return jsonify(category)
    return jsonify({'error': 'Category not found'}), 404
