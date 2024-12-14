from app import create_app, db

app = create_app()

def init_db():
    with app.app_context():
        db.create_all()
        
        # Add sample products if database is empty
        if not Product.query.first():
            sample_products = [
                Product(
                    title='Modern Apartment',
                    description='Beautiful modern apartment in downtown',
                    price=500000,
                    location='Cairo, Egypt',
                    image_url='assets/images/apartment1.jpg',
                    number_of_bedrooms=2,
                    number_of_bathrooms=2,
                    area=120
                ),
                Product(
                    title='Luxury Villa',
                    description='Spacious villa with garden',
                    price=1200000,
                    location='Alexandria, Egypt',
                    image_url='assets/images/villa1.jpg',
                    number_of_bedrooms=4,
                    number_of_bathrooms=3,
                    area=350
                ),
                Product(
                    title='Kataketo Chocolate',
                    description='Best chocolate in egypt',
                    price=15,
                    location='Cairo, Egypt',
                    image_url='assets/images/kataketo.jpeg'
                )
            ]
            
            for product in sample_products:
                db.session.add(product)
            db.session.commit()

if __name__ == '__main__':
    init_db()
    app.run(debug=True)