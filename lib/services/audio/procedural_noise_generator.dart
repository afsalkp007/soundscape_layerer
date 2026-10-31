import 'dart:typed_data';
import '../../core/utils/wav_generator.dart';

/// Supported types of procedural noise.
enum NoiseColor {
  white,
  pink,
  brown,
}

/// Factory service producing procedural acoustic noise audio buffers.
class ProceduralNoiseGenerator {
  final Map<NoiseColor, Uint8List> _cache = {};

  /// Retrieves or synthesizes a cached seamless audio loop for the specified noise color.
  Uint8List getNoiseBuffer(NoiseColor color, {double durationSeconds = 2.5}) {
    if (_cache.containsKey(color)) {
      return _cache[color]!;
    }

    final Uint8List buffer;
    switch (color) {
      case NoiseColor.white:
        buffer = WavGenerator.generateWhiteNoiseWav(
          durationSeconds: durationSeconds,
          amplitude: 0.35,
        );
        break;
      case NoiseColor.pink:
        buffer = WavGenerator.generatePinkNoiseWav(
          durationSeconds: durationSeconds,
          amplitude: 0.40,
        );
        break;
      case NoiseColor.brown:
        buffer = WavGenerator.generateBrownNoiseWav(
          durationSeconds: durationSeconds,
          amplitude: 0.45,
        );
        break;
    }

    _cache[color] = buffer;
    return buffer;
  }

  void clearCache() {
    _cache.clear();
  }
}
