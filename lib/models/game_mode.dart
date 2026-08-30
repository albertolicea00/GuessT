import 'package:flutter/material.dart';

enum GameModeId { classic, timeAttack, teams, kids, hard, custom }

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
  });
}

const List<GameModeConfig> kGameModes = [
  GameModeConfig(
    id: GameModeId.classic,
    icon: Icons.style,
    color: Color(0xFF4A90E2),
    durationSeconds: 60,
    allowPass: true,
    penalizeWrong: false,
  ),
  GameModeConfig(
    id: GameModeId.timeAttack,
    icon: Icons.timer,
    color: Color(0xFFE24A4A),
    durationSeconds: 30,
    allowPass: false,
    penalizeWrong: false,
  ),
  GameModeConfig(
    id: GameModeId.teams,
    icon: Icons.groups,
    color: Color(0xFFE2A04A),
    durationSeconds: 60,
    allowPass: true,
    penalizeWrong: false,
    isTeamMode: true,
  ),
  GameModeConfig(
    id: GameModeId.kids,
    icon: Icons.child_care,
    color: Color(0xFFE24AA0),
    durationSeconds: 90,
    allowPass: true,
    penalizeWrong: false,
    restrictedCategoryIds: ['animalsEasy', 'colorsShapes'],
  ),
  GameModeConfig(
    id: GameModeId.hard,
    icon: Icons.local_fire_department,
    color: Color(0xFF8A4AE2),
    durationSeconds: 40,
    allowPass: true,
    penalizeWrong: true,
    restrictedCategoryIds: ['historyScience'],
  ),
  GameModeConfig(
    id: GameModeId.custom,
    icon: Icons.edit_note,
    color: Color(0xFF4AE2A0),
    durationSeconds: 60,
    allowPass: true,
    penalizeWrong: false,
    usesCustomDeck: true,
  ),
];

GameModeConfig gameModeById(GameModeId id) =>
    kGameModes.firstWhere((m) => m.id == id);
