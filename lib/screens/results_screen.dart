import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../widgets/primary_button.dart';
import 'game_screen.dart';
import 'home_screen.dart';

class ResultsScreen extends StatelessWidget {
  final GameModeConfig mode;
  final GameRoundResult result;

  const ResultsScreen({super.key, required this.mode, required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultsTitle), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '${result.score}',
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900),
            ),
            Text(l10n.pointsSuffix, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  if (result.correctWords.isNotEmpty) ...[
                    _SectionTitle(l10n.correctSectionTitle, Icons.check_circle, Colors.green),
                    ...result.correctWords.map((w) => _WordRow(w, Colors.green)),
                  ],
                  if (result.passedWords.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _SectionTitle(l10n.passedSectionTitle, Icons.arrow_upward, Colors.grey),
                    ...result.passedWords.map((w) => _WordRow(w, Colors.grey)),
                  ],
                ],
              ),
            ),
            PrimaryButton(
              label: l10n.mainMenuButton,
              icon: Icons.home,
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _SectionTitle(this.label, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class _WordRow extends StatelessWidget {
  final String word;
  final Color color;

  const _WordRow(this.word, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(word, style: TextStyle(color: color.withOpacity(0.9))),
    );
  }
}
