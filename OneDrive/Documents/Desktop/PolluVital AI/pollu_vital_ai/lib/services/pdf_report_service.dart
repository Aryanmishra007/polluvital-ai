import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/scan_result.dart';
import 'pdf_save_helper.dart';

class PdfReportService {
  Future<String> generateReport(ScanResult result, {required bool isHindi}) async {
    final pdf = pw.Document();
    final format = DateFormat('dd MMM yyyy, hh:mm a');
    final riskLabel = result.riskScore >= 70
        ? (isHindi ? 'उच्च जोखिम' : 'High Risk')
        : result.riskScore >= 40
            ? (isHindi ? 'मध्यम जोखिम' : 'Moderate Risk')
            : (isHindi ? 'कम जोखिम' : 'Low Risk');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('PolluVital AI Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Generated: ${format.format(result.timestamp)}'),
              pw.SizedBox(height: 16),
              pw.Text('Vitals', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text('Heart Rate: ${result.hr.toStringAsFixed(1)} bpm'),
              pw.Text('Respiratory Rate: ${result.rr.toStringAsFixed(1)} rpm'),
              pw.Text('SpO2: ${result.spo2.toStringAsFixed(1)}%'),
              pw.Text('Stress: ${(result.stress * 100).toStringAsFixed(1)}%'),
              pw.SizedBox(height: 12),
              pw.Text('AQI: ${result.aqi}'),
              pw.Text('Breathing class: ${result.breathingClass}'),
              pw.Text('Risk score: ${result.riskScore.toStringAsFixed(1)}% ($riskLabel)'),
              pw.Text('Predicted HR rise: +${result.hrRisePrediction.toStringAsFixed(1)} bpm'),
              pw.Text('Predicted breathing risk: ${result.breathingRiskPercent.toStringAsFixed(1)}%'),
              pw.SizedBox(height: 12),
              pw.Text(isHindi ? result.adviceHi : result.adviceEn),
              pw.Spacer(),
              pw.Text('Built by Aryan - B.Tech CSE 2nd Year, K.R. Mangalam University'),
            ],
          );
        },
      ),
    );
    final Uint8List bytes = await pdf.save();
    final filename = 'polluvital_report_${result.timestamp.millisecondsSinceEpoch}.pdf';
    return savePdfBytes(filename, bytes);
  }
}

