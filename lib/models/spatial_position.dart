import 'dart:math' as math;

/// Represents the 2D coordinate of a sound source on the soundstage.
/// The listener is fixed at center (x: 0.0, y: 0.0).
/// [x] ranges from -1.0 (far left) to 1.0 (far right).
/// [y] ranges from -1.0 (far front) to 1.0 (far behind).
class SpatialPosition {
  final double x;
  final double y;

  const SpatialPosition({
    this.x = 0.0,
    this.y = 0.0,
  });

  /// Distance from the listener located at (0, 0).
  /// Normalizes to [0.0, 1.0] within the boundary circle.
  double get distance {
    final dist = math.sqrt(x * x + y * y);
    return dist > 1.0 ? 1.0 : dist;
  }

  /// Angle in radians relative to the listener's forward orientation (0 = front).
  double get angleRadians => math.atan2(x, -y);

  /// Angle in degrees from 0° (front) clockwise.
  double get angleDegrees {
    final deg = angleRadians * (180.0 / math.pi);
    return deg < 0 ? deg + 360.0 : deg;
  }

  /// Stereo pan value calculated from x position, clamped between -1.0 (Left) and +1.0 (Right).
  double get stereoPan => x.clamp(-1.0, 1.0);

  /// Distance attenuation multiplier: sounds right next to listener have 1.0 factor,
  /// decaying gently down to minimum 0.25 at the soundstage edge.
  double get distanceAttenuation {
    final d = distance;
    return (1.0 - (d * 0.75)).clamp(0.25, 1.0);
  }

  SpatialPosition copyWith({double? x, double? y}) {
    return SpatialPosition(
      x: (x ?? this.x).clamp(-1.0, 1.0),
      y: (y ?? this.y).clamp(-1.0, 1.0),
    );
  }

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };

  factory SpatialPosition.fromJson(Map<String, dynamic> json) {
    return SpatialPosition(
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpatialPosition &&
          runtimeType == other.runtimeType &&
          (x - other.x).abs() < 0.0001 &&
          (y - other.y).abs() < 0.0001;

  @override
  int get hashCode => Object.hash(x.toStringAsFixed(4), y.toStringAsFixed(4));

  @override
  String toString() => 'SpatialPosition(x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)})';
}
