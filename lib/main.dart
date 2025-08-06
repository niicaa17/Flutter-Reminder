import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/riwayat_page.dart';
import 'pages/profil_page.dart';

void main() {
  runApp(WaterReminderApp());
}

class WaterReminderApp extends StatefulWidget {
  @override
  State<WaterReminderApp> createState() => _WaterReminderAppState();
}

class _WaterReminderAppState extends State<WaterReminderApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    RiwayatPage(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Reminder App',
      theme: ThemeData.dark(), // bisa custom nanti
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Colors.blueAccent,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Riwayat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
