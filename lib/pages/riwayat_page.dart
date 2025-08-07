import 'package:flutter/material.dart';
import '../models/water_log.dart';
import '../repositories/water_log_repository.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  void _showEditLogDialog(BuildContext context, WaterLog log) {
    final TextEditingController amountController =
        TextEditingController(text: log.amount.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.edit, color: Color(0xFF1976D2)),
            const SizedBox(width: 8),
            const Text(
              "Edit Log Air",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ubah jumlah air yang diminum:",
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah (ml)',
                prefixIcon:
                    const Icon(Icons.local_drink, color: Color(0xFF1976D2)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF1976D2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF1976D2), width: 2),
                ),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.save,
                size: 18, color: Color.fromARGB(255, 255, 255, 255)),
            label: const Text('Simpan',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
            onPressed: () async {
              final input = amountController.text.trim();
              if (input.isNotEmpty) {
                try {
                  final amount = int.parse(input);
                  await WaterLogRepository().editWaterLog(log.id, amount);
                  setState(() {
                    waterLogs = WaterLogRepository().getWaterLogs();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Log berhasil diedit")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Gagal mengedit log: ${e.toString()}")),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

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
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: mainBlue.withOpacity(0.15),
                        child: const Icon(Icons.local_drink,
                            color: Color(0xFF1976D2)),
                      ),
                      title: Text(
                        '${log.amount} ml',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Dicatat: ${time.format(context)}',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              backgroundColor: Colors.white,
                              title: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded,
                                      color: Colors.redAccent),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Konfirmasi Hapus',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Yakin ingin menghapus log ini?',
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 15),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Batal',
                                      style: TextStyle(color: Colors.black54)),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white, size: 18),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  label: const Text('Hapus',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await WaterLogRepository().deleteWaterLog(log.id);
                              setState(() {
                                logs.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Log berhasil dihapus')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Gagal menghapus log: ${e.toString()}')),
                              );
                            }
                          }
                        },
                      ),
                      onTap: () {
                        _showEditLogDialog(context, log);
                      },
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
