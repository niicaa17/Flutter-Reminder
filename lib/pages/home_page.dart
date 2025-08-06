import 'package:flutter/material.dart';
import '../models/water_log.dart';
import '../repositories/water_log_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<WaterLog>> waterLogs;
  late Future<WaterProgress> waterProgress;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    waterLogs = WaterLogRepository().fetchWaterLogs();
    waterProgress = WaterLogRepository().fetchWaterProgress();
    setState(() {
      isLoading = false;
    });
  }

  void _showAddLogDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Log Air"),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Jumlah (ml)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final input = amountController.text.trim();
              if (input.isNotEmpty) {
                try {
                  final amount = int.parse(input);
                  await WaterLogRepository().addWaterLog(amount);

                  // Refresh data
                  setState(() {
                    waterLogs = WaterLogRepository().fetchWaterLogs();
                    waterProgress = WaterLogRepository().fetchWaterProgress();
                  });

                  // Tutup dialog
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gagal menambahkan log")),
                  );
                }
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : (waterProgress == null)
                ? const Center(child: Text('Data tidak tersedia'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Halo, Selamat Datang! 👋',
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 16),
                      FutureBuilder<WaterProgress>(
                        future: waterProgress,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Gagal memuat data'));
                          } else if (!snapshot.hasData) {
                            return const Center(
                                child: Text('Data tidak tersedia'));
                          }
                          final progress = snapshot.data!;
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const Text("Target Harian",
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text("${progress.dailyTargetMl} ml",
                                      style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),
                                  LinearProgressIndicator(
                                      value:
                                          (progress.progressPercentage / 100)),
                                  const SizedBox(height: 8),
                                  Text(
                                      "${progress.totalConsumptionMl} ml / ${progress.dailyTargetMl} ml")
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text("Log Hari Ini",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _showAddLogDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text("Tambah Log"),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: FutureBuilder<List<WaterLog>>(
                          future: waterLogs,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Gagal memuat log'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('Belum ada log hari ini'));
                            }
                            final logs = snapshot.data!;
                            return ListView.builder(
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                final log = logs[index];
                                final time =
                                    TimeOfDay.fromDateTime(log.loggedAt);
                                return ListTile(
                                  title: Text("Minum ${log.amount}ml"),
                                  subtitle: Text("${time.format(context)}"),
                                  leading: const Icon(Icons.local_drink),
                                );
                              },
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
