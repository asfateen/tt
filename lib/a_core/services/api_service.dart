import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/product.dart';

class ApiService {
  final http.Client _client = http.Client();
  static const String baseUrl = 'http://localhost:5000/api';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<List<Product>> getProducts({String? category}) async {
    try {
      final uri = Uri.parse('http://localhost:5000/api/products')
          .replace(queryParameters: category != null ? {'category': category} : null);
          
      final response = await _client.get(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> data = responseData['data'];
        
        List<Product> products = [];
        
        data.forEach((category, categoryProducts) {
          (categoryProducts as Map<String, dynamic>).forEach((productId, productData) {
            products.add(Product.fromJson({
              'id': productId,
              ...productData as Map<String, dynamic>
            }));
          });
        });
        
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<bool> testConnection() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/health'),
        headers: _headers,
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error in testConnection: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categories}'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<Map<String, dynamic>> getProduct(String category, String productId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}/$category/$productId'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}