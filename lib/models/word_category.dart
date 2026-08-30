import 'package:flutter/material.dart';

/// Structural data for a category — stable across languages.
class WordCategoryMeta {
  final String id;
  final IconData icon;

  const WordCategoryMeta({required this.id, required this.icon});
}

/// A category resolved to the current language's display name and words.
class WordCategory {
  final String id;
  final IconData icon;
  final String name;
  final List<String> words;

  const WordCategory({
    required this.id,
    required this.icon,
    required this.name,
    required this.words,
  });
}
