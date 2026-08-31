import 'package:flutter/material.dart';

enum GameModeId { classic, timeAttack, teams, kids, hard, custom, numbers, images }

class GameModeConfig {
  final GameModeId id;
  final IconData icon;
  final Color color;
  final int durationSeconds;
  final bool allowPass;
  final bool penalizeWrong;
  /// Empty means any normal-difficulty category is selectable.
  final List<String> restrictedCategoryIds;
  final bool usesCustomDeck;
  final bool isTeamMode;
  final bool usesImageDeck;

  const GameModeConfig({
    required this.id,
    required this.icon,
    required this.color,
    required this.durationSeconds,
    required this.allowPass,
    required this.penalizeWrong,
    this.restrictedCategoryIds = const [],
    this.usesCustomDeck = false,
    this.isTeamMode = false,
    this.usesImageDeck = false,
  });
}

const List<GameModeConfig> kGameModes = [
  GameModeConfig(
    id: GameModeId.classic,
    icon: Icons.style,
    color: Color(0xFFAECBFA),
    durationSeconds: 60,
    allowPass: true,
    penalizeWrong: false,
  ),
  GameModeConfig(
    id: GameModeId.timeAttack,
    icon: Icons.timer,
    color: Color(0xFFFFB199),
    durationSeconds: 30,
    allowPass: false,
    penalizeWrong: false,
  ),
  GameModeConfig(
    id: GameModeId.teams,
    icon: Icons.groups,
    color: Color(0xFFB7EFC5),
    durationSeconds: 60,
    allowPass: true,
    penalizeWrong: false,
    isTeamMode: true,
  ),
  GameModeConfig(
    id: GameModeId.kids,
    icon: Icons.child_care,
    color: Color(0xFFFBB8DD),
    durationSeconds: 90,
    allowPass: true,
    penalizeWrong: false,
    restrictedCategoryIds: ['animalsEasy', 'colorsShapes'],
  ),
  GameModeConfig(
    id: GameModeId.hard,
    icon: Icons.local_fire_department,
    color: Color(0xFFFDE38C),
    durationSeconds: 40,
    allowPass: true,
    penalizeWrong: true,
    restrictedCategoryIds: ['historyScience'],
  ),
  GameModeConfig(
    id: GameModeId.custom,
    icon: Icons.edit_note,
    color: Color(0xFF92E8D8),
    durationSeconds: 60,
    allowPass: true,
    penalizeWrong: false,
    usesCustomDeck: true,
  ),
  GameModeConfig(
    id: GameModeId.numbers,
    icon: Icons.numbers,
    color: Color(0xFFC9BBF5),
    durationSeconds: 45,
    allowPass: true,
    penalizeWrong: false,
    restrictedCategoryIds: ['numbers'],
  ),
  GameModeConfig(
    id: GameModeId.images,
    icon: Icons.image,
    color: Color(0xFFF3C9A1),
    durationSeconds: 60,
    allowPass: true,
    penalizeWrong: false,
    usesImageDeck: true,
  ),
];

GameModeConfig gameModeById(GameModeId id) =>
    kGameModes.firstWhere((m) => m.id == id);
