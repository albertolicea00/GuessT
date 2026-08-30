import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

enum TiltAction { correct, pass }

/// Detects forehead-mode tilt gestures from the accelerometer.
///
/// ASSUMPTION — not verified on hardware: calibrates a neutral Y-axis
/// reading at start, then treats a rise above [_tiltDownThreshold] as
/// "tilted down" (correct) and a drop below [-_tiltUpThreshold] as
/// "tilted up" (pass). Axis sign/thresholds are the standard convention
/// for phone-on-forehead apps in portrait orientation, but accelerometer
/// axis mapping varies by device and OS; retune these constants after
/// testing on a real phone before shipping.
class TiltController {
  static const double _tiltDownThreshold = 4.0;
  static const double _tiltUpThreshold = 4.0;
  static const double _neutralBand = 1.5;
  static const int _calibrationSamples = 10;
  static const Duration _extraCooldown = Duration(milliseconds: 300);

  StreamSubscription<AccelerometerEvent>? _sub;
  final List<double> _calibrationBuffer = [];
  double? _neutralY;
  bool _waitingForNeutral = false;
  bool _cooldownActive = false;

  void start(void Function(TiltAction action) onTilt) {
    _neutralY = null;
    _calibrationBuffer.clear();
    _waitingForNeutral = false;
    _cooldownActive = false;

    _sub = accelerometerEventStream().listen((event) {
      if (_neutralY == null) {
        _calibrationBuffer.add(event.y);
        if (_calibrationBuffer.length >= _calibrationSamples) {
          _neutralY =
              _calibrationBuffer.reduce((a, b) => a + b) / _calibrationBuffer.length;
        }
        return;
      }

      final delta = event.y - _neutralY!;

      if (_waitingForNeutral) {
        if (delta.abs() < _neutralBand) {
          _waitingForNeutral = false;
        }
        return;
      }

      if (_cooldownActive) return;

      if (delta > _tiltDownThreshold) {
        _trigger(TiltAction.correct, onTilt);
      } else if (delta < -_tiltUpThreshold) {
        _trigger(TiltAction.pass, onTilt);
      }
    });
  }

  void _trigger(TiltAction action, void Function(TiltAction) onTilt) {
    _cooldownActive = true;
    _waitingForNeutral = true;
    onTilt(action);
    Future.delayed(_extraCooldown, () => _cooldownActive = false);
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
  }
}
