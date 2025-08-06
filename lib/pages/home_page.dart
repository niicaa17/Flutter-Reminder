import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, Selamat Datang! 👋', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("Target Harian", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text("2500 ml",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    LinearProgressIndicator(value: 0.4),
                    SizedBox(height: 8),
                    Text("1000 ml / 2500 ml")
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text("Log Hari Ini",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // dummy
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Minum 250ml"),
                    subtitle: Text("08:00"),
                    leading: Icon(Icons.local_drink),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
