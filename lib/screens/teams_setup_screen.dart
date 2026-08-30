import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../widgets/primary_button.dart';
import 'category_select_screen.dart';

const int kMinTeams = 2;

class TeamsSetupScreen extends StatefulWidget {
  final GameModeConfig mode;

  const TeamsSetupScreen({super.key, required this.mode});

  @override
  State<TeamsSetupScreen> createState() => _TeamsSetupScreenState();
}

class _TeamsSetupScreenState extends State<TeamsSetupScreen> {
  final _controller = TextEditingController();
  List<String>? _teams;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _teams ??= [
      AppLocalizations.of(context)!.defaultTeamName(1),
      AppLocalizations.of(context)!.defaultTeamName(2),
    ];
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _teams!.add(text));
    _controller.clear();
  }

  void _remove(int index) {
    if (_teams!.length <= kMinTeams) return;
    setState(() => _teams!.removeAt(index));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final teams = _teams!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.teamsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: l10n.teamNameHint,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(onPressed: _add, icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(teams[index]),
                  trailing: teams.length > kMinTeams
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _remove(index),
                        )
                      : null,
                ),
              ),
            ),
            PrimaryButton(
              label: l10n.continueWithTeams(teams.length),
              icon: Icons.arrow_forward,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategorySelectScreen(
                    mode: widget.mode,
                    teamNames: List.of(teams),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
