from flask import Blueprint, jsonify, request
from app.models import Product
from app import db

main = Blueprint('main', __name__)

@main.route('/api/products', methods=['GET'])
def get_products():
    products = Product.query.all()
    return jsonify([product.to_dict() for product in products])

@main.route('/api/products/<int:id>', methods=['GET'])
def get_product(id):
    product = Product.query.get_or_404(id)
    return jsonify(product.to_dict())

@main.route('/api/products', methods=['POST'])
def create_product():
    data = request.json
    
    product = Product(
        title=data['title'],
        description=data['description'],
        price=data['price'],
        location=data.get('location'),
        image_url=data.get('imageUrl'),
        is_favorite=data.get('isFavorite', False),
        number_of_bedrooms=data.get('numberOfBedrooms'),
        number_of_bathrooms=data.get('numberOfBathrooms'),
        area=data.get('area')
    )
    
    db.session.add(product)
    db.session.commit()
    
    return jsonify(product.to_dict()), 201

@main.route('/api/products/<int:id>/favorite', methods=['POST'])
def toggle_favorite(id):
    product = Product.query.get_or_404(id)
    product.is_favorite = not product.is_favorite
    db.session.commit()
    return jsonify(product.to_dict())