import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/sound_track.dart';
import '../common/pulsating_glow.dart';

/// Draggable sound orb positioned on the 2D spatial canvas.
class SoundOrbWidget extends StatelessWidget {
  final SoundTrack track;
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;

  const SoundOrbWidget({
    Key? key,
    required this.track,
    this.isSelected = false,
    this.onTap,
    this.size = 46.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orbColor = track.isPlaying
        ? Color(track.colorHex)
        : AppColors.textDisabled;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PulsatingGlow(
            glowColor: orbColor,
            isPulsing: track.isPlaying,
            maxRadius: 18.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: track.isPlaying ? AppColors.surfaceElevated : AppColors.surface,
                border: Border.all(
                  color: isSelected ? Colors.white : orbColor,
                  width: isSelected ? 2.5 : 1.8,
                ),
                boxShadow: track.isPlaying
                    ? [
                        BoxShadow(
                          color: orbColor.withOpacity(0.35),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Icon(
                  track.icon,
                  size: size * 0.48,
                  color: orbColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? orbColor : Colors.transparent,
                width: 0.8,
              ),
            ),
            child: Text(
              track.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: track.isPlaying ? AppColors.textPrimary : AppColors.textDisabled,
                fontSize: 9.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
