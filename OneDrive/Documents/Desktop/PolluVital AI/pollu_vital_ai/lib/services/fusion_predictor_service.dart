import 'dart:math';

import 'package:tflite_flutter/tflite_flutter.dart';

import 'audio_breath_service.dart';
import 'camera_rppg_service.dart';

class FusionPrediction {
  FusionPrediction({
    required this.riskScore,
    required this.hrRise,
    required this.breathingRiskPercent,
    required this.adviceEn,
    required this.adviceHi,
  });

  final double riskScore;
  final double hrRise;
  final double breathingRiskPercent;
  final String adviceEn;
  final String adviceHi;
}

class FusionPredictorService {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/fusion_lstm.tflite');
    } catch (_) {
      _interpreter = null;
    }
  }

  Future<FusionPrediction> predict({
    required RppgVitals vitals,
    required AudioBreathResult breath,
    required int aqi,
  }) async {
    // Heuristic fallback for demo; replace with TFLite sequence inference in production.
    final breathRisk = ((breath.wheezingProbability + breath.cracklesProbability) / 2) * 100;
    final pollutionFactor = (aqi / 500).clamp(0.0, 1.0);
    final stressFactor = vitals.stress.clamp(0.0, 1.0);
    final risk = ((0.45 * pollutionFactor) + (0.30 * stressFactor) + (0.25 * (breathRisk / 100))) * 100;
    final hrRise = max(3.0, (pollutionFactor * 20) + (stressFactor * 6));

    final adviceEn = risk >= 70
        ? 'High risk window in next 1-4h. Avoid outdoor exertion, wear N95, hydrate, and monitor symptoms.'
        : risk >= 40
            ? 'Moderate risk. Reduce exposure near traffic, do light breathing exercises indoors.'
            : 'Low risk currently. Continue normal routine with regular hydration.';

    final adviceHi = risk >= 70
        ? 'अगले 1-4 घंटे में जोखिम अधिक है। बाहर भारी गतिविधि से बचें, N95 पहनें, पानी पिएं।'
        : risk >= 40
            ? 'मध्यम जोखिम। ट्रैफिक वाले क्षेत्रों से दूरी रखें और घर के अंदर हल्की ब्रीदिंग करें।'
            : 'अभी जोखिम कम है। नियमित दिनचर्या और हाइड्रेशन बनाए रखें।';

    return FusionPrediction(
      riskScore: risk.clamp(0.0, 100.0),
      hrRise: hrRise,
      breathingRiskPercent: breathRisk.clamp(0.0, 100.0),
      adviceEn: adviceEn,
      adviceHi: adviceHi,
    );
  }
}

