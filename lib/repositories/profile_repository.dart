import 'dart:convert';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  Future<Map<String, dynamic>> editName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await ApiService.put('/profile/name', {'name': name});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response dari API (edit name): $data'); // Debug log
      await prefs.setString('name', name); // Simpan nama baru
      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mengedit nama');
    }
  }

  Future<Map<String, dynamic>> editEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await ApiService.put('/profile/email', {'email': email});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response dari API (edit email): $data'); // Debug log
      await prefs.setString('email', email); // Simpan email baru
      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mengedit email');
    }
  }

  Future<Map<String, dynamic>> editPassword(
      String currentPassword, String newPassword) async {
    final response = await ApiService.put('/profile/password', {
      'current_password': currentPassword,
      'new_password': newPassword,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response dari API (edit password): $data'); // Debug log
      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mengedit password');
    }
  }
}
