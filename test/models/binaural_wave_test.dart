import 'package:flutter_test/flutter_test.dart';
import 'package:soundscape_layerer/models/binaural_wave.dart';

void main() {
  group('BinauralWave Tests', () {
    test('calculates correct left and right ear frequencies', () {
      // 432 Hz carrier with 10 Hz Alpha beat
      // Left = 432 - 5 = 427 Hz, Right = 432 + 5 = 437 Hz
      const wave = BinauralWave(
        band: BrainwaveBand.alpha,
        carrierFrequency: 432.0,
        beatFrequency: 10.0,
      );

      expect(wave.leftEarFrequency, 427.0);
      expect(wave.rightEarFrequency, 437.0);
    });

    test('copyWith clamps beat frequency within band limits', () {
      const wave = BinauralWave(band: BrainwaveBand.delta); // 0.5 - 4.0 Hz
      final updated = wave.copyWith(beatFrequency: 9.0); // should clamp to 4.0

      expect(updated.beatFrequency, 4.0);
    });

    test('JSON serialization preserves full configuration', () {
      const wave = BinauralWave(
        isEnabled: true,
        band: BrainwaveBand.theta,
        beatFrequency: 5.5,
        carrierFrequency: 528.0,
        volume: 0.75,
        isIsochronic: true,
      );

      final json = wave.toJson();
      final restored = BinauralWave.fromJson(json);

      expect(restored.isEnabled, true);
      expect(restored.band, BrainwaveBand.theta);
      expect(restored.beatFrequency, closeTo(5.5, 0.001));
      expect(restored.carrierFrequency, closeTo(528.0, 0.001));
      expect(restored.volume, closeTo(0.75, 0.001));
      expect(restored.isIsochronic, true);
    });
  });
}
