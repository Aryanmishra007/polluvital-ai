import 'package:flutter/material.dart';

class RiskGauge extends StatelessWidget {
  const RiskGauge({super.key, required this.risk});

  final double risk;

  Color get _color {
    if (risk >= 70) return Colors.red;
    if (risk >= 40) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: (risk / 100).clamp(0, 1),
                strokeWidth: 10,
                backgroundColor: _color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(_color),
              ),
              Center(
                child: Text(
                  '${risk.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

