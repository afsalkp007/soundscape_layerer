import 'package:flutter/material.dart';
import '../../models/binaural_wave.dart';
import '../../models/sound_preset.dart';
import '../../models/spatial_position.dart';

/// Pre-engineered soundscape presets optimized for specific cognitive states.
class FactoryPresets {
  FactoryPresets._();

  static List<SoundPreset> get presets => [
        SoundPreset(
          id: 'preset_deep_sleep',
          name: 'Deep Sleep & Ocean Theta',
          description: 'Rhythmic ocean swells and gentle rain paired with a 5.0 Hz Theta wave for REM transitions',
          iconCodePoint: Icons.bedtime_outlined.codePoint,
          colorHex: 0xFF38BDF8,
          masterVolume: 0.8,
          trackVolumes: {
            'ocean_waves': 0.65,
            'rain_gentle': 0.40,
            'brown_noise': 0.30,
          },
          trackPans: {
            'ocean_waves': 0.0,
            'rain_gentle': -0.3,
            'brown_noise': 0.0,
          },
          trackEnabled: {
            'ocean_waves': true,
            'rain_gentle': true,
            'brown_noise': true,
            'campfire_crackling': false,
          },
          trackPositions: {
            'ocean_waves': const SpatialPosition(x: 0.0, y: -0.6),
            'rain_gentle': const SpatialPosition(x: -0.4, y: -0.4),
            'brown_noise': const SpatialPosition(x: 0.0, y: 0.1),
          },
          binauralWave: const BinauralWave(
            isEnabled: true,
            band: BrainwaveBand.theta,
            beatFrequency: 5.0,
            carrierFrequency: 432.0,
            volume: 0.55,
          ),
          createdAt: DateTime(2026, 10, 30),
          isUserCustom: false,
        ),
        SoundPreset(
          id: 'preset_rainy_cafe',
          name: 'Rainy Café Flow Alpha',
          description: 'Cozy coffee shop ambiance backed by warm rain and 10.0 Hz Alpha wave for sustained concentration',
          iconCodePoint: Icons.local_cafe_outlined.codePoint,
          colorHex: 0xFFFB923C,
          masterVolume: 0.85,
          trackVolumes: {
            'cafe_murmurs': 0.45,
            'rain_gentle': 0.60,
          },
          trackPans: {
            'cafe_murmurs': -0.4,
            'rain_gentle': 0.3,
          },
          trackEnabled: {
            'cafe_murmurs': true,
            'rain_gentle': true,
          },
          trackPositions: {
            'cafe_murmurs': const SpatialPosition(x: -0.5, y: 0.3),
            'rain_gentle': const SpatialPosition(x: 0.4, y: -0.4),
          },
          binauralWave: const BinauralWave(
            isEnabled: true,
            band: BrainwaveBand.alpha,
            beatFrequency: 10.0,
            carrierFrequency: 528.0,
            volume: 0.5,
          ),
          createdAt: DateTime(2026, 10, 30),
          isUserCustom: false,
        ),
        SoundPreset(
          id: 'preset_campfire_delta',
          name: 'Campfire Stargaze Delta',
          description: 'Crackling campfire under night crickets paired with deep 2.5 Hz Delta restorative frequency',
          iconCodePoint: Icons.nightlight_round_outlined.codePoint,
          colorHex: 0xFFF59E0B,
          masterVolume: 0.75,
          trackVolumes: {
            'campfire_crackling': 0.55,
            'forest_night': 0.50,
          },
          trackPans: {
            'campfire_crackling': 0.3,
            'forest_night': -0.3,
          },
          trackEnabled: {
            'campfire_crackling': true,
            'forest_night': true,
          },
          trackPositions: {
            'campfire_crackling': const SpatialPosition(x: 0.4, y: -0.2),
            'forest_night': const SpatialPosition(x: -0.5, y: 0.4),
          },
          binauralWave: const BinauralWave(
            isEnabled: true,
            band: BrainwaveBand.delta,
            beatFrequency: 2.5,
            carrierFrequency: 174.0,
            volume: 0.6,
          ),
          createdAt: DateTime(2026, 10, 30),
          isUserCustom: false,
        ),
        SoundPreset(
          id: 'preset_gamma_hyperfocus',
          name: 'Gamma Superlearning Lab',
          description: 'High-frequency 40.0 Hz Gamma wave coupled with pink noise and celestial tones for peak cognitive bandwidth',
          iconCodePoint: Icons.bolt_outlined.codePoint,
          colorHex: 0xFFFF4081,
          masterVolume: 0.85,
          trackVolumes: {
            'pink_noise': 0.40,
            'celestial_drone': 0.45,
          },
          trackPans: {
            'pink_noise': 0.0,
            'celestial_drone': 0.0,
          },
          trackEnabled: {
            'pink_noise': true,
            'celestial_drone': true,
          },
          trackPositions: {
            'pink_noise': const SpatialPosition(x: 0.0, y: -0.2),
            'celestial_drone': const SpatialPosition(x: 0.0, y: 0.6),
          },
          binauralWave: const BinauralWave(
            isEnabled: true,
            band: BrainwaveBand.gamma,
            beatFrequency: 40.0,
            carrierFrequency: 639.0,
            volume: 0.55,
          ),
          createdAt: DateTime(2026, 10, 30),
          isUserCustom: false,
        ),
      ];
}
