import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../models/game_mode_text.dart';

class ModeCard extends StatelessWidget {
  final GameModeConfig mode;
  final VoidCallback onTap;

  const ModeCard({super.key, required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = gameModeText(mode.id, AppLocalizations.of(context)!);
    return Material(
      color: mode.color.withOpacity(0.18),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: mode.color.withOpacity(0.6), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(mode.icon, color: mode.color, size: 36),
              const SizedBox(height: 10),
              Text(
                text.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                text.tagline,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
