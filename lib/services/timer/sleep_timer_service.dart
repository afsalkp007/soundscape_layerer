import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/utils/audio_math.dart';

/// Manages sleep timer countdown with gentle volume fade-out automation.
class SleepTimerService extends ChangeNotifier {
  Timer? _countdownTimer;
  Duration _totalDuration = Duration.zero;
  Duration _remainingDuration = Duration.zero;
  bool _isFadeOutEnabled = true;
  double _fadeMultiplier = 1.0;
  final Duration _fadeDuration = const Duration(seconds: 60);

  VoidCallback? onTimerCompleted;
  ValueChanged<double>? onFadeMultiplierChanged;

  bool get isActive => _countdownTimer != null && _countdownTimer!.isActive;
  Duration get totalDuration => _totalDuration;
  Duration get remainingDuration => _remainingDuration;
  bool get isFadeOutEnabled => _isFadeOutEnabled;
  double get fadeMultiplier => _fadeMultiplier;

  /// Progress of timer from 0.0 (just started) to 1.0 (finished).
  double get progress {
    if (_totalDuration.inSeconds <= 0) return 0.0;
    final elapsed = _totalDuration.inSeconds - _remainingDuration.inSeconds;
    return (elapsed / _totalDuration.inSeconds).clamp(0.0, 1.0);
  }

  /// Formatted remaining time string e.g. "24:18" or "01:15:30".
  String get formattedRemaining {
    final hours = _remainingDuration.inHours;
    final minutes = _remainingDuration.inMinutes.remainder(60);
    final seconds = _remainingDuration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void setFadeOutEnabled(bool enabled) {
    _isFadeOutEnabled = enabled;
    notifyListeners();
  }

  /// Starts a countdown timer for the specified duration.
  void startTimer(Duration duration) {
    cancelTimer();

    _totalDuration = duration;
    _remainingDuration = duration;
    _fadeMultiplier = 1.0;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingDuration.inSeconds <= 1) {
        _remainingDuration = Duration.zero;
        _fadeMultiplier = 0.0;
        cancelTimer();
        notifyListeners();
        onTimerCompleted?.call();
      } else {
        _remainingDuration = _remainingDuration - const Duration(seconds: 1);
        _updateFadeMultiplier();
        notifyListeners();
      }
    });

    notifyListeners();
  }

  void _updateFadeMultiplier() {
    if (!_isFadeOutEnabled) {
      _fadeMultiplier = 1.0;
      return;
    }

    final remainingSecs = _remainingDuration.inSeconds;
    final fadeSecs = _fadeDuration.inSeconds;

    if (remainingSecs < fadeSecs) {
      // In the final fade-out zone: progress 0.0 -> 1.0
      final fadeProgress = (fadeSecs - remainingSecs) / fadeSecs;
      _fadeMultiplier = AudioMath.calculateFadeMultiplier(fadeProgress);
      onFadeMultiplierChanged?.call(_fadeMultiplier);
    } else {
      _fadeMultiplier = 1.0;
    }
  }

  /// Cancels the running timer and resets volume multiplier.
  void cancelTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _totalDuration = Duration.zero;
    _remainingDuration = Duration.zero;
    _fadeMultiplier = 1.0;
    notifyListeners();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }
}
