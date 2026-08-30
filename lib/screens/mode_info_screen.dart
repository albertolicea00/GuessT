import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../models/game_mode_text.dart';
import '../services/custom_deck_service.dart';
import '../widgets/primary_button.dart';
import 'category_select_screen.dart';
import 'custom_deck_screen.dart';
import 'teams_setup_screen.dart';

class ModeInfoScreen extends StatelessWidget {
  final GameModeConfig mode;

  const ModeInfoScreen({super.key, required this.mode});

  Future<void> _continue(BuildContext context) async {
    if (mode.usesCustomDeck) {
      await CustomDeckService.instance.load();
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CustomDeckScreen(mode: mode)),
      );
      return;
    }
    if (mode.isTeamMode) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TeamsSetupScreen(mode: mode)),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategorySelectScreen(mode: mode)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final text = gameModeText(mode.id, l10n);
    return Scaffold(
      appBar: AppBar(title: Text(text.name)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Icon(mode.icon, color: mode.color, size: 72),
            const SizedBox(height: 20),
            Text(
              text.name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              text.tagline,
              style: TextStyle(color: mode.color, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text(
              text.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
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
            const Spacer(flex: 2),
            PrimaryButton(
              label: l10n.continueButton,
              icon: Icons.arrow_forward,
              onPressed: () => _continue(context),
            ),
            const SizedBox(height: 12),
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
