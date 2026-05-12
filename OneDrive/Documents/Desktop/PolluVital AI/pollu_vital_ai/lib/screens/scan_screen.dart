import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../models/scan_result.dart';
import '../services/aqi_service.dart';
import '../services/audio_breath_service.dart';
import '../services/camera_rppg_service.dart';
import '../services/fusion_predictor_service.dart';
import '../services/permission_service.dart';
import '../services/storage_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _running = false;
  String _status = 'Ready';
  double _progress = 0;
  CameraController? _cameraController;

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw StateError('No camera found on device.');
    }
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(
      front,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController!.initialize();
  }

  Future<void> _runScan() async {
    setState(() {
      _running = true;
      _status = 'Requesting permissions...';
      _progress = 0.05;
    });

    final camera = CameraRppgService();
    final audio = AudioBreathService();
    final fusion = FusionPredictorService();
    final aqi = AqiService();

    try {
      await PermissionService.ensureScanPermissions();
      await _initCamera();
      await camera.loadModel();
      await audio.loadModel();
      await fusion.loadModel();

      setState(() {
        _status = 'Recording face (30s)...';
        _progress = 0.25;
      });
      final videoFile = await camera.capture30sFaceVideo(_cameraController!);
      final vitals = await camera.estimateVitalsFrom30sFaceClip(videoFile);

      setState(() {
        _status = 'Recording breathing (10s)...';
        _progress = 0.5;
      });
      final audioPath = await audio.record10sBreathing();
      final breath = await audio.classify10sBreathing(audioPath);

      setState(() {
        _status = 'Fetching AQI...';
        _progress = 0.7;
      });
      final aqiValue = await aqi.fetchDelhiAqi();

      setState(() {
        _status = 'Running multimodal predictor...';
        _progress = 0.9;
      });
      final prediction = await fusion.predict(vitals: vitals, breath: breath, aqi: aqiValue);

      final result = ScanResult(
        timestamp: DateTime.now(),
        hr: vitals.hr,
        rr: vitals.rr,
        spo2: vitals.spo2,
        stress: vitals.stress,
        breathingClass: breath.label,
        aqi: aqiValue,
        riskScore: prediction.riskScore,
        hrRisePrediction: prediction.hrRise,
        breathingRiskPercent: prediction.breathingRiskPercent,
        adviceEn: prediction.adviceEn,
        adviceHi: prediction.adviceHi,
      );

      await StorageService.saveScanResult(result);
      if (!mounted) return;
      Navigator.of(context).pop(result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scan failed: $e')),
      );
      setState(() {
        _running = false;
        _status = 'Failed';
        _progress = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _runScan();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan in Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 16),
            Text(_status, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            if (_cameraController != null && _cameraController!.value.isInitialized)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            const SizedBox(height: 10),
            const Text('Keep your face centered and breathe naturally near the mic.'),
            const Spacer(),
            if (!_running)
              FilledButton.icon(
                onPressed: _runScan,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Scan'),
              ),
          ],
        ),
      ),
    );
  }
}

