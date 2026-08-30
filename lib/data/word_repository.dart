import 'package:flutter/material.dart';
import '../models/word_category.dart';
import 'categories.dart';
import 'word_data_en.dart';
import 'word_data_es.dart';

/// Resolves category metadata + localized names/words for the current
/// locale, falling back to English for anything a language is missing.
/// To add a language: add its two maps in a `word_data_xx.dart` file and
/// register them below — no other code needs to change.
class WordRepository {
  static const Map<String, Map<String, String>> _namesByLanguage = {
    'en': kCategoryNamesEn,
    'es': kCategoryNamesEs,
  };

  static const Map<String, Map<String, List<String>>> _wordsByLanguage = {
    'en': kCategoryWordsEn,
    'es': kCategoryWordsEs,
  };

  static WordCategory resolve(String categoryId, Locale locale) {
    final names = _namesByLanguage[locale.languageCode] ?? kCategoryNamesEn;
    final words = _wordsByLanguage[locale.languageCode] ?? kCategoryWordsEn;
    final meta = kCategoryMetas.firstWhere((m) => m.id == categoryId);
    return WordCategory(
      id: meta.id,
      icon: meta.icon,
      name: names[categoryId] ?? kCategoryNamesEn[categoryId]!,
      words: words[categoryId] ?? kCategoryWordsEn[categoryId]!,
    );
  }

  static List<WordCategory> resolveAll(List<String> categoryIds, Locale locale) =>
      categoryIds.map((id) => resolve(id, locale)).toList();

  static List<WordCategory> resolveMany(Locale locale) =>
      kCategoryMetas.map((m) => resolve(m.id, locale)).toList();
}
