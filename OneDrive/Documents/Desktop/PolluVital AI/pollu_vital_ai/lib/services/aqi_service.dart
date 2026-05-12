import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'storage_service.dart';

class AqiService {
  AqiService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<void> saveToken(String token) async {
    await StorageService.settingsBox.put('aqi_token', token.trim());
  }

  String? getSavedToken() {
    final token = StorageService.settingsBox.get('aqi_token');
    return token is String && token.isNotEmpty ? token : null;
  }

  Future<int> fetchDelhiAqi() async {
    final token = getSavedToken();
    if (token == null) {
      throw StateError('AQI token not set. Please add your AQICN token.');
    }

    try {
      final response = await _dio.get(
        'https://api.waqi.info/feed/delhi/?token=$token',
      );
      final data = response.data as Map<String, dynamic>;
      if (data['status'] != 'ok') {
        throw StateError('AQI API error: ${data['data']}');
      }
      final aqi = (data['data']['aqi'] as num).toInt();
      await StorageService.settingsBox.put('cached_aqi', aqi);
      await StorageService.settingsBox.put('cached_aqi_time', DateTime.now().toIso8601String());
      return aqi;
    } catch (_) {
      final cached = StorageService.settingsBox.get('cached_aqi');
      if (cached is int) return cached;

      // Keep demo mode usable on first run when network/CORS blocks AQI calls.
      if (kIsWeb) {
        return 165;
      }
      rethrow;
    }
  }
}

