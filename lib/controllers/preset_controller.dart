import 'package:flutter/foundation.dart';
import '../models/sound_preset.dart';
import '../services/storage/preset_storage_service.dart';
import 'binaural_controller.dart';
import 'soundscape_controller.dart';

/// Controller managing preset loading, saving, deletion, and active preset tracking.
class PresetController extends ChangeNotifier {
  final PresetStorageService _storageService;
  List<SoundPreset> _presets = [];
  SoundPreset? _activePreset;
  bool _isLoading = false;

  PresetController({
    PresetStorageService? storageService,
  }) : _storageService = storageService ?? PresetStorageService() {
    loadPresets();
  }

  List<SoundPreset> get presets => List.unmodifiable(_presets);
  SoundPreset? get activePreset => _activePreset;
  bool get isLoading => _isLoading;

  Future<void> loadPresets() async {
    _isLoading = true;
    notifyListeners();

    _presets = await _storageService.getAllPresets();
    if (_presets.isNotEmpty && _activePreset == null) {
      _activePreset = _presets.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Applies preset settings to both soundscape controller and binaural controller.
  void applyPreset(
    SoundPreset preset, {
    required SoundscapeController soundscapeController,
    required BinauralController binauralController,
  }) {
    _activePreset = preset;

    soundscapeController.applyTrackConfigurations(
      volumes: preset.trackVolumes,
      pans: preset.trackPans,
      enabled: preset.trackEnabled,
      positions: preset.trackPositions,
      masterVol: preset.masterVolume,
    );

    binauralController.loadFromWave(preset.binauralWave);
    notifyListeners();
  }

  /// Creates a new preset from the current soundscape and binaural state.
  Future<SoundPreset> saveCurrentAsPreset({
    required String name,
    required String description,
    required int iconCodePoint,
    required int colorHex,
    required SoundscapeController soundscapeController,
    required BinauralController binauralController,
  }) async {
    final volumes = <String, double>{};
    final pans = <String, double>{};
    final enabled = <String, bool>{};
    final positions = <String, dynamic>{};

    for (final track in soundscapeController.tracks) {
      volumes[track.id] = track.volume;
      pans[track.id] = track.pan;
      enabled[track.id] = track.isPlaying;
      positions[track.id] = track.spatialPosition;
    }

    final newPreset = SoundPreset(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      iconCodePoint: iconCodePoint,
      colorHex: colorHex,
      masterVolume: soundscapeController.masterVolume,
      trackVolumes: volumes,
      trackPans: pans,
      trackEnabled: enabled,
      trackPositions: Map.from(positions),
      binauralWave: binauralController.wave,
      createdAt: DateTime.now(),
      isUserCustom: true,
    );

    await _storageService.savePreset(newPreset);
    _presets.add(newPreset);
    _activePreset = newPreset;
    notifyListeners();
    return newPreset;
  }

  Future<void> deletePreset(String presetId) async {
    final deleted = await _storageService.deletePreset(presetId);
    if (deleted) {
      _presets.removeWhere((p) => p.id == presetId);
      if (_activePreset?.id == presetId) {
        _activePreset = _presets.isNotEmpty ? _presets.first : null;
      }
      notifyListeners();
    }
  }
}
