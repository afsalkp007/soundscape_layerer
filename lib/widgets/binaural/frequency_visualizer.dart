import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/binaural_wave.dart';

/// Real-time animated canvas visualizer showing Left (Cyan), Right (Violet),
/// and the perceptual Binaural interference envelope.
class FrequencyVisualizer extends StatefulWidget {
  final BinauralWave wave;
  final double height;

  const FrequencyVisualizer({
    Key? key,
    required this.wave,
    this.height = 110.0,
  }) : super(key: key);

  @override
  State<FrequencyVisualizer> createState() => _FrequencyVisualizerState();
}

class _FrequencyVisualizerState extends State<FrequencyVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder, width: 1.0),
      ),
      child: Stack(
        children: [
          // Background Centerline
          Center(
            child: Container(
              height: 1,
              color: AppColors.glassBorder.withOpacity(0.3),
            ),
          ),

          // Animated Waves Canvas
          AnimatedBuilder(
            animation: _animController,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: _WaveformPainter(
                  wave: widget.wave,
                  phase: _animController.value * 2 * math.pi,
                ),
              );
            },
          ),

          // Frequency Indicators Overlay
          Positioned(
            top: 8,
            left: 12,
            child: Row(
              children: [
                _buildChannelBadge('L', '${widget.wave.leftEarFrequency.toStringAsFixed(1)} Hz', AppColors.primary),
                const SizedBox(width: 8),
                _buildChannelBadge('R', '${widget.wave.rightEarFrequency.toStringAsFixed(1)} Hz', AppColors.secondary),
              ],
            ),
          ),

          Positioned(
            bottom: 8,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: widget.wave.band.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: widget.wave.band.color, width: 0.8),
              ),
              child: Text(
                'BEAT: Δ ${widget.wave.beatFrequency.toStringAsFixed(1)} Hz',
                style: AppTypography.monoMetric.copyWith(
                  color: widget.wave.band.color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelBadge(String channel, String hz, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5), width: 0.8),
      ),
      child: Text(
        '$channel: $hz',
        style: AppTypography.monoMetric.copyWith(color: color, fontSize: 9.5),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final BinauralWave wave;
  final double phase;

  _WaveformPainter({required this.wave, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    if (!wave.isEnabled) return;

    final centerY = size.height / 2.0;
    final amplitude = (size.height / 2.8) * wave.volume;

    final leftPath = Path();
    final rightPath = Path();
    final beatPath = Path();

    // Scale visual cycles
    const cycles = 4.0;
    final beatCycles = (wave.beatFrequency / 4.0).clamp(0.5, 6.0);

    for (double x = 0; x <= size.width; x += 2.0) {
      final normX = x / size.width;

      // Left wave (cyan)
      final yLeft = centerY + math.sin(normX * cycles * 2 * math.pi + phase) * amplitude * 0.45;
      if (x == 0) {
        leftPath.moveTo(x, yLeft);
      } else {
        leftPath.lineTo(x, yLeft);
      }

      // Right wave (violet) slightly shifted by beat frequency
      final yRight = centerY +
          math.sin(normX * (cycles + 0.15) * 2 * math.pi + phase + (wave.beatFrequency * 0.1)) *
              amplitude *
              0.45;
      if (x == 0) {
        rightPath.moveTo(x, yRight);
      } else {
        rightPath.lineTo(x, yRight);
      }

      // Modulated interference beat envelope
      final env = math.cos(normX * beatCycles * 2 * math.pi + phase * (wave.beatFrequency / 10.0));
      final yBeat = centerY + env * amplitude * 0.85;
      if (x == 0) {
        beatPath.moveTo(x, yBeat);
      } else {
        beatPath.lineTo(x, yBeat);
      }
    }

    // Paint left ear channel
    final leftPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(leftPath, leftPaint);

    // Paint right ear channel
    final rightPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(rightPath, rightPaint);

    // Paint synthesized beat envelope
    final beatPaint = Paint()
      ..color = wave.band.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(beatPath, beatPaint);
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) => true;
}
