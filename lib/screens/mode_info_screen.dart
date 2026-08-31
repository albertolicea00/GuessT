import 'package:flutter/material.dart';
import '../data/categories.dart';
import '../data/word_repository.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../models/game_mode_text.dart';
import '../models/word_category.dart';
import '../services/custom_deck_service.dart';
import '../services/image_deck_service.dart';
import '../widgets/primary_button.dart';
import 'custom_deck_screen.dart';
import 'game_screen.dart';
import 'teams_setup_screen.dart';

/// Shows the mode's description plus, for a plain (non-team, non-custom,
/// non-image) mode with more than one selectable category, the category
/// list right here — skipping the separate CategorySelectScreen step.
/// A mode restricted to exactly one category (e.g. Hard) skips category
/// selection entirely and goes straight to the game.
class ModeInfoScreen extends StatelessWidget {
  final GameModeConfig mode;

  const ModeInfoScreen({super.key, required this.mode});

  bool get _needsOwnFlow => mode.usesImageDeck || mode.usesCustomDeck || mode.isTeamMode;

  List<WordCategory> _categories(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final ids = mode.restrictedCategoryIds.isNotEmpty ? mode.restrictedCategoryIds : kNormalCategoryIds;
    return WordRepository.resolveAll(ids, locale);
  }

  void _playWords(BuildContext context, List<String> words) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(mode: mode, words: words)),
    );
  }

  Future<void> _startOwnFlow(BuildContext context) async {
    if (mode.usesImageDeck) {
      final entries = await ImageDeckService.loadMoviePosters();
      if (!context.mounted) return;
      if (entries.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).imageDeckEmpty)),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(
            mode: mode,
            words: entries.map((e) => e.answer).toList(),
            imageAssets: entries.map((e) => e.assetPath).toList(),
          ),
        ),
      );
      return;
    }
    if (mode.usesCustomDeck) {
      await CustomDeckService.instance.load();
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CustomDeckScreen(mode: mode)),
      );
      return;
    }
    // isTeamMode
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TeamsSetupScreen(mode: mode)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = gameModeText(mode.id, l10n);
    final categories = _needsOwnFlow ? null : _categories(context);
    final showCategoryList = categories != null && categories.length > 1;

    return Scaffold(
      appBar: AppBar(title: Text(text.name)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(mode.icon, color: mode.color, size: 56),
            const SizedBox(height: 12),
            Text(
              text.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              text.tagline,
              textAlign: TextAlign.center,
              style: TextStyle(color: mode.color, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            Text(
              text.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, height: 1.35),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _InfoChip(
                  icon: Icons.timer,
                  label: l10n.durationChip(mode.durationSeconds),
                ),
                _InfoChip(
                  icon: mode.allowPass ? Icons.skip_next : Icons.block,
                  label: mode.allowPass ? l10n.passAllowedChip : l10n.noPassChip,
                ),
                if (mode.penalizeWrong)
                  _InfoChip(icon: Icons.remove_circle, label: l10n.penalizeChip),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: showCategoryList
                  ? ListView.separated(
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Card(
                          color: mode.color.withValues(alpha: 0.35),
                          child: ListTile(
                            leading: Icon(category.icon, color: mode.color),
                            title: Text(category.name),
                            subtitle: Text(l10n.wordsCountLabel(category.words.length)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _playWords(context, category.words),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: PrimaryButton(
                        label: l10n.continueButton,
                        icon: Icons.arrow_forward,
                        onPressed: () => categories != null
                            ? _playWords(context, categories.single.words)
                            : _startOwnFlow(context),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
