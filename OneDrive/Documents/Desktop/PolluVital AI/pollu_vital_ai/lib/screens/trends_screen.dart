import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class TrendsScreen extends StatelessWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final results = StorageService.getWeeklyResults();
    if (results.isEmpty) {
      return const Center(child: Text('No trend data yet. Run at least one scan.'));
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < results.length; i++) {
      spots.add(FlSpot(i.toDouble(), results[i].riskScore));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Risk Trend', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

