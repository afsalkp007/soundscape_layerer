import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/sound_preset.dart';
import '../common/glass_card.dart';

/// Modal bottom sheet displaying available factory & user presets with quick application.
class PresetSelectorSheet extends StatelessWidget {
  final List<SoundPreset> presets;
  final SoundPreset? activePreset;
  final ValueChanged<SoundPreset> onSelectPreset;
  final ValueChanged<String>? onDeletePreset;
  final VoidCallback onOpenSaveDialog;

  const PresetSelectorSheet({
    Key? key,
    required this.presets,
    required this.activePreset,
    required this.onSelectPreset,
    this.onDeletePreset,
    required this.onOpenSaveDialog,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required List<SoundPreset> presets,
    required SoundPreset? activePreset,
    required ValueChanged<SoundPreset> onSelectPreset,
    ValueChanged<String>? onDeletePreset,
    required VoidCallback onOpenSaveDialog,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PresetSelectorSheet(
        presets: presets,
        activePreset: activePreset,
        onSelectPreset: onSelectPreset,
        onDeletePreset: onDeletePreset,
        onOpenSaveDialog: onOpenSaveDialog,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: GlassCard(
        borderRadius: 24.0,
        backgroundColor: AppColors.surfaceElevated,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bookmarks_outlined, color: AppColors.primary, size: 22),
                    const SizedBox(width: 8),
                    Text('Soundscape Presets', style: AppTypography.titleLarge),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onOpenSaveDialog();
                  },
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Save Current'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    textStyle: AppTypography.labelSmall.copyWith(fontSize: 11),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Presets List
            Expanded(
              child: ListView.separated(
                itemCount: presets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final preset = presets[index];
                  final isSelected = activePreset?.id == preset.id;
                  final presetColor = Color(preset.colorHex);

                  return GestureDetector(
                    onTap: () {
                      onSelectPreset(preset);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? presetColor.withOpacity(0.12) : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? presetColor : AppColors.glassBorder,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: presetColor.withOpacity(0.2),
                              border: Border.all(color: presetColor, width: 1.2),
                            ),
                            child: Icon(
                              IconData(preset.iconCodePoint, fontFamily: 'MaterialIcons'),
                              color: presetColor,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      preset.name,
                                      style: AppTypography.titleMedium.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.white : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (preset.isUserCustom) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'CUSTOM',
                                          style: AppTypography.labelSmall.copyWith(
                                            fontSize: 8.5,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  preset.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          if (preset.isUserCustom && onDeletePreset != null)
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.accentCoral),
                              onPressed: () => onDeletePreset!(preset.id),
                            )
                          else if (isSelected)
                            Icon(Icons.check_circle_rounded, color: presetColor, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
