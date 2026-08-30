import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../services/custom_deck_service.dart';
import '../widgets/primary_button.dart';
import 'game_screen.dart';

const int kMinCustomDeckWords = 5;

class CustomDeckScreen extends StatefulWidget {
  final GameModeConfig mode;

  const CustomDeckScreen({super.key, required this.mode});

  @override
  State<CustomDeckScreen> createState() => _CustomDeckScreenState();
}

class _CustomDeckScreenState extends State<CustomDeckScreen> {
  final _controller = TextEditingController();
  final _deck = CustomDeckService.instance;

  void _add() {
    if (_controller.text.trim().isEmpty) return;
    _deck.addWord(_controller.text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customDeckTitle)),
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
                      hintText: l10n.customDeckHint,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: _add,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<List<String>>(
                valueListenable: _deck.words,
                builder: (context, words, _) {
                  if (words.isEmpty) {
                    return Center(child: Text(l10n.customDeckEmptyHint));
                  }
                  return ListView.builder(
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      return ListTile(
                        title: Text(word),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _deck.removeWord(word),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ValueListenableBuilder<List<String>>(
              valueListenable: _deck.words,
              builder: (context, words, _) {
                final canPlay = words.length >= kMinCustomDeckWords;
                return Column(
                  children: [
                    if (!canPlay)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          l10n.customDeckMissing(kMinCustomDeckWords - words.length),
                          style: const TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                    PrimaryButton(
                      label: l10n.playCustomDeckButton,
                      icon: Icons.play_arrow,
                      onPressed: canPlay
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GameScreen(
                                    mode: widget.mode,
                                    words: words,
                                  ),
                                ),
                              )
                          : null,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
