import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.person, size: 100),
          SizedBox(height: 16),
          Text("Nama Pengguna", style: TextStyle(fontSize: 20)),
          SizedBox(height: 32),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Ubah Target Minum Harian"),
            onTap: () {
              // nanti trigger dialog atau page ubah target
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              // logout logic
            },
          )
        ],
      ),
    );
  }
}
