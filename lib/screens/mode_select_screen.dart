import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../widgets/mode_card.dart';
import 'mode_info_screen.dart';

class ModeSelectScreen extends StatelessWidget {
  const ModeSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).gameModesTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: kGameModes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final mode = kGameModes[index];
            return ModeCard(
              mode: mode,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ModeInfoScreen(mode: mode)),
              ),
            );
          },
        ),
      ),
    );
  }
}
