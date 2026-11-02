import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/sound_track.dart';
import '../../models/spatial_position.dart';
import 'listener_avatar.dart';
import 'sound_orb_widget.dart';

/// 2D Interactive soundstage canvas allowing real-time spatial positioning of audio sources.
class SpatialSoundstage extends StatefulWidget {
  final List<SoundTrack> tracks;
  final String? selectedTrackId;
  final ValueChanged<String>? onTrackSelected;
  final void Function(String trackId, SpatialPosition position)? onTrackMoved;

  const SpatialSoundstage({
    Key? key,
    required this.tracks,
    this.selectedTrackId,
    this.onTrackSelected,
    this.onTrackMoved,
  }) : super(key: key);

  @override
  State<SpatialSoundstage> createState() => _SpatialSoundstageState();
}

class _SpatialSoundstageState extends State<SpatialSoundstage> {
  String? _draggingTrackId;

  void _handlePanStart(String trackId) {
    setState(() {
      _draggingTrackId = trackId;
    });
    widget.onTrackSelected?.call(trackId);
  }

  void _handlePanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (_draggingTrackId == null) return;

    final stageSize = math.min(constraints.maxWidth, constraints.maxHeight);
    final radius = stageSize / 2.0;

    // Convert local delta to normalized space [-1.0, 1.0]
    final dxNormalized = details.delta.dx / radius;
    final dyNormalized = details.delta.dy / radius;

    final track = widget.tracks.firstWhere((t) => t.id == _draggingTrackId);
    final currentPos = track.spatialPosition;

    final newX = (currentPos.x + dxNormalized).clamp(-1.0, 1.0);
    final newY = (currentPos.y + dyNormalized).clamp(-1.0, 1.0);

    // Keep within circular soundstage boundary (distance <= 1.0)
    final distance = math.sqrt(newX * newX + newY * newY);
    final clampedX = distance > 1.0 ? newX / distance : newX;
    final clampedY = distance > 1.0 ? newY / distance : newY;

    widget.onTrackMoved?.call(_draggingTrackId!, SpatialPosition(x: clampedX, y: clampedY));
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _draggingTrackId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stageSize = math.min(constraints.maxWidth, constraints.maxHeight) - 24;
        final radius = stageSize / 2.0;
        final center = Offset(constraints.maxWidth / 2.0, constraints.maxHeight / 2.0);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Background Radar Canvas Grid
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _RadarGridPainter(center: center, radius: radius),
            ),

            // Cardinal Direction Labels
            Positioned(
              top: center.dy - radius - 18,
              child: const Text('FRONT', style: AppTypography.labelSmall),
            ),
            Positioned(
              bottom: constraints.maxHeight - (center.dy + radius) - 18,
              child: const Text('REAR', style: AppTypography.labelSmall),
            ),
            Positioned(
              left: center.dx - radius - 28,
              top: center.dy - 7,
              child: const Text('L', style: AppTypography.labelSmall),
            ),
            Positioned(
              left: center.dx + radius + 12,
              top: center.dy - 7,
              child: const Text('R', style: AppTypography.labelSmall),
            ),

            // Center Listener Avatar
            const ListenerAvatar(size: 50.0),

            // Draggable Sound Orbs
            ...widget.tracks.map((track) {
              final posX = center.dx + (track.spatialPosition.x * radius * 0.85);
              final posY = center.dy + (track.spatialPosition.y * radius * 0.85);

              const orbWidth = 64.0;
              const orbHeight = 68.0;

              return Positioned(
                left: posX - (orbWidth / 2.0),
                top: posY - (orbHeight / 2.0),
                child: GestureDetector(
                  onPanStart: (_) => _handlePanStart(track.id),
                  onPanUpdate: (details) => _handlePanUpdate(details, constraints),
                  onPanEnd: _handlePanEnd,
                  child: SoundOrbWidget(
                    track: track,
                    isSelected: widget.selectedTrackId == track.id,
                    onTap: () => widget.onTrackSelected?.call(track.id),
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

class _RadarGridPainter extends CustomPainter {
  final Offset center;
  final double radius;

  _RadarGridPainter({required this.center, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    // Outer boundary fill
    final fillPaint = Paint()
      ..color = AppColors.surface.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fillPaint);

    // Concentric Radar Rings
    final ringPaint = Paint()
      ..color = AppColors.radarGrid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius * 0.33, ringPaint); // Near zone
    canvas.drawCircle(center, radius * 0.66, ringPaint); // Mid zone
    canvas.drawCircle(center, radius, ringPaint..color = AppColors.glassBorder); // Far boundary

    // Axis Crosshairs
    final crossPaint = Paint()
      ..color = AppColors.radarCrosshair
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Vertical line (Front-Back)
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      crossPaint,
    );

    // Horizontal line (Left-Right)
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(_RadarGridPainter oldDelegate) =>
      oldDelegate.center != center || oldDelegate.radius != radius;
}
