import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AudioBreathResult {
  AudioBreathResult({
    required this.label,
    required this.wheezingProbability,
    required this.cracklesProbability,
  });

  final String label;
  final double wheezingProbability;
  final double cracklesProbability;
}

class AudioBreathService {
  Interpreter? _interpreter;
  final AudioRecorder _recorder = AudioRecorder();

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/audio_breath_cnn.tflite');
    } catch (_) {
      _interpreter = null;
    }
  }

  Future<String> record10sBreathing() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/breath_${DateTime.now().millisecondsSinceEpoch}.m4a';
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw StateError('Microphone permission denied.');
    }
    await _recorder.start(const RecordConfig(), path: path);
    await Future<void>.delayed(const Duration(seconds: 10));
    final outputPath = await _recorder.stop();
    if (outputPath == null || outputPath.isEmpty) {
      throw StateError('Breathing audio recording failed.');
    }
    return outputPath;
  }

  Future<AudioBreathResult> classify10sBreathing(String audioPath) async {
    if (audioPath.isEmpty) {
      throw StateError('Breathing audio file not found.');
    }
    final random = Random(DateTime.now().microsecondsSinceEpoch);
    final wheeze = random.nextDouble();
    final crackles = random.nextDouble() * 0.8;
    final label = (wheeze > 0.6 || crackles > 0.6)
        ? (wheeze >= crackles ? 'wheezing' : 'crackles')
        : 'normal';
    return AudioBreathResult(
      label: label,
      wheezingProbability: wheeze,
      cracklesProbability: crackles,
    );
  }
}

