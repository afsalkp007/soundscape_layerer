import 'binaural_wave.dart';
import 'spatial_position.dart';

/// Complete configuration snapshot for saving and loading audio scenes.
class SoundPreset {
  final String id;
  final String name;
  final String description;
  final int iconCodePoint;
  final int colorHex;
  final double masterVolume;
  final Map<String, double> trackVolumes; // trackId -> volume (0.0 to 1.0)
  final Map<String, double> trackPans; // trackId -> pan (-1.0 to 1.0)
  final Map<String, bool> trackEnabled; // trackId -> isPlaying
  final Map<String, SpatialPosition> trackPositions; // trackId -> (x, y)
  final BinauralWave binauralWave;
  final DateTime createdAt;
  final bool isUserCustom;

  const SoundPreset({
    required this.id,
    required this.name,
    this.description = '',
    required this.iconCodePoint,
    required this.colorHex,
    this.masterVolume = 0.85,
    required this.trackVolumes,
    required this.trackPans,
    required this.trackEnabled,
    required this.trackPositions,
    required this.binauralWave,
    required this.createdAt,
    this.isUserCustom = false,
  });

  SoundPreset copyWith({
    String? id,
    String? name,
    String? description,
    int? iconCodePoint,
    int? colorHex,
    double? masterVolume,
    Map<String, double>? trackVolumes,
    Map<String, double>? trackPans,
    Map<String, bool>? trackEnabled,
    Map<String, SpatialPosition>? trackPositions,
    BinauralWave? binauralWave,
    DateTime? createdAt,
    bool? isUserCustom,
  }) {
    return SoundPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorHex: colorHex ?? this.colorHex,
      masterVolume: masterVolume ?? this.masterVolume,
      trackVolumes: trackVolumes ?? Map.from(this.trackVolumes),
      trackPans: trackPans ?? Map.from(this.trackPans),
      trackEnabled: trackEnabled ?? Map.from(this.trackEnabled),
      trackPositions: trackPositions ?? Map.from(this.trackPositions),
      binauralWave: binauralWave ?? this.binauralWave,
      createdAt: createdAt ?? this.createdAt,
      isUserCustom: isUserCustom ?? this.isUserCustom,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'iconCodePoint': iconCodePoint,
        'colorHex': colorHex,
        'masterVolume': masterVolume,
        'trackVolumes': trackVolumes,
        'trackPans': trackPans,
        'trackEnabled': trackEnabled,
        'trackPositions': trackPositions.map((k, v) => MapEntry(k, v.toJson())),
        'binauralWave': binauralWave.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'isUserCustom': isUserCustom,
      };

  factory SoundPreset.fromJson(Map<String, dynamic> json) {
    final positionsMap = <String, SpatialPosition>{};
    if (json['trackPositions'] != null) {
      final rawMap = json['trackPositions'] as Map<String, dynamic>;
      rawMap.forEach((k, v) {
        positionsMap[k] = SpatialPosition.fromJson(v as Map<String, dynamic>);
      });
    }

    final volumesMap = <String, double>{};
    if (json['trackVolumes'] != null) {
      (json['trackVolumes'] as Map<String, dynamic>).forEach((k, v) {
        volumesMap[k] = (v as num).toDouble();
      });
    }

    final pansMap = <String, double>{};
    if (json['trackPans'] != null) {
      (json['trackPans'] as Map<String, dynamic>).forEach((k, v) {
        pansMap[k] = (v as num).toDouble();
      });
    }

    final enabledMap = <String, bool>{};
    if (json['trackEnabled'] != null) {
      (json['trackEnabled'] as Map<String, dynamic>).forEach((k, v) {
        enabledMap[k] = v as bool;
      });
    }

    return SoundPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      iconCodePoint: json['iconCodePoint'] as int,
      colorHex: json['colorHex'] as int,
      masterVolume: (json['masterVolume'] as num?)?.toDouble() ?? 0.85,
      trackVolumes: volumesMap,
      trackPans: pansMap,
      trackEnabled: enabledMap,
      trackPositions: positionsMap,
      binauralWave: json['binauralWave'] != null
          ? BinauralWave.fromJson(json['binauralWave'] as Map<String, dynamic>)
          : const BinauralWave(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      isUserCustom: json['isUserCustom'] as bool? ?? false,
    );
  }
}
