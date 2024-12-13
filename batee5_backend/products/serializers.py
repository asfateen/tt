from rest_framework import serializers
from .models import Product, Favorite

class ProductSerializer(serializers.ModelSerializer):
    is_favorite = serializers.SerializerMethodField()
    
    class Meta:
        model = Product
        fields = ['id', 'title', 'description', 'price', 'location', 
                 'date_listed', 'image', 'seller', 'number_of_bedrooms',
                 'number_of_bathrooms', 'area', 'is_favorite']

    def get_is_favorite(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return Favorite.objects.filter(
                user=request.user, 
                product=obj
            ).exists()
        return False