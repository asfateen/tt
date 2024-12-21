import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

class ApiConstants {
  static late String baseUrl;
  
  static Future<void> initialize() async {
    if (kIsWeb) {
      final response = await http.get(Uri.parse('/config.json'));
      final config = json.decode(response.body);
      
      // Check if we're in production based on the URL
      final isProduction = window.location.hostname.contains('railway.app');
      baseUrl = isProduction ? config['production']['apiUrl'] : config['development']['apiUrl'];
    } else {
      baseUrl = const String.fromEnvironment(
        'API_URL',
        defaultValue: 'http://localhost:5000',
      );
    }
  }
  
  // Endpoints
  static const String categories = '/categories';
  static const String products = '/products';
  
  static String productByCategory(String category) => '/products/$category';
  static String productById(String category, String productId) => '/products/$category/$productId';
  static String toggleFavorite(String category, String productId) => '/products/$category/$productId/favorite';
} 
