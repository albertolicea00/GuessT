import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = SettingsService.instance;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: settings.soundEnabled,
            builder: (context, value, _) => SwitchListTile(
              title: Text(l10n.soundLabel),
              secondary: const Icon(Icons.volume_up),
              value: value,
              onChanged: settings.setSoundEnabled,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: settings.vibrationEnabled,
            builder: (context, value, _) => SwitchListTile(
              title: Text(l10n.vibrationLabel),
              secondary: const Icon(Icons.vibration),
              value: value,
              onChanged: settings.setVibrationEnabled,
            ),
          ),
          ValueListenableBuilder<Locale?>(
            valueListenable: settings.locale,
            builder: (context, value, _) => ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.languageLabel),
              trailing: DropdownButton<Locale?>(
                value: value,
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.languageSystem)),
                  for (final supported in AppLocalizations.supportedLocales)
                    DropdownMenuItem(
                      value: supported,
                      child: Text(_languageDisplayName(supported)),
                    ),
                ],
                onChanged: settings.setLocale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _languageDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return 'Español';
      case 'en':
      default:
        return 'English';
    }
  }
}
