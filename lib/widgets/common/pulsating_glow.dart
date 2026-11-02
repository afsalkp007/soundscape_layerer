import 'package:flutter/material.dart';

/// Animated pulsing halo glow effect indicating an active sound generator.
class PulsatingGlow extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final bool isPulsing;
  final double maxRadius;

  const PulsatingGlow({
    Key? key,
    required this.child,
    required this.glowColor,
    this.isPulsing = true,
    this.maxRadius = 24.0,
  }) : super(key: key);

  @override
  State<PulsatingGlow> createState() => _PulsatingGlowState();
}

class _PulsatingGlowState extends State<PulsatingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _animation = Tween<double>(begin: 0.25, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isPulsing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulsatingGlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing != oldWidget.isPulsing) {
      if (widget.isPulsing) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPulsing) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(_animation.value * 0.5),
                blurRadius: widget.maxRadius * _animation.value,
                spreadRadius: widget.maxRadius * 0.25 * _animation.value,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
