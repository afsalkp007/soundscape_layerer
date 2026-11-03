import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/sound_category.dart';
import '../../models/sound_track.dart';
import 'track_tile.dart';

/// Full scrollable mixer panel with category filters and mute-all batch controls.
class TrackMixerPanel extends StatelessWidget {
  final List<SoundTrack> tracks;
  final SoundCategory? selectedCategory;
  final ValueChanged<SoundCategory?> onCategoryChanged;
  final void Function(String trackId, double volume) onVolumeChanged;
  final void Function(String trackId, double pan) onPanChanged;
  final ValueChanged<String> onTogglePlay;
  final ValueChanged<String> onToggleMute;
  final ValueChanged<String> onToggleSolo;
  final VoidCallback onMuteAll;

  const TrackMixerPanel({
    Key? key,
    required this.tracks,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onVolumeChanged,
    required this.onPanChanged,
    required this.onTogglePlay,
    required this.onToggleMute,
    required this.onToggleSolo,
    required this.onMuteAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Filter Chips & Mute All
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SOUND LAYERS (${tracks.length})',
                style: AppTypography.labelSmall.copyWith(letterSpacing: 1.0),
              ),
              GestureDetector(
                onTap: onMuteAll,
                child: Row(
                  children: [
                    const Icon(Icons.volume_off_outlined, size: 14, color: AppColors.accentCoral),
                    const SizedBox(width: 4),
                    Text(
                      'Mute All',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.accentCoral),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Category Filter Strip
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryChip(null, 'All Layers', Icons.grid_view_outlined),
              ...SoundCategory.values.where((c) => c != SoundCategory.binaural).map((cat) {
                return _buildCategoryChip(cat, cat.displayName, cat.iconData);
              }),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Track List
        Expanded(
          child: tracks.isEmpty
              ? Center(
                  child: Text(
                    'No tracks in this category',
                    style: AppTypography.bodySmall,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    return TrackTile(
                      track: track,
                      onVolumeChanged: (vol) => onVolumeChanged(track.id, vol),
                      onPanChanged: (pan) => onPanChanged(track.id, pan),
                      onTogglePlay: () => onTogglePlay(track.id),
                      onToggleMute: () => onToggleMute(track.id),
                      onToggleSolo: () => onToggleSolo(track.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(SoundCategory? category, String label, IconData icon) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: FilterChip(
        avatar: Icon(icon, size: 14, color: isSelected ? Colors.black : AppColors.textSecondary),
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onCategoryChanged(category),
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surfaceElevated,
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : AppColors.textSecondary,
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.glassBorder,
            width: 0.8,
          ),
        ),
      ),
    );
  }
}
