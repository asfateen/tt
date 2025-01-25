import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:5000/api'; // Change for production

  Future<Map<String, dynamic>> register(String email, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'OTP sent successfully'};
      } else {
        final error = jsonDecode(response.body)['error'];
        return {'success': false, 'message': error};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final error = jsonDecode(response.body)['error'];
        return {'success': false, 'message': error};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> resendOTP(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final error = jsonDecode(response.body)['error'];
        return {'success': false, 'message': error};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> setPassword(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/set-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final error = jsonDecode(response.body)['error'];
        return {'success': false, 'message': error};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }
}