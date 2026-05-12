import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/scan_result.dart';
import '../services/pdf_report_service.dart';
import '../widgets/risk_gauge.dart';
import '../widgets/vitals_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.result});

  final ScanResult? result;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    if (result == null) {
      return Center(
        child: Text(t.t('latest_result')),
      );
    }

    final r = result!;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final riskText = r.riskScore >= 70
        ? t.t('high_risk')
        : r.riskScore >= 40
            ? t.t('moderate_risk')
            : t.t('low_risk');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('PolluVital Risk'),
                const SizedBox(height: 8),
                RiskGauge(risk: r.riskScore),
                const SizedBox(height: 8),
                Text(riskText),
                Text('AQI Delhi: ${r.aqi}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        VitalsCard(title: 'Heart Rate', value: r.hr.toStringAsFixed(1), unit: 'bpm', icon: Icons.favorite),
        VitalsCard(title: 'Resp. Rate', value: r.rr.toStringAsFixed(1), unit: 'rpm', icon: Icons.air),
        VitalsCard(title: 'SpO2', value: r.spo2.toStringAsFixed(1), unit: '%', icon: Icons.bloodtype),
        VitalsCard(title: 'Stress', value: (r.stress * 100).toStringAsFixed(1), unit: '%', icon: Icons.psychology),
        VitalsCard(title: 'Breathing', value: r.breathingClass, unit: '', icon: Icons.mic),
        VitalsCard(title: 'Predicted HR Rise', value: '+${r.hrRisePrediction.toStringAsFixed(1)}', unit: 'bpm', icon: Icons.trending_up),
        VitalsCard(title: 'Breathing Risk', value: r.breathingRiskPercent.toStringAsFixed(1), unit: '%', icon: Icons.warning_amber),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Text(isHindi ? r.adviceHi : r.adviceEn),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () async {
            final location = await PdfReportService().generateReport(r, isHindi: isHindi);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('PDF exported: $location')),
            );
          },
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Export PDF'),
        ),
      ],
    );
  }
}

