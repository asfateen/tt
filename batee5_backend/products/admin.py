from django.contrib import admin
from .models import Product, Favorite

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['title', 'price', 'location', 'date_listed', 'seller']
    search_fields = ['title', 'description']
    list_filter = ['date_listed', 'location']

@admin.register(Favorite)
class FavoriteAdmin(admin.ModelAdmin):
    list_display = ['user', 'product', 'date_added']