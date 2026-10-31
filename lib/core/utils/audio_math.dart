import 'dart:math' as math;

/// Core mathematical and DSP utilities for sound mixing, spatial audio, and decibels.
class AudioMath {
  AudioMath._();

  /// Converts a linear volume amplitude (0.0 to 1.0) to decibels (dBFS).
  /// 0.0 amplitude maps to -inf dB (clamped to [minDb], default -60 dB).
  static double linearToDb(double linear, {double minDb = -60.0}) {
    if (linear <= 0.0001) return minDb;
    final db = 20.0 * (math.log(linear) / math.ln10);
    return db < minDb ? minDb : db;
  }

  /// Converts decibels (dBFS) back to linear amplitude (0.0 to 1.0).
  static double dbToLinear(double db) {
    if (db <= -60.0) return 0.0;
    return math.pow(10.0, db / 20.0).toDouble().clamp(0.0, 1.0);
  }

  /// Computes Constant-Power Stereo Panning gains.
  /// [pan] ranges from -1.0 (Hard Left) to +1.0 (Hard Right).
  /// At center (pan: 0.0), both channels output ~0.707 (-3dB) keeping total acoustic energy constant.
  static ({double leftGain, double rightGain}) constantPowerPan(double pan) {
    final clampedPan = pan.clamp(-1.0, 1.0);
    // Normalize pan from [-1.0, 1.0] to [0.0, pi/2]
    final angle = (clampedPan + 1.0) * (math.pi / 4.0);
    final leftGain = math.cos(angle);
    final rightGain = math.sin(angle);
    return (leftGain: leftGain, rightGain: rightGain);
  }

  /// Calculates inverse-square distance attenuation factor for 2D spatial audio.
  /// [distance]: normalized [0.0, 1.0].
  /// [rolloff]: curve steepness.
  static double calculateDistanceAttenuation(double distance, {double rolloff = 1.0}) {
    final clamped = distance.clamp(0.0, 1.0);
    // Standard audio roll-off formula: 1 / (1 + rolloff * distance)
    return (1.0 / (1.0 + rolloff * clamped)).clamp(0.0, 1.0);
  }

  /// Logarithmic volume fade curve used for smooth sleep timer fade-outs.
  /// [progress]: 0.0 (full volume) to 1.0 (silence).
  static double calculateFadeMultiplier(double progress) {
    final p = progress.clamp(0.0, 1.0);
    // Logarithmic curve sounds far more natural to human ears than linear fade
    return math.pow(1.0 - p, 2.0).toDouble();
  }

  /// Normalizes frequency value to slider position with logarithmic scaling.
  static double frequencyToLogScale(double hz, double minHz, double maxHz) {
    final minLog = math.log(minHz);
    final maxLog = math.log(maxHz);
    return ((math.log(hz) - minLog) / (maxLog - minLog)).clamp(0.0, 1.0);
  }

  /// Maps slider position back to frequency with logarithmic distribution.
  static double logScaleToFrequency(double value, double minHz, double maxHz) {
    final minLog = math.log(minHz);
    final maxLog = math.log(maxHz);
    return math.exp(minLog + value * (maxLog - minLog));
  }
}
