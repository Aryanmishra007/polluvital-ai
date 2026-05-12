1qqqqqqqqqqqqqqqqqq`q 2import 'package:flutter/material.dart';

class CreditScreen extends StatelessWidget {
  const CreditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(1
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64),
            SizedBox(height: 16),
            Text(
              'Built by Aryan – B.Tech CSE 2nd Year, K.R. Mangalam University',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'PolluVital AI: India\'s on-device multimodal pollution health predictor.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

