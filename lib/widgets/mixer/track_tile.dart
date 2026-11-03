import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/audio_math.dart';
import '../../models/sound_track.dart';
import '../common/glass_card.dart';
import '../common/neon_slider.dart';
import 'volume_knob.dart';

/// Single channel strip tile representing an ambient audio layer.
class TrackTile extends StatelessWidget {
  final SoundTrack track;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<double> onPanChanged;
  final VoidCallback onTogglePlay;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleSolo;

  const TrackTile({
    Key? key,
    required this.track,
    required this.onVolumeChanged,
    required this.onPanChanged,
    required this.onTogglePlay,
    required this.onToggleMute,
    required this.onToggleSolo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trackColor = Color(track.colorHex);
    final db = AudioMath.linearToDb(track.volume);

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      borderColor: track.isPlaying ? trackColor.withOpacity(0.4) : AppColors.glassBorder,
      child: Column(
        children: [
          // Track Header: Icon, Title, Mute, Solo, and Playback Switch
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: track.isPlaying ? trackColor.withOpacity(0.18) : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: track.isPlaying ? trackColor : AppColors.glassBorder,
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  track.icon,
                  size: 18,
                  color: track.isPlaying ? trackColor : AppColors.textDisabled,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: AppTypography.titleMedium.copyWith(
                        color: track.isPlaying ? AppColors.textPrimary : AppColors.textDisabled,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      track.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              // Solo Button
              _buildMiniButton(
                label: 'S',
                isActive: track.isSolo,
                activeColor: AppColors.accentAmber,
                onTap: onToggleSolo,
              ),
              const SizedBox(width: 6),
              // Mute Button
              _buildMiniButton(
                label: 'M',
                isActive: track.isMuted,
                activeColor: AppColors.accentCoral,
                onTap: onToggleMute,
              ),
              const SizedBox(width: 8),
              // Power Switch
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: track.isPlaying,
                  onChanged: (_) => onTogglePlay(),
                  activeColor: trackColor,
                  activeTrackColor: trackColor.withOpacity(0.35),
                ),
              ),
            ],
          ),

          if (track.isPlaying) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                // Volume Fader Slider
                Expanded(
                  child: NeonSlider(
                    value: track.volume,
                    activeColor: trackColor,
                    label: 'VOLUME',
                    valueFormatter: (_) => '${db.toStringAsFixed(1)} dB',
                    onChanged: onVolumeChanged,
                  ),
                ),
                const SizedBox(width: 12),
                // Stereo Pan Knob
                VolumeKnob(
                  value: track.pan,
                  min: -1.0,
                  max: 1.0,
                  activeColor: trackColor,
                  label: _panLabel(track.pan),
                  size: 44.0,
                  onChanged: onPanChanged,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _panLabel(double pan) {
    if (pan.abs() < 0.05) return 'CENTER';
    if (pan < 0) return 'L ${(pan.abs() * 100).toInt()}%';
    return 'R ${(pan * 100).toInt()}%';
  }

  Widget _buildMiniButton({
    required String label,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.2) : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive ? activeColor : AppColors.glassBorder,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.monoMetric.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isActive ? activeColor : AppColors.textDisabled,
            ),
          ),
        ),
      ),
    );
  }
}
