import 'package:flutter/material.dart';
import '../models/water_log.dart';
import '../repositories/water_log_repository.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final Color mainBlue = const Color(0xFF1976D2);
  final Color lightBlue = const Color(0xFF90CAF9);
  late Future<List<WaterLog>> waterLogs;

  @override
  void initState() {
    super.initState();
    waterLogs = WaterLogRepository().getWaterLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: mainBlue,
        elevation: 0,
        title: const Text('Riwayat Minum Air',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [mainBlue, lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 8),
          child: FutureBuilder<List<WaterLog>>(
            future: waterLogs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white)));
              }
              final logs = snapshot.data!;
              if (logs.isEmpty) {
                return const Center(
                    child: Text('Belum ada log minum air.',
                        style: TextStyle(color: Colors.white)));
              }
              return ListView.separated(
                itemCount: logs.length,
                separatorBuilder: (context, idx) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final time = TimeOfDay.fromDateTime(log.loggedAt);
                  return Card(
                    color: Colors.white.withOpacity(0.95),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: mainBlue.withOpacity(0.15),
                        child: const Icon(Icons.local_drink,
                            color: Color(0xFF1976D2)),
                      ),
                      title: Text('${log.amount} ml',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Dicatat: ${time.format(context)}',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
