import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/binaural_controller.dart';
import '../../widgets/binaural/binaural_rack_widget.dart';

/// Brainwave entrainment and binaural beat synthesizer view.
class BinauralTab extends StatelessWidget {
  const BinauralTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BinauralController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 96),
      child: BinauralRackWidget(
        wave: controller.wave,
        onToggleEnabled: controller.toggleEnabled,
        onSelectBand: controller.selectBand,
        onBeatFrequencyChanged: controller.setBeatFrequency,
        onCarrierFrequencyChanged: controller.setCarrierFrequency,
        onVolumeChanged: controller.setVolume,
        onToggleIsochronic: controller.toggleIsochronic,
      ),
    );
  }
}
