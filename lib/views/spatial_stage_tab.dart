import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/soundscape_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/neon_slider.dart';
import '../../widgets/spatial/spatial_soundstage.dart';

/// 2D interactive spatial soundstage view.
class SpatialStageTab extends StatefulWidget {
  const SpatialStageTab({Key? key}) : super(key: key);

  @override
  State<SpatialStageTab> createState() => _SpatialStageTabState();
}

class _SpatialStageTabState extends State<SpatialStageTab> {
  String? _selectedTrackId;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SoundscapeController>();
    final tracks = controller.tracks;

    // Pick selected track or default to first playing track
    final selectedTrack = tracks.firstWhere(
      (t) => t.id == _selectedTrackId,
      orElse: () => tracks.firstWhere(
        (t) => t.isPlaying,
        orElse: () => tracks.first,
      ),
    );

    return Column(
      children: [
        // Spatial Soundstage Canvas
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: SpatialSoundstage(
              tracks: tracks,
              selectedTrackId: selectedTrack.id,
              onTrackSelected: (id) => setState(() => _selectedTrackId = id),
              onTrackMoved: (id, pos) => controller.updateTrackSpatialPosition(id, pos),
            ),
          ),
        ),

        // Selected Track Inspector Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GlassCard(
            padding: const EdgeInsets.all(14.0),
            borderColor: Color(selectedTrack.colorHex).withOpacity(0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(selectedTrack.colorHex).withOpacity(0.2),
                            border: Border.all(color: Color(selectedTrack.colorHex), width: 1.2),
                          ),
                          child: Icon(
                            selectedTrack.icon,
                            size: 16,
                            color: Color(selectedTrack.colorHex),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedTrack.title,
                              style: AppTypography.titleMedium.copyWith(fontSize: 14),
                            ),
                            Text(
                              'Pan: ${selectedTrack.spatialPosition.x < 0 ? "L" : "R"} ${(selectedTrack.spatialPosition.x.abs() * 100).toInt()}%  •  Dist: ${(selectedTrack.spatialPosition.distance * 100).toInt()}%',
                              style: AppTypography.monoMetric.copyWith(fontSize: 10.5, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            selectedTrack.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                            size: 18,
                            color: selectedTrack.isMuted ? AppColors.accentCoral : AppColors.textPrimary,
                          ),
                          onPressed: () => controller.toggleTrackMute(selectedTrack.id),
                        ),
                        Switch(
                          value: selectedTrack.isPlaying,
                          onChanged: (_) => controller.toggleTrackPlay(selectedTrack.id),
                          activeColor: Color(selectedTrack.colorHex),
                        ),
                      ],
                    ),
                  ],
                ),
                if (selectedTrack.isPlaying) ...[
                  const SizedBox(height: 6),
                  NeonSlider(
                    value: selectedTrack.volume,
                    activeColor: Color(selectedTrack.colorHex),
                    label: 'LAYER VOLUME',
                    onChanged: (v) => controller.setTrackVolume(selectedTrack.id, v),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 70), // clearance for bottom dock
      ],
    );
  }
}
