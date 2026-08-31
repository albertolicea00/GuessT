import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';
import 'teams_game_flow_screen.dart';

class TeamResultsScreen extends StatelessWidget {
  final List<TeamScore> scores;

  const TeamResultsScreen({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sorted = List.of(scores)
      ..sort((a, b) => b.result.score.compareTo(a.result.score));
    final winner = sorted.first;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.finalResultsTitle), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 56),
            const SizedBox(height: 8),
            Text(
              l10n.winnerLabel(winner.teamName),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: sorted.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = sorted[index];
                  return Card(
                    color: index == 0 ? Colors.amber.withValues(alpha: 0.35) : null,
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(entry.teamName),
                      trailing: Text(
                        l10n.scorePts(entry.result.score),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
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
