import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores the user's custom word deck ("Modo Personalizado") locally.
class CustomDeckService {
  CustomDeckService._();
  static final CustomDeckService instance = CustomDeckService._();

  static const _kDeck = 'custom_deck_words';

  final ValueNotifier<List<String>> words = ValueNotifier(const []);

  SharedPreferences? _prefs;

  Future<void> load() async {
    _prefs ??= await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_kDeck);
    if (raw == null) {
      words.value = const [];
      return;
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    words.value = decoded.cast<String>();
  }

  Future<void> _persist() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_kDeck, jsonEncode(words.value));
  }

  Future<void> addWord(String word) async {
    final trimmed = word.trim();
    if (trimmed.isEmpty || words.value.contains(trimmed)) return;
    words.value = [...words.value, trimmed];
    await _persist();
  }

  Future<void> removeWord(String word) async {
    words.value = words.value.where((w) => w != word).toList();
    await _persist();
  }
}
