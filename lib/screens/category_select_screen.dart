import 'package:flutter/material.dart';
import '../data/categories.dart';
import '../data/word_repository.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../models/word_category.dart';
import 'game_screen.dart';
import 'teams_game_flow_screen.dart';

class CategorySelectScreen extends StatelessWidget {
  final GameModeConfig mode;
  final List<String>? teamNames;

  const CategorySelectScreen({super.key, required this.mode, this.teamNames});

  List<WordCategory> _availableCategories(Locale locale) {
    final ids = mode.restrictedCategoryIds.isNotEmpty
        ? mode.restrictedCategoryIds
        : kNormalCategoryIds;
    return WordRepository.resolveAll(ids, locale);
  }

  void _select(BuildContext context, WordCategory category) {
    if (teamNames != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TeamsGameFlowScreen(
            mode: mode,
            teamNames: teamNames!,
            words: category.words,
          ),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(mode: mode, words: category.words),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final categories = _availableCategories(locale);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chooseCategoryTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            color: mode.color.withValues(alpha: 0.15),
            child: ListTile(
              leading: Icon(category.icon, color: mode.color),
              title: Text(category.name),
              subtitle: Text(l10n.wordsCountLabel(category.words.length)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _select(context, category),
            ),
          );
        },
      ),
    );
  }
}
