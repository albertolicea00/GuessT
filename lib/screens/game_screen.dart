import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../models/game_mode_text.dart';
import '../services/settings_service.dart';
import '../services/tilt_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/mode_card.dart' show modeInkColor;
import 'results_screen.dart';

class GameRoundResult {
  final int score;
  final List<String> correctWords;
  final List<String> passedWords;

  const GameRoundResult({
    required this.score,
    required this.correctWords,
    required this.passedWords,
  });
}

class _DeckEntry {
  final String answer;
  final String? imageAsset;

  const _DeckEntry(this.answer, [this.imageAsset]);
}

/// Plays one timed round. If [onFinished] is supplied (used by the Teams
/// flow), the result is handed back via that callback instead of the
/// screen navigating on to [ResultsScreen] itself.
///
/// [words] are always the answers shown on the results screen. If
/// [imageAssets] is supplied (index-aligned with [words]), the round
/// shows that image instead of the word text — used by the Images mode.
class GameScreen extends StatefulWidget {
  final GameModeConfig mode;
  final List<String> words;
  final List<String>? imageAssets;
  final void Function(GameRoundResult result)? onFinished;
  final String? teamLabel;

  const GameScreen({
    super.key,
    required this.mode,
    required this.words,
    this.imageAssets,
    this.onFinished,
    this.teamLabel,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<_DeckEntry> _deck;
  int _index = 0;
  int _score = 0;
  int _secondsLeft = 0;
  final List<String> _correct = [];
  final List<String> _passed = [];

  Timer? _timer;
  final _tilt = TiltController();
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.mode.durationSeconds;
    final images = widget.imageAssets;
    _deck = List.generate(
      widget.words.length,
      (i) => _DeckEntry(widget.words[i], images != null ? images[i] : null),
    )..shuffle(Random());
    _startTimer();
    _tilt.start(_handleTilt);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tilt.stop();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        timer.cancel();
        _finish();
      }
    });
  }

  _DeckEntry get _current => _deck[_index % _deck.length];
  String get _currentWord => _current.answer;

  void _advance() {
    _index++;
    if (_index >= _deck.length) {
      final last = _deck.last;
      _deck.shuffle(Random());
      if (_deck.first.answer == last.answer && _deck.length > 1) {
        final tmp = _deck[0];
        _deck[0] = _deck[1];
        _deck[1] = tmp;
      }
      _index = 0;
    }
  }

  void _handleTilt(TiltAction action) {
    if (_finished) return;
    if (action == TiltAction.correct) {
      _onCorrect();
    } else if (widget.mode.allowPass) {
      _onPass();
    }
  }

  void _feedback() {
    if (SettingsService.instance.vibrationEnabled.value) {
      HapticFeedback.mediumImpact();
    }
    if (SettingsService.instance.soundEnabled.value) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _onCorrect() {
    _feedback();
    setState(() {
      _correct.add(_currentWord);
      _score++;
      _advance();
    });
  }

  void _onPass() {
    if (!widget.mode.allowPass) return;
    _feedback();
    setState(() {
      _passed.add(_currentWord);
      if (widget.mode.penalizeWrong) _score--;
      _advance();
    });
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    _tilt.stop();
    final result = GameRoundResult(
      score: _score,
      correctWords: _correct,
      passedWords: _passed,
    );
    if (widget.onFinished != null) {
      widget.onFinished!(result);
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(mode: widget.mode, result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final urgent = _secondsLeft <= 10;
    final ink = modeInkColor(widget.mode.color);
    return Scaffold(
      backgroundColor: widget.mode.color.withValues(alpha: 0.35),
      appBar: AppBar(
        title: Text(widget.teamLabel ?? gameModeText(widget.mode.id, l10n).name),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatPill(
                    icon: Icons.star,
                    iconColor: Colors.amber,
                    label: l10n.scoreLabel(_score),
                  ),
                  _StatPill(
                    icon: Icons.timer,
                    iconColor: urgent ? Colors.redAccent : ink,
                    label: '${_secondsLeft}s',
                    labelColor: urgent ? Colors.redAccent : null,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 220),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: widget.mode.color, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: ink.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: _current.imageAsset != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          _current.imageAsset!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Text(
                            _currentWord,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: ink),
                          ),
                        ),
                      )
                    : Text(
                        _currentWord,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: ink),
                      ),
              ),
              const Spacer(),
              _ActionPillButton(
                label: l10n.tiltDownHint,
                icon: Icons.arrow_downward,
                background: const Color(0xFF1E7A4E),
                onTap: _onCorrect,
              ),
              if (widget.mode.allowPass) ...[
                const SizedBox(height: 12),
                _ActionPillButton(
                  label: l10n.tiltUpHint,
                  icon: Icons.arrow_upward,
                  background: const Color(0xFFE0483F),
                  onTap: _onPass,
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color? labelColor;

  const _StatPill({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: labelColor ?? AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final VoidCallback onTap;

  const _ActionPillButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: const StadiumBorder(),
          elevation: 3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
