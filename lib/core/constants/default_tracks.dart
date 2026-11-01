import 'package:flutter/material.dart';
import '../../models/sound_category.dart';
import '../../models/sound_track.dart';
import '../../models/spatial_position.dart';

/// Catalog of default ambient and acoustic layers available in SoundScape Layerer.
class DefaultTracks {
  DefaultTracks._();

  static List<SoundTrack> get catalog => [
        SoundTrack(
          id: 'rain_gentle',
          title: 'Gentle Rain',
          description: 'Soft continuous rain patter on glass and leaves',
          category: SoundCategory.water,
          iconCodePoint: Icons.grain_outlined.codePoint,
          colorHex: 0xFF38BDF8, // Sky Blue
          volume: 0.65,
          pan: -0.2,
          isPlaying: true,
          spatialPosition: const SpatialPosition(x: -0.35, y: -0.5),
        ),
        SoundTrack(
          id: 'thunder_distant',
          title: 'Distant Thunder',
          description: 'Low rumbling ambient thunder in the distance',
          category: SoundCategory.nature,
          iconCodePoint: Icons.flash_on_outlined.codePoint,
          colorHex: 0xFF818CF8, // Indigo
          volume: 0.40,
          pan: 0.4,
          isPlaying: false,
          spatialPosition: const SpatialPosition(x: 0.6, y: -0.7),
        ),
        SoundTrack(
          id: 'ocean_waves',
          title: 'Ocean Surf',
          description: 'Rhythmic ocean swells breaking on sand',
          category: SoundCategory.water,
          iconCodePoint: Icons.waves_outlined.codePoint,
          colorHex: 0xFF22D3EE, // Cyan
          volume: 0.55,
          pan: 0.0,
          isPlaying: false,
          spatialPosition: const SpatialPosition(x: 0.0, y: -0.65),
        ),
        SoundTrack(
          id: 'forest_night',
          title: 'Night Forest',
          description: 'Peaceful crickets, gentle canopy breeze and night birds',
          category: SoundCategory.nature,
          iconCodePoint: Icons.nights_stay_outlined.codePoint,
          colorHex: 0xFF34D399, // Emerald
          volume: 0.45,
          pan: -0.5,
          isPlaying: false,
          spatialPosition: const SpatialPosition(x: -0.6, y: 0.3),
        ),
        SoundTrack(
          id: 'campfire_crackling',
          title: 'Campfire',
          description: 'Warm firewood embers and gentle wood snapping',
          category: SoundCategory.nature,
          iconCodePoint: Icons.local_fire_department_outlined.codePoint,
          colorHex: 0xFFF59E0B, // Amber
          volume: 0.50,
          pan: 0.3,
          isPlaying: true,
          spatialPosition: const SpatialPosition(x: 0.45, y: -0.2),
        ),
        SoundTrack(
          id: 'wind_chimes',
          title: 'Wind Chimes',
          description: 'Delicate tuned bamboo and metal chimes in light breeze',
          category: SoundCategory.melodic,
          iconCodePoint: Icons.notifications_none_outlined.codePoint,
          colorHex: 0xFF2DD4BF, // Teal
          volume: 0.30,
          pan: 0.5,
          isPlaying: false,
          spatialPosition: const SpatialPosition(x: 0.7, y: 0.4),
        ),
        SoundTrack(
          id: 'cafe_murmurs',
          title: 'Café Murmur',
          description: 'Subtle background conversation and coffee shop warmth',
          category: SoundCategory.urban,
          iconCodePoint: Icons.local_cafe_outlined.codePoint,
          colorHex: 0xFFFB923C, // Orange
          volume: 0.35,
          pan: -0.4,
          isPlaying: false,
          spatialPosition: const SpatialPosition(x: -0.5, y: 0.5),
        ),
        SoundTrack(
          id: 'celestial_drone',
          title: 'Celestial Drone',
          description: 'Deep resonant ambient drone pad tuned to 432 Hz',
          category: SoundCategory.melodic,
          iconCodePoint: Icons.blur_on_outlined.codePoint,
          colorHex: 0xFFA78BFA, // Purple
          volume: 0.50,
          pan: 0.0,
          isPlaying: false,
          spatialPosition: const SpatialPosition(x: 0.0, y: 0.7),
        ),
        SoundTrack(
          id: 'brown_noise',
          title: 'Brown Noise',
          description: 'Deep waterfall rumble for sleep and focus',
          category: SoundCategory.noise,
          iconCodePoint: Icons.graphic_eq_outlined.codePoint,
          colorHex: 0xFFEA580C, // Deep Orange
          volume: 0.50,
          pan: 0.0,
          isPlaying: false,
          isProcedural: true,
          spatialPosition: const SpatialPosition(x: 0.0, y: -0.1),
        ),
        SoundTrack(
          id: 'pink_noise',
          title: 'Pink Noise',
          description: 'Balanced 1/f noise for steady concentration',
          category: SoundCategory.noise,
          iconCodePoint: Icons.tune_outlined.codePoint,
          colorHex: 0xFFF472B6, // Pink
          volume: 0.40,
          pan: 0.0,
          isPlaying: false,
          isProcedural: true,
          spatialPosition: const SpatialPosition(x: -0.2, y: 0.2),
        ),
      ];
}
