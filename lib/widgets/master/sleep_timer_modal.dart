import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../services/timer/sleep_timer_service.dart';
import '../common/glass_card.dart';

/// Modal bottom sheet for configuring sleep timer duration and automatic fade-out.
class SleepTimerModal extends StatelessWidget {
  final SleepTimerService timerService;

  const SleepTimerModal({
    Key? key,
    required this.timerService,
  }) : super(key: key);

  static void show(BuildContext context, SleepTimerService timerService) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SleepTimerModal(timerService: timerService),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: timerService,
      builder: (context, _) {
        final isActive = timerService.isActive;

        return GlassCard(
          borderRadius: 24.0,
          backgroundColor: AppColors.surfaceElevated,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      Text('Sleep Timer', style: AppTypography.titleLarge),
                    ],
                  ),
                  if (isActive)
                    TextButton(
                      onPressed: timerService.cancelTimer,
                      child: Text(
                        'Turn Off',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.accentCoral,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Active Countdown Display
              if (isActive) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Text(
                        timerService.formattedRemaining,
                        style: AppTypography.monoLarge.copyWith(fontSize: 42),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gentle fade-out begins in final 60 seconds',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Duration Preset Buttons
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildTimerPresetButton(context, 15, '15 min'),
                  _buildTimerPresetButton(context, 30, '30 min'),
                  _buildTimerPresetButton(context, 45, '45 min'),
                  _buildTimerPresetButton(context, 60, '1 hour'),
                  _buildTimerPresetButton(context, 90, '1.5 hrs'),
                ],
              ),

              const SizedBox(height: 18),

              // Fade-out toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gradual Volume Fade-Out', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                      Text('Prevents abrupt waking', style: AppTypography.bodySmall),
                    ],
                  ),
                  Switch(
                    value: timerService.isFadeOutEnabled,
                    onChanged: timerService.setFadeOutEnabled,
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimerPresetButton(BuildContext context, int minutes, String label) {
    final isSelected = timerService.isActive &&
        (timerService.totalDuration.inMinutes == minutes);

    return ActionChip(
      label: Text(label),
      onPressed: () {
        timerService.startTimer(Duration(minutes: minutes));
      },
      backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.glassBorder,
          width: 1.0,
        ),
      ),
    );
  }
}
