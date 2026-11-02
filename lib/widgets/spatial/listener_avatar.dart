import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Center node on the 2D soundstage representing the listener.
class ListenerAvatar extends StatelessWidget {
  final double size;

  const ListenerAvatar({
    Key? key,
    this.size = 56.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceHighlight,
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryGlow,
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Directional nose marker pointing forward (0°)
          Positioned(
            top: 2,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
          ),
          const Icon(
            Icons.headphones_rounded,
            size: 26,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
