import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000/api';
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }

  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> data) {
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> get(String endpoint) {
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
    );
  }
}
