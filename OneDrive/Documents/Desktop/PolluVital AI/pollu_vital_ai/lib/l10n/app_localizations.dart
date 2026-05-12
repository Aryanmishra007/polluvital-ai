import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;
  late Map<String, String> _localizedValues;

  static const supportedLocales = [Locale('en'), Locale('hi')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    if (instance == null) {
      throw StateError('AppLocalizations not found in widget tree.');
    }
    return instance;
  }

  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    _localizedValues = map.map((key, value) => MapEntry(key, value.toString()));
  }

  String t(String key) => _localizedValues[key] ?? key;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((item) => item.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

