import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/scan_result.dart';
import '../services/aqi_service.dart';
import '../services/storage_service.dart';
import 'credit_screen.dart';
import 'dashboard_screen.dart';
import 'scan_screen.dart';
import 'trends_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onLocaleChanged, required this.currentLocale});

  final ValueChanged<Locale> onLocaleChanged;
  final Locale currentLocale;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  ScanResult? _latest;

  @override
  void initState() {
    super.initState();
    _latest = StorageService.getLatestResult();
  }

  Future<void> _openScan() async {
    final result = await Navigator.of(context).push<ScanResult>(
      MaterialPageRoute(builder: (_) => const ScanScreen()),
    );
    if (result != null) {
      setState(() => _latest = result);
    }
  }

  Future<void> _setTokenDialog() async {
    final controller = TextEditingController(text: AqiService().getSavedToken() ?? '');
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('AQI Token Setup'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'aqicn.org token',
              hintText: 'Paste token here',
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                await AqiService().saveToken(controller.text);
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final pages = [
      DashboardScreen(result: _latest),
      const TrendsScreen(),
      const CreditScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('app_title')),
        actions: [
          IconButton(
            tooltip: t.t('set_token'),
            onPressed: _setTokenDialog,
            icon: const Icon(Icons.key),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) => widget.onLocaleChanged(Locale(value)),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'hi', child: Text('हिन्दी')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              '${t.t('tagline')}\n${t.t('privacy_notice')}',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: pages[_index]),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: _openScan,
              icon: const Icon(Icons.health_and_safety),
              label: Text(t.t('start_scan')),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.dashboard), label: t.t('latest_result')),
          NavigationDestination(icon: const Icon(Icons.show_chart), label: t.t('weekly_trend')),
          NavigationDestination(icon: const Icon(Icons.person), label: t.t('credits')),
        ],
      ),
    );
  }
}

