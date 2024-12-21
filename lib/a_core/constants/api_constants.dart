import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

class ApiConstants {
  static String get baseUrl {
    // Get the current URL in web, or the environment variable in mobile
    final currentUrl = Uri.base.toString();
    
    // If we're running on Railway or production domain
    if (currentUrl.contains('railway.app')) {
      return 'https://batee5-backend-production.up.railway.app';
    }
    
    // Local development
    return 'http://localhost:5000';
  }
  
  // Endpoints
  static const String categories = '/categories';
  static const String products = '/products';
  
  static String productByCategory(String category) => '/products/$category';
  static String productById(String category, String productId) => '/products/$category/$productId';
  static String toggleFavorite(String category, String productId) => '/products/$category/$productId/favorite';
} 
