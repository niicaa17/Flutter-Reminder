import 'package:flutter/material.dart';
import '../models/water_log.dart';
import '../repositories/water_log_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showEditLogDialog(BuildContext context, WaterLog log) {
    final TextEditingController amountController =
        TextEditingController(text: log.amount.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.edit, color: mainBlue),
            const SizedBox(width: 8),
            const Text("Edit Log Air"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah (ml)',
                filled: true,
                fillColor: Colors.blue[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon:
                    const Icon(Icons.local_drink, color: Color(0xFF1976D2)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Waktu: ${TimeOfDay.fromDateTime(log.loggedAt).format(context)}",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: mainBlue,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 2,
            ),
            onPressed: () async {
              final input = amountController.text.trim();
              if (input.isNotEmpty) {
                try {
                  final amount = int.parse(input);
                  await WaterLogRepository().editWaterLog(log.id, amount);
                  setState(() {
                    waterLogs = WaterLogRepository().fetchWaterLogs();
                    waterProgress = WaterLogRepository().fetchWaterProgress();
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
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  late Future<List<WaterLog>> waterLogs;
  late Future<WaterProgress> waterProgress;

  bool isLoading = true;

  final Color mainBlue = const Color(0xFF1976D2);
  final Color lightBlue = const Color(0xFF90CAF9);

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.add, color: mainBlue),
            const SizedBox(width: 8),
            const Text("Tambah Log Air"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah (ml)',
                filled: true,
                fillColor: Colors.blue[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon:
                    const Icon(Icons.local_drink, color: Color(0xFF1976D2)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: mainBlue,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 2,
            ),
            onPressed: () async {
              final input = amountController.text.trim();
              if (input.isNotEmpty) {
                try {
                  final amount = int.parse(input);
                  await WaterLogRepository().addWaterLog(amount);

                  setState(() {
                    waterLogs = WaterLogRepository().fetchWaterLogs();
                    waterProgress = WaterLogRepository().fetchWaterProgress();
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Log berhasil ditambahkan")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Gagal menambahkan log: ${e.toString()}")),
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
          padding: const EdgeInsets.all(16),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.water_drop_rounded,
                              color: mainBlue, size: 36),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Halo, Selamat Datang! 👋',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text(
                              'Tetap terhidrasi hari ini!',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<WaterProgress>(
                      future: waterProgress,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 24, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.sentiment_dissatisfied,
                                      color: Colors.white, size: 40),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Kamu belum minum hari ini',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Yuk mulai minum air agar tetap sehat!',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (!snapshot.hasData) {
                          return const Center(
                              child: Text('Data tidak tersedia',
                                  style: TextStyle(color: Colors.white)));
                        }
                        final progress = snapshot.data!;
                        return Card(
                          elevation: 8,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.flag, color: mainBlue, size: 28),
                                    const SizedBox(width: 8),
                                    const Text("Target Harian",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text("${progress.dailyTargetMl} ml",
                                    style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1976D2))),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: (progress.progressPercentage / 100),
                                    minHeight: 12,
                                    backgroundColor: lightBlue.withOpacity(0.3),
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(mainBlue),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${progress.totalConsumptionMl} ml / ${progress.dailyTargetMl} ml",
                                  style: const TextStyle(color: Colors.black54),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Log Hari Ini",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: mainBlue,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _showAddLogDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text("Tambah Log"),
                        ),
                      ],
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
                                child: Text('Gagal memuat log',
                                    style: TextStyle(color: Colors.white)));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('Belum ada log hari ini',
                                    style: TextStyle(color: Colors.white)));
                          }
                          final logs = snapshot.data!;
                          return ListView.separated(
                            itemCount: logs.length,
                            separatorBuilder: (context, idx) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final log = logs[index];
                              final time = TimeOfDay.fromDateTime(log.loggedAt);

                              return Card(
                                color: Colors.white.withOpacity(0.95),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: mainBlue.withOpacity(0.15),
                                    child: const Icon(Icons.local_drink,
                                        color: Color(0xFF1976D2)),
                                  ),
                                  title: Text("Minum ${log.amount}ml",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text("${time.format(context)}",
                                      style: const TextStyle(
                                          color: Colors.black54)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                          backgroundColor: Colors.white,
                                          title: Row(
                                            children: [
                                              Icon(Icons.warning_amber_rounded,
                                                  color: Colors.redAccent),
                                              const SizedBox(width: 8),
                                              const Text('Konfirmasi Hapus',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          content: const Text(
                                            'Yakin ingin menghapus log ini?',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87),
                                          ),
                                          actions: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: mainBlue,
                                                textStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(false),
                                              child: const Text('Batal'),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.redAccent,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                elevation: 2,
                                              ),
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(true),
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        try {
                                          await WaterLogRepository()
                                              .deleteWaterLog(log.id);
                                          setState(() {
                                            waterLogs = WaterLogRepository()
                                                .fetchWaterLogs();
                                            waterProgress = WaterLogRepository()
                                                .fetchWaterProgress();
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Log berhasil dihapus')),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
