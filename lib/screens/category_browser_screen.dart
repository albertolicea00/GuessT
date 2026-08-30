import 'package:flutter/material.dart';
import '../data/word_repository.dart';
import '../l10n/generated/app_localizations.dart';

class CategoryBrowserScreen extends StatelessWidget {
  const CategoryBrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final categories = WordRepository.resolveMany(locale);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.categoriesLabel)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ExpansionTile(
            leading: Icon(category.icon),
            title: Text(category.name),
            subtitle: Text(l10n.wordsCountLabel(category.words.length)),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: category.words
                      .map((w) => Chip(label: Text(w)))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
