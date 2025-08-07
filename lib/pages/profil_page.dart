import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/repositories/water_log_repository.dart';
import '../repositories/profile_repository.dart';

class ProfilPage extends StatefulWidget {
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final Color mainBlue = const Color(0xFF1976D2);
  final Color lightBlue = const Color(0xFF90CAF9);
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Icon(Icons.logout, color: mainBlue),
              const SizedBox(width: 8),
              const Text("Konfirmasi Logout"),
            ],
          ),
          content: const Text("Yakin mau logout?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: mainBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(Icons.flag, color: mainBlue),
            const SizedBox(width: 8),
            const Text("Ubah Target Harian"),
          ],
        ),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Masukkan target (ml)",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainBlue, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Simpan"),
            onPressed: () async {
              final newTarget = int.tryParse(_controller.text);
              if (newTarget == null || newTarget <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Input tidak valid")),
                );
                return;
              }
              try {
                await WaterLogRepository().updateDailyTarget(newTarget);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Target berhasil diubah")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal: " + e.toString())),
                );
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _ubahNama(BuildContext context) {
    final _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(Icons.person_outline, color: mainBlue),
            const SizedBox(width: 8),
            const Text("Ubah Nama"),
          ],
        ),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: "Nama baru",
            hintText: "Masukkan nama baru",
            icon: Icon(Icons.person_outline, color: mainBlue),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainBlue, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final name = _controller.text.trim();
              if (name.isEmpty) return;
              try {
                await ProfileRepository().editName(name);
                await _loadUserName();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Nama berhasil diubah")),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal: ${e.toString()}")),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _ubahEmail(BuildContext context) {
    final _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(Icons.email_outlined, color: mainBlue),
            const SizedBox(width: 8),
            const Text("Ubah Email"),
          ],
        ),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email baru",
            hintText: "Masukkan email baru",
            icon: Icon(Icons.email_outlined, color: mainBlue),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainBlue, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final email = _controller.text.trim();
              if (!email.contains('@')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Format email tidak valid")),
                );
                return;
              }
              try {
                await ProfileRepository().editEmail(email);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Email berhasil diubah")),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal: ${e.toString()}")),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _ubahPassword(BuildContext context) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: mainBlue),
            const SizedBox(width: 8),
            const Text("Ubah Password"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password saat ini",
                hintText: "Masukkan password saat ini",
                icon: Icon(Icons.lock_outline, color: mainBlue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainBlue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password baru",
                hintText: "Masukkan password baru",
                icon: Icon(Icons.lock, color: mainBlue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainBlue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final current = currentController.text;
              final newPass = newController.text;

              if (newPass.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Password baru minimal 6 karakter")),
                );
                return;
              }

              try {
                await ProfileRepository().editPassword(current, newPass);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password berhasil diubah")),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal: ${e.toString()}")),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [mainBlue, lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: mainBlue.withOpacity(0.1),
                        child: const Icon(Icons.person,
                            size: 54, color: Color(0xFF1976D2)),
                      ),
                      const SizedBox(height: 16),
                      Text(userName ?? "Nama Pengguna",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Card(
                color: Colors.white.withOpacity(0.95),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.edit, color: mainBlue),
                      title: const Text("Ubah Target Minum Harian",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        _ubahTargetMinum(context);
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.person_outline, color: mainBlue),
                      title: const Text("Ubah Nama",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () => _ubahNama(context),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.email_outlined, color: mainBlue),
                      title: const Text("Ubah Email",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () => _ubahEmail(context),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.lock_outline, color: mainBlue),
                      title: const Text("Ubah Password",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () => _ubahPassword(context),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.redAccent),
                      title: const Text("Logout",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        _showLogoutConfirmation(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
