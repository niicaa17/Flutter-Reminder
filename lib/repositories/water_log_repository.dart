import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/water_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class WaterLogRepository {
  final String baseUrl = ApiService.baseUrl;

  Future<List<WaterLog>> getWaterLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/waterlogs/all'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => WaterLog.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil waterlogs');
    }
  }

  Future<List<WaterLog>> fetchWaterLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/waterlogs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => WaterLog.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil waterlogs');
    }
  }

  Future<WaterProgress> fetchWaterProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/waterlogs/today/progress'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return WaterProgress.fromJson(data);
    } else {
      throw Exception('Gagal mengambil waterlogs');
    }
  }

  Future<void> addWaterLog(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/waterlogs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan log');
    }
  }

  Future<void> updateDailyTarget(int target) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('$baseUrl/profile/daily-target'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'daily_target': target,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Target berhasil diubah: ${data['daily_target']}');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mengubah target');
    }
  }

  //tambahin function untuk delete water log
  Future<void> deleteWaterLog(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$baseUrl/waterlogs/delete/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus water log');
    }
  }

  // tambahkan function untuk edit water log
  Future<void> editWaterLog(int id, int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/waterlogs/edit/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengedit water log');
    }
  }
}
