import 'dart:math' as math;
import 'dart:typed_data';

/// In-memory RIFF/WAVE PCM synthesizer that creates valid stereo/mono WAV byte arrays.
class WavGenerator {
  WavGenerator._();

  static const int defaultSampleRate = 44100;

  /// Builds a valid RIFF/WAVE 16-bit PCM byte array from raw audio samples.
  /// [samplesLeft] and [samplesRight] must have identical length for stereo.
  /// Sample values should be in range [-1.0, 1.0].
  static Uint8List buildWav({
    required List<double> samplesLeft,
    List<double>? samplesRight,
    int sampleRate = defaultSampleRate,
  }) {
    final isStereo = samplesRight != null && samplesRight.isNotEmpty;
    final numChannels = isStereo ? 2 : 1;
    final numSamples = samplesLeft.length;
    final bytesPerSample = 2; // 16-bit PCM
    final dataSize = numSamples * numChannels * bytesPerSample;
    final fileSize = 36 + dataSize;

    final byteData = ByteData(44 + dataSize);

    // RIFF chunk descriptor
    _writeString(byteData, 0, 'RIFF');
    byteData.setUint32(4, fileSize, Endian.little);
    _writeString(byteData, 8, 'WAVE');

    // "fmt " sub-chunk
    _writeString(byteData, 12, 'fmt ');
    byteData.setUint32(16, 16, Endian.little); // Subchunk1Size (16 for PCM)
    byteData.setUint16(20, 1, Endian.little); // AudioFormat (1 = PCM)
    byteData.setUint16(22, numChannels, Endian.little);
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, sampleRate * numChannels * bytesPerSample, Endian.little); // ByteRate
    byteData.setUint16(32, numChannels * bytesPerSample, Endian.little); // BlockAlign
    byteData.setUint16(34, 16, Endian.little); // BitsPerSample

    // "data" sub-chunk
    _writeString(byteData, 36, 'data');
    byteData.setUint32(40, dataSize, Endian.little);

    // Interleave and write 16-bit signed PCM samples (-32768 to 32767)
    int offset = 44;
    for (int i = 0; i < numSamples; i++) {
      final sL = (samplesLeft[i].clamp(-1.0, 1.0) * 32767.0).toInt();
      byteData.setInt16(offset, sL, Endian.little);
      offset += 2;

      if (isStereo) {
        final sR = (samplesRight[i].clamp(-1.0, 1.0) * 32767.0).toInt();
        byteData.setInt16(offset, sR, Endian.little);
        offset += 2;
      }
    }

    return byteData.buffer.asUint8List();
  }

  /// Synthesizes stereo binaural tones with independent left and right frequencies.
  /// Applies subtle cross-fade at ends to eliminate looping clicks.
  static Uint8List generateBinauralBeatWav({
    required double leftHz,
    required double rightHz,
    double durationSeconds = 3.0,
    double amplitude = 0.5,
    int sampleRate = defaultSampleRate,
  }) {
    final numSamples = (durationSeconds * sampleRate).toInt();
    final left = List<double>.filled(numSamples, 0.0);
    final right = List<double>.filled(numSamples, 0.0);

    final fadeSamples = (0.05 * sampleRate).toInt(); // 50ms fade envelope

    for (int i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      double l = amplitude * math.sin(2.0 * math.pi * leftHz * t);
      double r = amplitude * math.sin(2.0 * math.pi * rightHz * t);

      // Boundary fade-in and fade-out
      if (i < fadeSamples) {
        final env = i / fadeSamples;
        l *= env;
        r *= env;
      } else if (i > numSamples - fadeSamples) {
        final env = (numSamples - i) / fadeSamples;
        l *= env;
        r *= env;
      }

      left[i] = l;
      right[i] = r;
    }

    return buildWav(samplesLeft: left, samplesRight: right, sampleRate: sampleRate);
  }

  /// Generates pure White Noise buffer with smooth boundary cross-fading.
  static Uint8List generateWhiteNoiseWav({
    double durationSeconds = 2.0,
    double amplitude = 0.4,
    int sampleRate = 22050,
  }) {
    final rng = math.Random(42);
    final numSamples = (durationSeconds * sampleRate).toInt();
    final left = List<double>.filled(numSamples, 0.0);
    final right = List<double>.filled(numSamples, 0.0);
    final fade = (0.05 * sampleRate).toInt();

    for (int i = 0; i < numSamples; i++) {
      double l = (rng.nextDouble() * 2.0 - 1.0) * amplitude;
      double r = (rng.nextDouble() * 2.0 - 1.0) * amplitude;

      if (i < fade) {
        final env = i / fade;
        l *= env;
        r *= env;
      } else if (i > numSamples - fade) {
        final env = (numSamples - i) / fade;
        l *= env;
        r *= env;
      }

      left[i] = l;
      right[i] = r;
    }

    return buildWav(samplesLeft: left, samplesRight: right, sampleRate: sampleRate);
  }

  /// Generates Pink Noise (1/f spectral decay) using Paul Kellet's filtered IIR method.
  static Uint8List generatePinkNoiseWav({
    double durationSeconds = 2.0,
    double amplitude = 0.45,
    int sampleRate = 22050,
  }) {
    final rng = math.Random(1337);
    final numSamples = (durationSeconds * sampleRate).toInt();
    final left = List<double>.filled(numSamples, 0.0);
    final right = List<double>.filled(numSamples, 0.0);
    final fade = (0.05 * sampleRate).toInt();

    double b0 = 0, b1 = 0, b2 = 0, b3 = 0, b4 = 0, b5 = 0, b6 = 0;
    double rb0 = 0, rb1 = 0, rb2 = 0, rb3 = 0, rb4 = 0, rb5 = 0, rb6 = 0;

    for (int i = 0; i < numSamples; i++) {
      final whiteL = rng.nextDouble() * 2.0 - 1.0;
      final whiteR = rng.nextDouble() * 2.0 - 1.0;

      // Kellet filter left
      b0 = 0.99886 * b0 + whiteL * 0.0555179;
      b1 = 0.99332 * b1 + whiteL * 0.0750759;
      b2 = 0.96900 * b2 + whiteL * 0.1538520;
      b3 = 0.86650 * b3 + whiteL * 0.3104856;
      b4 = 0.55000 * b4 + whiteL * 0.5329522;
      b5 = -0.7616 * b5 - whiteL * 0.0168980;
      double pinkL = (b0 + b1 + b2 + b3 + b4 + b5 + b6 + whiteL * 0.5362) * 0.11 * amplitude;
      b6 = whiteL * 0.115926;

      // Kellet filter right
      rb0 = 0.99886 * rb0 + whiteR * 0.0555179;
      rb1 = 0.99332 * rb1 + whiteR * 0.0750759;
      rb2 = 0.96900 * rb2 + whiteR * 0.1538520;
      rb3 = 0.86650 * rb3 + whiteR * 0.3104856;
      rb4 = 0.55000 * rb4 + whiteR * 0.5329522;
      rb5 = -0.7616 * rb5 - whiteR * 0.0168980;
      double pinkR = (rb0 + rb1 + rb2 + rb3 + rb4 + rb5 + rb6 + whiteR * 0.5362) * 0.11 * amplitude;
      rb6 = whiteR * 0.115926;

      if (i < fade) {
        final env = i / fade;
        pinkL *= env;
        pinkR *= env;
      } else if (i > numSamples - fade) {
        final env = (numSamples - i) / fade;
        pinkL *= env;
        pinkR *= env;
      }

      left[i] = pinkL;
      right[i] = pinkR;
    }

    return buildWav(samplesLeft: left, samplesRight: right, sampleRate: sampleRate);
  }

  /// Generates Brownian/Red Noise (1/f^2 spectral decay) via leaky integration.
  static Uint8List generateBrownNoiseWav({
    double durationSeconds = 2.0,
    double amplitude = 0.5,
    int sampleRate = 22050,
  }) {
    final rng = math.Random(777);
    final numSamples = (durationSeconds * sampleRate).toInt();
    final left = List<double>.filled(numSamples, 0.0);
    final right = List<double>.filled(numSamples, 0.0);
    final fade = (0.05 * sampleRate).toInt();

    double lastLeft = 0.0;
    double lastRight = 0.0;

    for (int i = 0; i < numSamples; i++) {
      final whiteL = rng.nextDouble() * 2.0 - 1.0;
      final whiteR = rng.nextDouble() * 2.0 - 1.0;

      // Leaky integrator to avoid DC offset runaway
      lastLeft = (lastLeft + (0.02 * whiteL)) / 1.02;
      lastRight = (lastRight + (0.02 * whiteR)) / 1.02;

      double bL = lastLeft * 3.5 * amplitude;
      double bR = lastRight * 3.5 * amplitude;

      if (i < fade) {
        final env = i / fade;
        bL *= env;
        bR *= env;
      } else if (i > numSamples - fade) {
        final env = (numSamples - i) / fade;
        bL *= env;
        bR *= env;
      }

      left[i] = bL;
      right[i] = bR;
    }

    return buildWav(samplesLeft: left, samplesRight: right, sampleRate: sampleRate);
  }

  static void _writeString(ByteData data, int offset, String value) {
    for (int i = 0; i < value.length; i++) {
      data.setUint8(offset + i, value.codeUnitAt(i));
    }
  }
}
