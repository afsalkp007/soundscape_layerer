import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

/// Tactile circular rotary knob with touch angle tracking.
/// [value] is normalized between [min] and [max].
class VolumeKnob extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color activeColor;
  final String label;
  final double size;

  const VolumeKnob({
    Key? key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    required this.onChanged,
    this.activeColor = AppColors.primary,
    this.label = 'PAN',
    this.size = 54.0,
  }) : super(key: key);

  @override
  State<VolumeKnob> createState() => _VolumeKnobState();
}

class _VolumeKnobState extends State<VolumeKnob> {
  double _dragStartAngle = 0.0;
  double _dragStartValue = 0.0;

  void _onPanStart(DragStartDetails details) {
    _dragStartValue = widget.value;
    final center = Offset(widget.size / 2, widget.size / 2);
    _dragStartAngle = _getAngle(details.localPosition, center);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final currentAngle = _getAngle(details.localPosition, center);
    final deltaAngle = currentAngle - _dragStartAngle;

    // 270 degrees sweep from -135° to +135°
    final deltaVal = (deltaAngle / (math.pi * 1.5)) * (widget.max - widget.min);
    final nextVal = (_dragStartValue + deltaVal).clamp(widget.min, widget.max);
    widget.onChanged(nextVal);
  }

  double _getAngle(Offset pos, Offset center) {
    return math.atan2(pos.dy - center.dy, pos.dx - center.dx);
  }

  @override
  Widget build(BuildContext context) {
    final norm = (widget.value - widget.min) / (widget.max - widget.min);
    // Map norm [0..1] to angle [-135° .. +135°]
    final angle = (-135.0 + norm * 270.0) * (math.pi / 180.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _KnobPainter(
                angle: angle,
                norm: norm,
                activeColor: widget.activeColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.label,
          style: AppTypography.labelSmall.copyWith(fontSize: 9),
        ),
      ],
    );
  }
}

class _KnobPainter extends CustomPainter {
  final double angle;
  final double norm;
  final Color activeColor;

  _KnobPainter({
    required this.angle,
    required this.norm,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background track arc
    final trackPaint = Paint()
      ..color = AppColors.surfaceHighlight
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final startAngle = 135.0 * (math.pi / 180.0);
    const sweepAngle = 270.0 * (math.pi / 180.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Active track arc
    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * norm,
      false,
      activePaint,
    );

    // Inner dial knob face
    final knobPaint = Paint()
      ..color = AppColors.surfaceElevated
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 5, knobPaint);

    final knobBorder = Paint()
      ..color = AppColors.glassBorder
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - 5, knobBorder);

    // Indicator notch needle
    final notchPaint = Paint()
      ..color = activeColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final notchStart = Offset(
      center.dx + (radius - 12) * math.cos(angle - math.pi / 2),
      center.dy + (radius - 12) * math.sin(angle - math.pi / 2),
    );
    final notchEnd = Offset(
      center.dx + (radius - 6) * math.cos(angle - math.pi / 2),
      center.dy + (radius - 6) * math.sin(angle - math.pi / 2),
    );
    canvas.drawLine(notchStart, notchEnd, notchPaint);
  }

  @override
  bool shouldRepaint(_KnobPainter oldDelegate) =>
      oldDelegate.angle != angle ||
      oldDelegate.norm != norm ||
      oldDelegate.activeColor != activeColor;
}
