import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

class ApiConstants {
  // Production backend URL
  static const String baseUrl = 'https://batee5-backend-production.up.railway.app';
  
  // Endpoints
  static const String categories = '/categories';
  static const String products = '/products';
  
  static String productById(String productId) => '/products/$productId';
  static String toggleFavorite(String productId) => '/products/$productId/favorite';
} 
