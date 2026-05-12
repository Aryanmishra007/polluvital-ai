class ScanResult {
  ScanResult({
    required this.timestamp,
    required this.hr,
    required this.rr,
    required this.spo2,
    required this.stress,
    required this.breathingClass,
    required this.aqi,
    required this.riskScore,
    required this.hrRisePrediction,
    required this.breathingRiskPercent,
    required this.adviceEn,
    required this.adviceHi,
  });

  final DateTime timestamp;
  final double hr;
  final double rr;
  final double spo2;
  final double stress;
  final String breathingClass;
  final int aqi;
  final double riskScore;
  final double hrRisePrediction;
  final double breathingRiskPercent;
  final String adviceEn;
  final String adviceHi;

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'hr': hr,
      'rr': rr,
      'spo2': spo2,
      'stress': stress,
      'breathingClass': breathingClass,
      'aqi': aqi,
      'riskScore': riskScore,
      'hrRisePrediction': hrRisePrediction,
      'breathingRiskPercent': breathingRiskPercent,
      'adviceEn': adviceEn,
      'adviceHi': adviceHi,
    };
  }

  factory ScanResult.fromMap(Map<dynamic, dynamic> map) {
    return ScanResult(
      timestamp: DateTime.parse(map['timestamp'] as String),
      hr: (map['hr'] as num).toDouble(),
      rr: (map['rr'] as num).toDouble(),
      spo2: (map['spo2'] as num).toDouble(),
      stress: (map['stress'] as num).toDouble(),
      breathingClass: map['breathingClass'] as String,
      aqi: (map['aqi'] as num).toInt(),
      riskScore: (map['riskScore'] as num).toDouble(),
      hrRisePrediction: (map['hrRisePrediction'] as num).toDouble(),
      breathingRiskPercent: (map['breathingRiskPercent'] as num).toDouble(),
      adviceEn: map['adviceEn'] as String,
      adviceHi: map['adviceHi'] as String,
    );
  }
}

