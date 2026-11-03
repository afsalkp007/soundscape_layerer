import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/binaural_controller.dart';
import '../../controllers/preset_controller.dart';
import '../../controllers/soundscape_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../widgets/master/master_playback_bar.dart';
import '../../widgets/master/sleep_timer_modal.dart';
import '../../widgets/presets/preset_selector_sheet.dart';
import '../../widgets/presets/save_preset_dialog.dart';
import 'binaural_tab.dart';
import 'mixer_tab.dart';
import 'spatial_stage_tab.dart';

/// Main container screen providing navigation between Spatial Soundstage,
/// Mixer Studio, and Binaural Synthesizer.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    SpatialStageTab(),
    MixerTab(),
    BinauralTab(),
  ];

  void _openPresetsSheet() {
    final presetController = context.read<PresetController>();
    final soundscapeController = context.read<SoundscapeController>();
    final binauralController = context.read<BinauralController>();

    PresetSelectorSheet.show(
      context,
      presets: presetController.presets,
      communityPresets: presetController.communityPresets,
      activePreset: presetController.activePreset,
      onSelectPreset: (preset) {
        presetController.applyPreset(
          preset,
          soundscapeController: soundscapeController,
          binauralController: binauralController,
        );
      },
      onDeletePreset: (id) => presetController.deletePreset(id),
      onSyncPreset: (preset) => presetController.syncPresetToCloud(preset),
      onOpenSaveDialog: _openSavePresetDialog,
    );
  }

  void _openSavePresetDialog() {
    final soundscapeController = context.read<SoundscapeController>();
    final binauralController = context.read<BinauralController>();
    final presetController = context.read<PresetController>();

    SavePresetDialog.show(
      context,
      onSave: (name, desc, iconCode, colorHex) async {
        await presetController.saveCurrentAsPreset(
          name: name,
          description: desc,
          iconCodePoint: iconCode,
          colorHex: colorHex,
          soundscapeController: soundscapeController,
          binauralController: binauralController,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Preset "$name" saved!'),
              backgroundColor: AppColors.surfaceElevated,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  void _openTimerModal() {
    final soundscapeController = context.read<SoundscapeController>();
    SleepTimerModal.show(context, soundscapeController.sleepTimerService);
  }

  @override
  Widget build(BuildContext context) {
    final soundscapeController = context.watch<SoundscapeController>();
    final presetController = context.watch<PresetController>();
    final timerService = soundscapeController.sleepTimerService;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.blur_on_rounded, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text('SOUNDSCAPE', style: AppTypography.titleLarge.copyWith(letterSpacing: 2.0)),
          ],
        ),
        actions: [
          // Preset Chip Button
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ActionChip(
              avatar: const Icon(Icons.bookmark_outline, size: 14, color: AppColors.primary),
              label: Text(
                presetController.activePreset?.name ?? 'Presets',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 10.5,
                ),
              ),
              backgroundColor: AppColors.surfaceElevated,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.glassBorder, width: 0.8),
              ),
              onPressed: _openPresetsSheet,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Tab View Content
          IndexedStack(
            index: _currentIndex,
            children: _tabs,
          ),

          // Master Floating Playback Dock
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MasterPlaybackBar(
              isPlaying: soundscapeController.isPlaying,
              masterVolume: soundscapeController.masterVolume,
              activePresetName: presetController.activePreset?.name,
              timerFormatted: timerService.formattedRemaining,
              isTimerActive: timerService.isActive,
              onTogglePlay: soundscapeController.toggleMasterPlayback,
              onVolumeChanged: soundscapeController.setMasterVolume,
              onOpenTimer: _openTimerModal,
              onOpenPresets: _openPresetsSheet,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.radar_rounded),
            label: 'Soundstage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_rounded),
            label: 'Mixer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_outlined),
            label: 'Binaural',
          ),
        ],
      ),
    );
  }
}
