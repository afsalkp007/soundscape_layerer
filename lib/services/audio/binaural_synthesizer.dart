import 'dart:math' as math;
import 'dart:typed_data';
import '../../core/utils/wav_generator.dart';
import '../../models/binaural_wave.dart';

/// Synthesizer service converting [BinauralWave] parameters into calibrated audio buffers
/// and calculating real-time dual-ear phase visualizer data.
class BinauralSynthesizer {
  BinauralWave _currentWave;
  Uint8List? _cachedBuffer;
  String _cachedKey = '';

  BinauralSynthesizer({
    BinauralWave? initialWave,
  }) : _currentWave = initialWave ?? const BinauralWave();

  BinauralWave get currentWave => _currentWave;

  /// Updates synthesizer parameters and invalidates buffer cache if frequencies changed.
  void updateWave(BinauralWave wave) {
    if (_currentWave.carrierFrequency != wave.carrierFrequency ||
        _currentWave.beatFrequency != wave.beatFrequency ||
        _currentWave.isIsochronic != wave.isIsochronic) {
      _cachedBuffer = null;
    }
    _currentWave = wave;
  }

  /// Synthesizes or retrieves cached stereo audio buffer for the current binaural configuration.
  Uint8List generateAudioBuffer({double durationSeconds = 3.0}) {
    final key = '${_currentWave.carrierFrequency}_${_currentWave.beatFrequency}_${_currentWave.isIsochronic}';
    if (_cachedBuffer != null && _cachedKey == key) {
      return _cachedBuffer!;
    }

    final leftHz = _currentWave.leftEarFrequency;
    final rightHz = _currentWave.rightEarFrequency;

    final buffer = WavGenerator.generateBinauralBeatWav(
      leftHz: leftHz,
      rightHz: rightHz,
      durationSeconds: durationSeconds,
      amplitude: 0.45,
    );

    _cachedBuffer = buffer;
    _cachedKey = key;
    return buffer;
  }

  /// Calculates points along left and right wave curves for visual rendering at timestamp [timeSec].
  /// Returns a record with left value, right value, and interference beat amplitude in [-1.0, 1.0].
  ({double leftAmplitude, double rightAmplitude, double beatEnvelope}) getVisualizerSnapshot(double timeSec) {
    if (!_currentWave.isEnabled) {
      return (leftAmplitude: 0.0, rightAmplitude: 0.0, beatEnvelope: 0.0);
    }

    final left = math.sin(2.0 * math.pi * _currentWave.leftEarFrequency * timeSec);
    final right = math.sin(2.0 * math.pi * _currentWave.rightEarFrequency * timeSec);

    // Modulation envelope frequency is half the beat difference
    final beatEnv = math.cos(2.0 * math.pi * (_currentWave.beatFrequency / 2.0) * timeSec).abs();

    return (
      leftAmplitude: left * _currentWave.volume,
      rightAmplitude: right * _currentWave.volume,
      beatEnvelope: beatEnv * _currentWave.volume,
    );
  }
}
