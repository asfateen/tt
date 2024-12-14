from datetime import datetime
from app import db

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    price = db.Column(db.Float, nullable=False)
    location = db.Column(db.String(100))
    image_url = db.Column(db.String(500))
    date_listed = db.Column(db.DateTime, default=datetime.utcnow)
    is_favorite = db.Column(db.Boolean, default=False)
    number_of_bedrooms = db.Column(db.Integer)
    number_of_bathrooms = db.Column(db.Integer)
    area = db.Column(db.Integer)

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'description': self.description,
            'price': self.price,
            'location': self.location,
            'imageUrl': self.image_url,
            'dateListed': self.date_listed.isoformat(),
            'isFavorite': self.is_favorite,
            'numberOfBedrooms': self.number_of_bedrooms,
            'numberOfBathrooms': self.number_of_bathrooms,
            'area': self.area
        }