import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConnectionTestWidget extends StatefulWidget {
  const ConnectionTestWidget({Key? key}) : super(key: key);

  @override
  State<ConnectionTestWidget> createState() => _ConnectionTestWidgetState();
}

class _ConnectionTestWidgetState extends State<ConnectionTestWidget> {
  String _status = 'Not tested';
  bool _isLoading = false;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing...';
    });

    try {
      // First try the health check
      final healthResponse = await http.get(
        Uri.parse('http://localhost:5000/api/health'),
      );
      
      if (healthResponse.statusCode != 200) {
        throw Exception('Health check failed: ${healthResponse.statusCode}');
      }

      // Then try the test connection
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/test/connection'),
      );

      if (response.statusCode != 200) {
        throw Exception('Test failed: ${response.statusCode}\n${response.body}');
      }

      final data = json.decode(response.body);
      setState(() {
        _status = 'Backend: ${data['backend_status']}\n'
            'Message: ${data['message']}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error Details:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Connection Status: $_status'),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _testConnection,
                    child: const Text('Test Connection'),
                  ),
          ],
        ),
      ),
    );
  }
}