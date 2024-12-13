import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  // For Android Emulator
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  // For iOS Simulator
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  final String? authToken;

  ProductService({this.authToken});

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Product> getProduct(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id/'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Product> createProduct(Product product, File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/products/'),
    );

    // Add auth header
    if (authToken != null) {
      request.headers['Authorization'] = 'Bearer $authToken';
    }

    // Add product data
    request.fields.addAll(product.toJson().map(
          (key, value) => MapEntry(key, value.toString()),
        ));

    // Add image file
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(responseData));
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<void> toggleFavorite(int productId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/$productId/toggle_favorite/'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle favorite');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$productId/'),
      headers: _headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }
}