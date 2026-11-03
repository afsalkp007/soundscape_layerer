import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../common/glass_card.dart';

/// Floating master control bar anchored at the bottom of the screen.
class MasterPlaybackBar extends StatelessWidget {
  final bool isPlaying;
  final double masterVolume;
  final String? activePresetName;
  final String? timerFormatted;
  final bool isTimerActive;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onOpenTimer;
  final VoidCallback onOpenPresets;

  const MasterPlaybackBar({
    Key? key,
    required this.isPlaying,
    required this.masterVolume,
    this.activePresetName,
    this.timerFormatted,
    this.isTimerActive = false,
    required this.onTogglePlay,
    required this.onVolumeChanged,
    required this.onOpenTimer,
    required this.onOpenPresets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GlassCard(
        borderRadius: 24.0,
        backgroundColor: AppColors.surfaceElevated.withOpacity(0.9),
        borderColor: AppColors.primary.withOpacity(0.35),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: Row(
          children: [
            // Master Play / Pause Button
            GestureDetector(
              onTap: onTogglePlay,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGlow,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.black,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Master Volume Slider
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MASTER VOLUME',
                        style: AppTypography.labelSmall.copyWith(fontSize: 8.5),
                      ),
                      Text(
                        '${(masterVolume * 100).toInt()}%',
                        style: AppTypography.monoMetric.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.surfaceHighlight,
                      thumbColor: AppColors.primary,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                      trackHeight: 3.0,
                    ),
                    child: Slider(
                      value: masterVolume,
                      onChanged: onVolumeChanged,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Sleep Timer Pill
            GestureDetector(
              onTap: onOpenTimer,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isTimerActive ? AppColors.primary.withOpacity(0.2) : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isTimerActive ? AppColors.primary : AppColors.glassBorder,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 15,
                      color: isTimerActive ? AppColors.primary : AppColors.textMuted,
                    ),
                    if (isTimerActive && timerFormatted != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        timerFormatted!,
                        style: AppTypography.monoMetric.copyWith(
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Presets Drawer Button
            GestureDetector(
              onTap: onOpenPresets,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder, width: 1.0),
                ),
                child: const Icon(
                  Icons.bookmarks_outlined,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
