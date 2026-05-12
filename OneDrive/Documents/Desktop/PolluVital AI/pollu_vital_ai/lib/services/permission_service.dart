import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> ensureScanPermissions() async {
    // Web prompts permissions at browser level via media APIs.
    if (kIsWeb) return;

    final camera = await Permission.camera.request();
    final mic = await Permission.microphone.request();

    if (!camera.isGranted || !mic.isGranted) {
      throw StateError('Camera and microphone permissions are required for scan.');
    }
  }
}

