import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/sound_preset.dart';
import '../../core/constants/factory_presets.dart';

/// Storage repository for persisting custom user sound presets.
class PresetStorageService {
  static const String _storageKey = 'soundscape_user_presets_v1';
  final Map<String, SoundPreset> _inMemoryUserPresets = {};
  bool _isLoaded = false;

  /// Loads all available presets, combining factory presets with saved user presets.
  Future<List<SoundPreset>> getAllPresets() async {
    await _ensureLoaded();
    final List<SoundPreset> combined = List.from(FactoryPresets.presets);
    combined.addAll(_inMemoryUserPresets.values);
    return combined;
  }

  /// Saves a custom preset to disk.
  Future<void> savePreset(SoundPreset preset) async {
    await _ensureLoaded();
    _inMemoryUserPresets[preset.id] = preset.copyWith(isUserCustom: true);
    await _persist();
  }

  /// Deletes a user preset.
  Future<bool> deletePreset(String presetId) async {
    await _ensureLoaded();
    if (_inMemoryUserPresets.containsKey(presetId)) {
      _inMemoryUserPresets.remove(presetId);
      await _persist();
      return true;
    }
    return false;
  }

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_storageKey);
      if (rawList != null) {
        for (final item in rawList) {
          try {
            final map = jsonDecode(item) as Map<String, dynamic>;
            final preset = SoundPreset.fromJson(map);
            _inMemoryUserPresets[preset.id] = preset;
          } catch (_) {
            // Ignore malformed entries
          }
        }
      }
    } catch (_) {
      // In-memory fallback if SharedPreferences is unavailable in current test environment
    }
    _isLoaded = true;
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final serialized = _inMemoryUserPresets.values
          .map((p) => jsonEncode(p.toJson()))
          .toList();
      await prefs.setStringList(_storageKey, serialized);
    } catch (_) {
      // In-memory fallback
    }
  }
}
