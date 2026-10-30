import 'package:flutter/material.dart';
import 'sound_category.dart';
import 'spatial_position.dart';

/// Represents an ambient layer in the sound mixer.
class SoundTrack {
  final String id;
  final String title;
  final String description;
  final SoundCategory category;
  final int iconCodePoint;
  final String? iconFontFamily;
  final int colorHex;
  final double volume; // 0.0 to 1.0
  final double pan; // -1.0 (Left) to +1.0 (Right)
  final bool isPlaying;
  final bool isMuted;
  final bool isSolo;
  final SpatialPosition spatialPosition;
  final String? assetPath;
  final bool isProcedural;

  const SoundTrack({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    required this.iconCodePoint,
    this.iconFontFamily,
    required this.colorHex,
    this.volume = 0.5,
    this.pan = 0.0,
    this.isPlaying = false,
    this.isMuted = false,
    this.isSolo = false,
    this.spatialPosition = const SpatialPosition(),
    this.assetPath,
    this.isProcedural = false,
  });

  Color get color => Color(colorHex);
  IconData get icon => IconData(iconCodePoint, fontFamily: iconFontFamily ?? 'MaterialIcons');

  /// Computes effective output volume based on mute, spatial distance, and solo state.
  double computeEffectiveVolume({bool anyTrackSoloed = false}) {
    if (isMuted) return 0.0;
    if (anyTrackSoloed && !isSolo) return 0.0;
    if (!isPlaying) return 0.0;
    return (volume * spatialPosition.distanceAttenuation).clamp(0.0, 1.0);
  }

  /// Computes effective stereo pan combining slider pan and 2D spatial x-coordinate.
  double get effectivePan {
    final combined = pan + spatialPosition.stereoPan;
    return combined.clamp(-1.0, 1.0);
  }

  SoundTrack copyWith({
    String? id,
    String? title,
    String? description,
    SoundCategory? category,
    int? iconCodePoint,
    String? iconFontFamily,
    int? colorHex,
    double? volume,
    double? pan,
    bool? isPlaying,
    bool? isMuted,
    bool? isSolo,
    SpatialPosition? spatialPosition,
    String? assetPath,
    bool? isProcedural,
  }) {
    return SoundTrack(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      colorHex: colorHex ?? this.colorHex,
      volume: (volume ?? this.volume).clamp(0.0, 1.0),
      pan: (pan ?? this.pan).clamp(-1.0, 1.0),
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      isSolo: isSolo ?? this.isSolo,
      spatialPosition: spatialPosition ?? this.spatialPosition,
      assetPath: assetPath ?? this.assetPath,
      isProcedural: isProcedural ?? this.isProcedural,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.name,
        'iconCodePoint': iconCodePoint,
        'iconFontFamily': iconFontFamily,
        'colorHex': colorHex,
        'volume': volume,
        'pan': pan,
        'isPlaying': isPlaying,
        'isMuted': isMuted,
        'isSolo': isSolo,
        'spatialPosition': spatialPosition.toJson(),
        'assetPath': assetPath,
        'isProcedural': isProcedural,
      };

  factory SoundTrack.fromJson(Map<String, dynamic> json) {
    return SoundTrack(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: SoundCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => SoundCategory.nature,
      ),
      iconCodePoint: json['iconCodePoint'] as int,
      iconFontFamily: json['iconFontFamily'] as String?,
      colorHex: json['colorHex'] as int,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.5,
      pan: (json['pan'] as num?)?.toDouble() ?? 0.0,
      isPlaying: json['isPlaying'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      isSolo: json['isSolo'] as bool? ?? false,
      spatialPosition: json['spatialPosition'] != null
          ? SpatialPosition.fromJson(json['spatialPosition'] as Map<String, dynamic>)
          : const SpatialPosition(),
      assetPath: json['assetPath'] as String?,
      isProcedural: json['isProcedural'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoundTrack &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          volume == other.volume &&
          pan == other.pan &&
          isPlaying == other.isPlaying &&
          isMuted == other.isMuted &&
          isSolo == other.isSolo &&
          spatialPosition == other.spatialPosition;

  @override
  int get hashCode => Object.hash(id, volume, pan, isPlaying, isMuted, isSolo, spatialPosition);
}
