import 'package:hive/hive.dart';

import '../models/scan_result.dart';

class StorageService {
  static const _trendsBox = 'trends_box';
  static const _settingsBox = 'settings_box';

  static Future<void> init() async {
    await Hive.openBox(_trendsBox);
    await Hive.openBox(_settingsBox);
  }

  static Box get trendsBox => Hive.box(_trendsBox);
  static Box get settingsBox => Hive.box(_settingsBox);

  static Future<void> saveScanResult(ScanResult result) async {
    await trendsBox.add(result.toMap());
    await settingsBox.put('latest_result', result.toMap());
  }

  static ScanResult? getLatestResult() {
    final data = settingsBox.get('latest_result');
    if (data == null) return null;
    return ScanResult.fromMap(data as Map<dynamic, dynamic>);
  }

  static List<ScanResult> getWeeklyResults() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return trendsBox.values
        .cast<Map<dynamic, dynamic>>()
        .map(ScanResult.fromMap)
        .where((item) => item.timestamp.isAfter(weekAgo))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}

