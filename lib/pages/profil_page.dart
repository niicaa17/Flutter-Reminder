import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/repositories/water_log_repository.dart';

class ProfilPage extends StatefulWidget {
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String? userName = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Nama tidak ditemukan';
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');

    // Pindah ke halaman login dan hapus semua halaman sebelumnya
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Logout"),
          content: Text("Yakin mau logout?"),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop(); // tutup dialog
                _logout(context); // eksekusi logout
              },
            ),
          ],
        );
      },
    );
  }

  void _ubahTargetMinum(BuildContext context) {
    final _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ubah Target Harian"),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "Masukkan target (ml)"),
        ),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Simpan"),
            onPressed: () async {
              final newTarget = int.tryParse(_controller.text);
              if (newTarget == null || newTarget <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Input tidak valid")),
                );
                return;
              }

              // Tutup dialog

              try {
                await WaterLogRepository().updateDailyTarget(newTarget);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Target berhasil diubah")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal: ${e.toString()}")),
                );
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.person, size: 100),
          SizedBox(height: 16),
          Text(userName ?? "Nama Pengguna", style: TextStyle(fontSize: 20)),
          SizedBox(height: 32),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Ubah Target Minum Harian"),
            onTap: () {
              _ubahTargetMinum(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              _showLogoutConfirmation(context);
            },
          )
        ],
      ),
    );
  }
}
