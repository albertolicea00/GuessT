import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = [
      (icon: Icons.smartphone, title: l10n.tutorialStep1Title, text: l10n.tutorialStep1Text),
      (icon: Icons.arrow_downward, title: l10n.tutorialStep2Title, text: l10n.tutorialStep2Text),
      (icon: Icons.arrow_upward, title: l10n.tutorialStep3Title, text: l10n.tutorialStep3Text),
      (icon: Icons.emoji_events, title: l10n.tutorialStep4Title, text: l10n.tutorialStep4Text),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tutorialTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: steps.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final step = steps[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(step.icon, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(step.text),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
