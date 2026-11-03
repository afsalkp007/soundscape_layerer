import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/soundscape_controller.dart';
import '../../widgets/mixer/track_mixer_panel.dart';

/// Full mixer console view with individual channel strips.
class MixerTab extends StatelessWidget {
  const MixerTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SoundscapeController>();

    return TrackMixerPanel(
      tracks: controller.filteredTracks,
      selectedCategory: controller.selectedCategoryFilter,
      onCategoryChanged: controller.setCategoryFilter,
      onVolumeChanged: controller.setTrackVolume,
      onPanChanged: controller.setTrackPan,
      onTogglePlay: controller.toggleTrackPlay,
      onToggleMute: controller.toggleTrackMute,
      onToggleSolo: controller.toggleTrackSolo,
      onMuteAll: controller.muteAllTracks,
    );
  }
}
