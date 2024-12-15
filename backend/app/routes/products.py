from flask import Blueprint, jsonify, request
from app.services.firebase_service import FirebaseService

bp = Blueprint('products', __name__, url_prefix='/api/products')
firebase_service = FirebaseService()

@bp.route('/', methods=['GET'])
def get_products():
    category = request.args.get('category')
    products = firebase_service.get_products(category)
    return jsonify(products)

@bp.route('/<category>/<product_id>', methods=['GET'])
def get_product(category, product_id):
    product = firebase_service.get_product(category, product_id)
    if product:
        return jsonify(product)
    return jsonify({'error': 'Product not found'}), 404

@bp.route('/<category>', methods=['POST'])
def create_product(category):
    product_data = request.json
    product_id = firebase_service.create_product(category, product_data)
    return jsonify({'id': product_id}), 201

@bp.route('/<category>/<product_id>', methods=['PUT'])
def update_product(category, product_id):
    product_data = request.json
    success = firebase_service.update_product(category, product_id, product_data)
    if success:
        return jsonify({'message': 'Product updated successfully'})
    return jsonify({'error': 'Failed to update product'}), 400

@bp.route('/<category>/<product_id>', methods=['DELETE'])
def delete_product(category, product_id):
    success = firebase_service.delete_product(category, product_id)
    if success:
        return jsonify({'message': 'Product deleted successfully'})
    return jsonify({'error': 'Failed to delete product'}), 400
