import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:5000',
  );
  
  // Endpoints
  static const String categories = '/categories';
  static const String products = '/products';
  
  static String productByCategory(String category) => '/products/$category';
  static String productById(String category, String productId) => '/products/$category/$productId';
  static String toggleFavorite(String category, String productId) => '/products/$category/$productId/favorite';
} 
