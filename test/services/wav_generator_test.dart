import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:soundscape_layerer/core/utils/wav_generator.dart';

void main() {
  group('WavGenerator Tests', () {
    test('buildWav generates valid RIFF and WAVE header tags', () {
      final samples = List<double>.generate(100, (i) => 0.0);
      final wavBytes = WavGenerator.buildWav(samplesLeft: samples, sampleRate: 44100);

      expect(wavBytes.length, greaterThan(44));
      // First 4 bytes must be "RIFF"
      final riffTag = utf8.decode(wavBytes.sublist(0, 4));
      expect(riffTag, 'RIFF');

      // Bytes 8-12 must be "WAVE"
      final waveTag = utf8.decode(wavBytes.sublist(8, 12));
      expect(waveTag, 'WAVE');

      // Bytes 12-16 must be "fmt "
      final fmtTag = utf8.decode(wavBytes.sublist(12, 16));
      expect(fmtTag, 'fmt ');

      // Bytes 36-40 must be "data"
      final dataTag = utf8.decode(wavBytes.sublist(36, 40));
      expect(dataTag, 'data');
    });

    test('generateBinauralBeatWav produces stereo audio buffer', () {
      final wavBytes = WavGenerator.generateBinauralBeatWav(
        leftHz: 432.0,
        rightHz: 442.0,
        durationSeconds: 0.1,
        sampleRate: 22050,
      );

      expect(wavBytes.length, greaterThan(44));
      // 0.1s * 22050 samples * 2 channels * 2 bytes = 8820 data bytes + 44 header = 8864 bytes
      expect(wavBytes.length, 8864);
    });

    test('generateWhiteNoiseWav produces non-empty buffer', () {
      final wavBytes = WavGenerator.generateWhiteNoiseWav(
        durationSeconds: 0.05,
        sampleRate: 22050,
      );
      expect(wavBytes.length, greaterThan(44));
    });
  });
}
