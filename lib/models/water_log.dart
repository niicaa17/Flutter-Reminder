class WaterLog {
  final int id;
  final int userId;
  final int amount;
  final DateTime loggedAt;

  WaterLog({
    required this.id,
    required this.userId,
    required this.amount,
    required this.loggedAt,
  });

  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'],
      loggedAt: DateTime.parse(json['logged_at']),
    );
  }
}

class WaterProgress {
  final String date;
  final int totalConsumptionMl;
  final int dailyTargetMl;
  final double progressPercentage;

  WaterProgress({
    required this.date,
    required this.totalConsumptionMl,
    required this.dailyTargetMl,
    required this.progressPercentage,
  });

  factory WaterProgress.fromJson(Map<String, dynamic> json) {
    return WaterProgress(
      date: json['date'],
      totalConsumptionMl: int.parse(json['total_consumption_ml']),
      dailyTargetMl: json['daily_target_ml'],
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
    );
  }
}
