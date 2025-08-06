import 'package:flutter/material.dart';
import '../models/water_log.dart';
import '../repositories/water_log_repository.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  late Future<List<WaterLog>> waterLogs;

  @override
  void initState() {
    super.initState();
    waterLogs = WaterLogRepository().getWaterLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Minum Air')),
      body: FutureBuilder<List<WaterLog>>(
        future: waterLogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final logs = snapshot.data!;

          if (logs.isEmpty) {
            return const Center(child: Text('Belum ada log minum air.'));
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                title: Text('${log.amount} ml'),
                subtitle: Text(
                  'Dicatat: ${log.loggedAt.toLocal()}',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
