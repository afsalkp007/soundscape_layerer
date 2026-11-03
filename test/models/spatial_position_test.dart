import 'package:flutter_test/flutter_test.dart';
import 'package:soundscape_layerer/models/spatial_position.dart';

void main() {
  group('SpatialPosition Tests', () {
    test('center position has 0 distance and 0 pan', () {
      const pos = SpatialPosition(x: 0.0, y: 0.0);
      expect(pos.distance, 0.0);
      expect(pos.stereoPan, 0.0);
      expect(pos.distanceAttenuation, 1.0);
    });

    test('hard left position clamps pan to -1.0', () {
      const pos = SpatialPosition(x: -1.0, y: 0.0);
      expect(pos.distance, 1.0);
      expect(pos.stereoPan, -1.0);
      expect(pos.distanceAttenuation, 0.25);
    });

    test('hard right position clamps pan to 1.0', () {
      const pos = SpatialPosition(x: 1.0, y: 0.0);
      expect(pos.distance, 1.0);
      expect(pos.stereoPan, 1.0);
    });

    test('angle calculations for cardinal directions', () {
      const front = SpatialPosition(x: 0.0, y: -1.0);
      expect(front.angleDegrees, closeTo(0.0, 0.1));

      const right = SpatialPosition(x: 1.0, y: 0.0);
      expect(right.angleDegrees, closeTo(90.0, 0.1));

      const back = SpatialPosition(x: 0.0, y: 1.0);
      expect(back.angleDegrees, closeTo(180.0, 0.1));

      const left = SpatialPosition(x: -1.0, y: 0.0);
      expect(left.angleDegrees, closeTo(270.0, 0.1));
    });

    test('toJson and fromJson preserve values', () {
      const pos = SpatialPosition(x: 0.45, y: -0.65);
      final json = pos.toJson();
      final restored = SpatialPosition.fromJson(json);

      expect(restored.x, closeTo(0.45, 0.001));
      expect(restored.y, closeTo(-0.65, 0.001));
    });
  });
}
