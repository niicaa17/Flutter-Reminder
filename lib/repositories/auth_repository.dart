import 'dart:convert';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiService.post('/login', {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response dari API (login): $data'); // Debug log

      // Ganti key ini sesuai dengan struktur respons backend kamu
      final token = data['token'] ?? data['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      if (token != null) {
        ApiService.setToken(token);
        return data;
      } else {
        throw Exception('Token tidak ditemukan dalam response: $data');
      }
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login gagal');
    }
  }
}
