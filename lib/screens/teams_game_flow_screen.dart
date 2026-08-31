import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import 'game_screen.dart';
import 'team_results_screen.dart';

class TeamScore {
  final String teamName;
  final GameRoundResult result;

  const TeamScore(this.teamName, this.result);
}

/// Orchestrates one round per team, then hands off to [TeamResultsScreen].
class TeamsGameFlowScreen extends StatefulWidget {
  final GameModeConfig mode;
  final List<String> teamNames;
  final List<String> words;

  const TeamsGameFlowScreen({
    super.key,
    required this.mode,
    required this.teamNames,
    required this.words,
  });

  @override
  State<TeamsGameFlowScreen> createState() => _TeamsGameFlowScreenState();
}

class _TeamsGameFlowScreenState extends State<TeamsGameFlowScreen> {
  int _currentTeam = 0;
  final List<TeamScore> _scores = [];

  Future<void> _playCurrentTeam() async {
    final teamName = widget.teamNames[_currentTeam];
    final result = await Navigator.push<GameRoundResult>(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          mode: widget.mode,
          words: widget.words,
          teamLabel: teamName,
          onFinished: (r) => Navigator.pop(context, r),
        ),
      ),
    );
    if (result == null || !mounted) return;
    _scores.add(TeamScore(teamName, result));
    if (_currentTeam + 1 >= widget.teamNames.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TeamResultsScreen(scores: _scores),
        ),
      );
    } else {
      setState(() => _currentTeam++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final teamName = widget.teamNames[_currentTeam];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.teamsTitle), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.turnLabel,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              teamName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              label: l10n.startButton,
              icon: Icons.play_arrow,
              onPressed: _playCurrentTeam,
            ),
          ],
        ),
      ),
    );
  }
}
