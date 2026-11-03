import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/sound_preset.dart';
import '../common/glass_card.dart';

/// Modal bottom sheet displaying local presets and Supabase community cloud presets.
class PresetSelectorSheet extends StatefulWidget {
  final List<SoundPreset> presets;
  final List<SoundPreset> communityPresets;
  final SoundPreset? activePreset;
  final ValueChanged<SoundPreset> onSelectPreset;
  final ValueChanged<String>? onDeletePreset;
  final Future<void> Function(SoundPreset)? onSyncPreset;
  final VoidCallback onOpenSaveDialog;

  const PresetSelectorSheet({
    Key? key,
    required this.presets,
    this.communityPresets = const [],
    required this.activePreset,
    required this.onSelectPreset,
    this.onDeletePreset,
    this.onSyncPreset,
    required this.onOpenSaveDialog,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required List<SoundPreset> presets,
    List<SoundPreset> communityPresets = const [],
    required SoundPreset? activePreset,
    required ValueChanged<SoundPreset> onSelectPreset,
    ValueChanged<String>? onDeletePreset,
    Future<void> Function(SoundPreset)? onSyncPreset,
    required VoidCallback onOpenSaveDialog,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PresetSelectorSheet(
        presets: presets,
        communityPresets: communityPresets,
        activePreset: activePreset,
        onSelectPreset: onSelectPreset,
        onDeletePreset: onDeletePreset,
        onSyncPreset: onSyncPreset,
        onOpenSaveDialog: onOpenSaveDialog,
      ),
    );
  }

  @override
  State<PresetSelectorSheet> createState() => _PresetSelectorSheetState();
}

class _PresetSelectorSheetState extends State<PresetSelectorSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
      child: GlassCard(
        borderRadius: 24.0,
        backgroundColor: AppColors.surfaceElevated,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        child: Column(
          children: [
            // Top Bar
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
                    widget.onOpenSaveDialog();
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
            const SizedBox(height: 12),

            // Tab Bar: Local Presets vs Supabase Community
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: AppTypography.labelSmall.copyWith(fontSize: 11),
              tabs: const [
                Tab(
                  icon: Icon(Icons.phone_iphone_rounded, size: 16),
                  text: 'MY PRESETS',
                ),
                Tab(
                  icon: Icon(Icons.cloud_outlined, size: 16),
                  text: 'SUPABASE CLOUD',
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Tab View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPresetsList(widget.presets, isCommunity: false),
                  _buildPresetsList(widget.communityPresets, isCommunity: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetsList(List<SoundPreset> list, {required bool isCommunity}) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          isCommunity ? 'No community presets found' : 'No saved presets yet',
          style: AppTypography.bodySmall,
        ),
      );
    }

    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final preset = list[index];
        final isSelected = widget.activePreset?.id == preset.id;
        final presetColor = Color(preset.colorHex);

        return GestureDetector(
          onTap: () {
            widget.onSelectPreset(preset);
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
                          Expanded(
                            child: Text(
                              preset.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (preset.isUserCustom && !isCommunity) ...[
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
                        style: AppTypography.bodySmall.copyWith(fontSize: 10.5),
                      ),
                    ],
                  ),
                ),
                if (!isCommunity && preset.isUserCustom) ...[
                  if (widget.onSyncPreset != null)
                    IconButton(
                      icon: const Icon(Icons.cloud_upload_outlined, size: 18, color: AppColors.primary),
                      tooltip: 'Sync to Supabase',
                      onPressed: () async {
                        await widget.onSyncPreset!(preset);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Synced "${preset.name}" to Supabase!')),
                          );
                        }
                      },
                    ),
                  if (widget.onDeletePreset != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.accentCoral),
                      onPressed: () => widget.onDeletePreset!(preset.id),
                    ),
                ] else if (isSelected)
                  Icon(Icons.check_circle_rounded, color: presetColor, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
