import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/game_mode.dart';
import '../models/game_mode_text.dart';
import '../services/settings_service.dart';
import '../services/tilt_controller.dart';
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

/// Plays one timed round. If [onFinished] is supplied (used by the Teams
/// flow), the result is handed back via that callback instead of the
/// screen navigating on to [ResultsScreen] itself.
class GameScreen extends StatefulWidget {
  final GameModeConfig mode;
  final List<String> words;
  final void Function(GameRoundResult result)? onFinished;
  final String? teamLabel;

  const GameScreen({
    super.key,
    required this.mode,
    required this.words,
    this.onFinished,
    this.teamLabel,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> _deck;
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
    _deck = List.of(widget.words)..shuffle(Random());
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

  String get _currentWord => _deck[_index % _deck.length];

  void _advance() {
    _index++;
    if (_index >= _deck.length) {
      final last = _deck.last;
      _deck.shuffle(Random());
      if (_deck.first == last && _deck.length > 1) {
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
    final l10n = AppLocalizations.of(context)!;
    final urgent = _secondsLeft <= 10;
    return Scaffold(
      backgroundColor: widget.mode.color.withOpacity(0.12),
      appBar: AppBar(
        title: Text(widget.teamLabel ?? gameModeText(widget.mode.id, l10n).name),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                '$_secondsLeft',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: urgent ? Colors.redAccent : Colors.white,
                ),
              ),
              Text(l10n.scoreLabel(_score), style: const TextStyle(fontSize: 18)),
              const Spacer(),
              Text(
                _currentWord,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.mode.allowPass)
                    _RoundButton(
                      label: l10n.passLabel,
                      icon: Icons.arrow_upward,
                      color: Colors.grey,
                      onTap: _onPass,
                    ),
                  _RoundButton(
                    label: l10n.correctLabel,
                    icon: Icons.check,
                    color: Colors.green,
                    onTap: _onCorrect,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.tiltHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoundButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: label,
          backgroundColor: color,
          onPressed: onTap,
          child: Icon(icon),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}
