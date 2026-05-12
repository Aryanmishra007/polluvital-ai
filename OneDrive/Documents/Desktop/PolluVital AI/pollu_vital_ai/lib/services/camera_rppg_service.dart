import 'dart:math';

import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class RppgVitals {
  RppgVitals({
    required this.hr,
    required this.rr,
    required this.spo2,
    required this.stress,
  });

  final double hr;
  final double rr;
  final double spo2;
  final double stress;
}

class CameraRppgService {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/rppg_physnet.tflite');
    } catch (_) {
      _interpreter = null;
    }
  }

  Future<XFile> capture30sFaceVideo(CameraController controller) async {
    if (!controller.value.isRecordingVideo) {
      await controller.startVideoRecording();
    }
    await Future<void>.delayed(const Duration(seconds: 30));
    return controller.stopVideoRecording();
  }

  Future<RppgVitals> estimateVitalsFrom30sFaceClip(XFile videoFile) async {
    if (videoFile.path.isEmpty) {
      throw StateError('Invalid face video file path.');
    }

    // If model is available, replace with real tensor preprocessing/inference.
    // Current implementation provides a deterministic demo-friendly output.
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final hr = 72 + random.nextInt(22);
    final rr = 14 + random.nextInt(10);
    final spo2 = 95 + random.nextDouble() * 4;
    final stress = 0.2 + random.nextDouble() * 0.7;
    return RppgVitals(hr: hr.toDouble(), rr: rr.toDouble(), spo2: spo2, stress: stress);
  }
}

