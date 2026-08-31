import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../models/game_mode_text.dart';

/// Darkens [color] to a legible "ink" shade of the same hue, used for the
/// icon and label sitting on top of the card's pastel fill.
Color modeInkColor(Color color) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness * 0.42).clamp(0.0, 1.0)).toColor();
}

class ModeCard extends StatelessWidget {
  final GameModeConfig mode;
  final VoidCallback onTap;

  const ModeCard({super.key, required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = gameModeText(mode.id, AppLocalizations.of(context));
    final ink = modeInkColor(mode.color);
    return Material(
      color: mode.color,
      borderRadius: BorderRadius.circular(26),
      elevation: 3,
      shadowColor: ink.withValues(alpha: 0.35),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(mode.icon, color: ink, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                text.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
