import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:soundscape_layerer/core/utils/audio_math.dart';

void main() {
  group('AudioMath Tests', () {
    test('linearToDb converts 1.0 linear amplitude to 0.0 dB', () {
      expect(AudioMath.linearToDb(1.0), closeTo(0.0, 0.001));
    });

    test('linearToDb converts 0.5 linear amplitude to approximately -6.02 dB', () {
      expect(AudioMath.linearToDb(0.5), closeTo(-6.02, 0.1));
    });

    test('dbToLinear converts 0 dB to 1.0 linear amplitude', () {
      expect(AudioMath.dbToLinear(0.0), closeTo(1.0, 0.001));
    });

    test('constantPowerPan maintains acoustic power at center (0.0 pan)', () {
      final pan = AudioMath.constantPowerPan(0.0);
      // Both left and right gain should equal ~0.707 (sqrt(2)/2)
      expect(pan.leftGain, closeTo(math.sqrt(0.5), 0.01));
      expect(pan.rightGain, closeTo(math.sqrt(0.5), 0.01));
      // Total acoustic power (L^2 + R^2) should equal 1.0
      final totalPower = (pan.leftGain * pan.leftGain) + (pan.rightGain * pan.rightGain);
      expect(totalPower, closeTo(1.0, 0.001));
    });

    test('constantPowerPan hard left has 1.0 left and 0.0 right', () {
      final pan = AudioMath.constantPowerPan(-1.0);
      expect(pan.leftGain, closeTo(1.0, 0.001));
      expect(pan.rightGain, closeTo(0.0, 0.001));
    });

    test('calculateFadeMultiplier starts at 1.0 and fades to 0.0', () {
      expect(AudioMath.calculateFadeMultiplier(0.0), 1.0);
      expect(AudioMath.calculateFadeMultiplier(1.0), 0.0);
      expect(AudioMath.calculateFadeMultiplier(0.5), lessThan(0.5)); // Non-linear logarithmic falloff
    });
  });
}
