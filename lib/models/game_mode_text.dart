import '../l10n/generated/app_localizations.dart';
import 'game_mode.dart';

class GameModeText {
  final String name;
  final String tagline;
  final String description;

  const GameModeText({
    required this.name,
    required this.tagline,
    required this.description,
  });
}

GameModeText gameModeText(GameModeId id, AppLocalizations l10n) {
  switch (id) {
    case GameModeId.classic:
      return GameModeText(
        name: l10n.modeClassicName,
        tagline: l10n.modeClassicTagline,
        description: l10n.modeClassicDescription,
      );
    case GameModeId.timeAttack:
      return GameModeText(
        name: l10n.modeTimeAttackName,
        tagline: l10n.modeTimeAttackTagline,
        description: l10n.modeTimeAttackDescription,
      );
    case GameModeId.teams:
      return GameModeText(
        name: l10n.modeTeamsName,
        tagline: l10n.modeTeamsTagline,
        description: l10n.modeTeamsDescription,
      );
    case GameModeId.kids:
      return GameModeText(
        name: l10n.modeKidsName,
        tagline: l10n.modeKidsTagline,
        description: l10n.modeKidsDescription,
      );
    case GameModeId.hard:
      return GameModeText(
        name: l10n.modeHardName,
        tagline: l10n.modeHardTagline,
        description: l10n.modeHardDescription,
      );
    case GameModeId.custom:
      return GameModeText(
        name: l10n.modeCustomName,
        tagline: l10n.modeCustomTagline,
        description: l10n.modeCustomDescription,
      );
  }
}
