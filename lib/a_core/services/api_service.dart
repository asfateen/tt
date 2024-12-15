import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:batee5/a_core/constants/api_constants.dart';
import 'package:batee5/a_core/models/category.dart' as models;
import 'package:batee5/a_core/models/product.dart';

class ApiService {
  final http.Client _client = http.Client();

  Future<Map<String, Product>> getAllProducts() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}');
    final response = await _client.get(uri);
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Map<String, Product> products = {};
      
      data.forEach((key, value) {
        try {
          products[key] = Product.fromJson(key, value as Map<String, dynamic>);
        } catch (e) {
          debugPrint('Error parsing product $key: $e');
        }
      });
      
      return products;
    }
    throw Exception('Failed to load products');
  }

  Future<Map<String, Product>> getProductsByCategory(String category) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}?category=$category');
    final response = await _client.get(uri);
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Map<String, Product> products = {};
      
      data.forEach((key, value) {
        try {
          products[key] = Product.fromJson(key, value as Map<String, dynamic>);
        } catch (e) {
          debugPrint('Error parsing product $key: $e');
        }
      });
      
      return products;
    }
    throw Exception('Failed to load products');
  }

  Future<bool> toggleFavorite(String category, String productId) async {
    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.toggleFavorite(category, productId)}'),
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['isFavorite'] as bool;
    }
    throw Exception('Failed to toggle favorite');
  }
}
