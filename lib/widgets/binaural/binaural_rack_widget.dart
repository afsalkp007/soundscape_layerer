import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/binaural_wave.dart';
import '../common/glass_card.dart';
import '../common/neon_slider.dart';
import 'frequency_visualizer.dart';
import 'wave_band_selector.dart';

/// Full interactive Binaural Beat synthesizer console rack.
class BinauralRackWidget extends StatelessWidget {
  final BinauralWave wave;
  final ValueChanged<bool> onToggleEnabled;
  final ValueChanged<BrainwaveBand> onSelectBand;
  final ValueChanged<double> onBeatFrequencyChanged;
  final ValueChanged<double> onCarrierFrequencyChanged;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<bool> onToggleIsochronic;

  const BinauralRackWidget({
    Key? key,
    required this.wave,
    required this.onToggleEnabled,
    required this.onSelectBand,
    required this.onBeatFrequencyChanged,
    required this.onCarrierFrequencyChanged,
    required this.onVolumeChanged,
    required this.onToggleIsochronic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header & Master Power Switch
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology_outlined, size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Binaural Beat Engine', style: AppTypography.titleLarge.copyWith(fontSize: 17)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    wave.band.targetBenefit,
                    style: AppTypography.bodySmall.copyWith(fontSize: 11, color: wave.band.color),
                  ),
                ],
              ),
              Switch(
                value: wave.isEnabled,
                onChanged: onToggleEnabled,
                activeColor: wave.band.color,
                activeTrackColor: wave.band.color.withOpacity(0.3),
              ),
            ],
          ),
        ),

        // Animated Dual Wave Visualizer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: FrequencyVisualizer(wave: wave),
        ),

        const SizedBox(height: 8),

        // Brainwave Band Selection Strip
        WaveBandSelector(
          selectedBand: wave.band,
          onBandSelected: onSelectBand,
        ),

        const SizedBox(height: 12),

        // Tuning Sliders
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GlassCard(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Beat Frequency Slider
                NeonSlider(
                  label: 'TARGET BEAT FREQUENCY',
                  value: wave.beatFrequency,
                  min: wave.band.minHz,
                  max: wave.band.maxHz,
                  activeColor: wave.band.color,
                  prefixIcon: Icons.speed_outlined,
                  valueFormatter: (hz) => '${hz.toStringAsFixed(1)} Hz',
                  onChanged: onBeatFrequencyChanged,
                ),

                const SizedBox(height: 12),

                // Carrier Frequency Slider
                NeonSlider(
                  label: 'CARRIER TONE FREQUENCY',
                  value: wave.carrierFrequency,
                  min: 100.0,
                  max: 963.0,
                  activeColor: AppColors.primary,
                  prefixIcon: Icons.music_note_outlined,
                  valueFormatter: (hz) => '${hz.toInt()} Hz',
                  onChanged: onCarrierFrequencyChanged,
                ),

                const SizedBox(height: 8),

                // Solfeggio Quick Carrier Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: CarrierPreset.presets.map((preset) {
                      final isSelected = (wave.carrierFrequency - preset.frequency).abs() < 1.0;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ChoiceChip(
                          label: Text(preset.name),
                          selected: isSelected,
                          onSelected: (_) => onCarrierFrequencyChanged(preset.frequency),
                          selectedColor: AppColors.primary.withOpacity(0.25),
                          backgroundColor: AppColors.surface,
                          labelStyle: AppTypography.monoMetric.copyWith(
                            fontSize: 10,
                            color: isSelected ? AppColors.primary : AppColors.textMuted,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.glassBorder,
                              width: 0.8,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 14),

                // Binaural Volume Slider & Isochronic Switch
                Row(
                  children: [
                    Expanded(
                      child: NeonSlider(
                        label: 'BINAURAL GAIN',
                        value: wave.volume,
                        min: 0.0,
                        max: 1.0,
                        activeColor: wave.band.color,
                        prefixIcon: Icons.volume_up_outlined,
                        onChanged: onVolumeChanged,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text('ISOCHRONIC', style: AppTypography.labelSmall.copyWith(fontSize: 9)),
                        Switch(
                          value: wave.isIsochronic,
                          onChanged: onToggleIsochronic,
                          activeColor: AppColors.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
