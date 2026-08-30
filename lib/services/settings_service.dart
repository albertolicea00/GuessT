import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global app settings, persisted locally. Load once at startup before
/// runApp; each field is a ValueNotifier so screens can react live.
class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  static const _kSound = 'settings_sound_enabled';
  static const _kVibration = 'settings_vibration_enabled';
  static const _kLanguageCode = 'settings_language_code';

  final ValueNotifier<bool> soundEnabled = ValueNotifier(true);
  final ValueNotifier<bool> vibrationEnabled = ValueNotifier(true);

  /// null means "follow system locale" (falling back to English if the
  /// system locale isn't one of `AppLocalizations.supportedLocales`).
  final ValueNotifier<Locale?> locale = ValueNotifier(null);

  late SharedPreferences _prefs;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    soundEnabled.value = _prefs.getBool(_kSound) ?? true;
    vibrationEnabled.value = _prefs.getBool(_kVibration) ?? true;
    final code = _prefs.getString(_kLanguageCode);
    locale.value = code == null ? null : Locale(code);
  }

  Future<void> setSoundEnabled(bool value) async {
    soundEnabled.value = value;
    await _prefs.setBool(_kSound, value);
  }

  Future<void> setVibrationEnabled(bool value) async {
    vibrationEnabled.value = value;
    await _prefs.setBool(_kVibration, value);
  }

  /// Pass null to follow the system locale again.
  Future<void> setLocale(Locale? value) async {
    locale.value = value;
    if (value == null) {
      await _prefs.remove(_kLanguageCode);
    } else {
      await _prefs.setString(_kLanguageCode, value.languageCode);
    }
  }
}
