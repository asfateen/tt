from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from .models import Product, Favorite
from .serializers import ProductSerializer

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(seller=self.request.user)

    @action(detail=True, methods=['POST'])
    def toggle_favorite(self, request, pk=None):
        product = self.get_object()
        favorite = Favorite.objects.filter(
            user=request.user,
            product=product
        )

        if favorite.exists():
            favorite.delete()
            return Response({'status': 'unfavorited'})
        else:
            Favorite.objects.create(user=request.user, product=product)
            return Response({'status': 'favorited'})