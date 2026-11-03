import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../common/glass_card.dart';

/// Dialog allowing users to save their current soundscape scene as a custom preset.
class SavePresetDialog extends StatefulWidget {
  final Future<void> Function(String name, String description, int iconCodePoint, int colorHex) onSave;

  const SavePresetDialog({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required Future<void> Function(String name, String description, int iconCodePoint, int colorHex) onSave,
  }) {
    return showDialog(
      context: context,
      builder: (_) => SavePresetDialog(onSave: onSave),
    );
  }

  @override
  State<SavePresetDialog> createState() => _SavePresetDialogState();
}

class _SavePresetDialogState extends State<SavePresetDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  int _selectedColorHex = 0xFF00E5FF;
  int _selectedIconCode = Icons.headphones_outlined.codePoint;

  static const List<int> _colorOptions = [
    0xFF00E5FF, // Cyan
    0xFFB388FF, // Violet
    0xFFFFB300, // Amber
    0xFF00E676, // Mint
    0xFFFF4081, // Pink
    0xFF38BDF8, // Sky
  ];

  static final List<IconData> _iconOptions = [
    Icons.headphones_outlined,
    Icons.bedtime_outlined,
    Icons.local_cafe_outlined,
    Icons.spa_outlined,
    Icons.psychology_outlined,
    Icons.menu_book_outlined,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: GlassCard(
        borderRadius: 20.0,
        backgroundColor: AppColors.surfaceElevated,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Save Soundscape Preset', style: AppTypography.titleLarge),
            const SizedBox(height: 14),

            // Name field
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Preset Name',
                labelStyle: AppTypography.bodySmall,
                hintText: 'e.g. Midnight Coding Flow',
                hintStyle: TextStyle(color: AppColors.textDisabled),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Description field
            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                labelStyle: AppTypography.bodySmall,
                hintText: 'e.g. Rain and 432 Hz Alpha tone',
                hintStyle: TextStyle(color: AppColors.textDisabled),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Color Palette Selector
            Text('ACCENT COLOR', style: AppTypography.labelSmall),
            const SizedBox(height: 6),
            Row(
              children: _colorOptions.map((hex) {
                final isSelected = _selectedColorHex == hex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorHex = hex),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(hex),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2.2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // Icon Selector
            Text('ICON', style: AppTypography.labelSmall),
            const SizedBox(height: 6),
            Row(
              children: _iconOptions.map((icon) {
                final isSelected = _selectedIconCode == icon.codePoint;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIconCode = icon.codePoint),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected ? Color(_selectedColorHex).withOpacity(0.2) : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Color(_selectedColorHex) : AppColors.glassBorder,
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: isSelected ? Color(_selectedColorHex) : AppColors.textMuted,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    if (name.isEmpty) return;
                    await widget.onSave(
                      name,
                      _descController.text.trim(),
                      _selectedIconCode,
                      _selectedColorHex,
                    );
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save Preset', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
