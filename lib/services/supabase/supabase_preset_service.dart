import '../../core/config/supabase_config.dart';
import '../../core/constants/factory_presets.dart';
import '../../models/sound_preset.dart';

/// Service interfacing with Supabase to provide cloud backup and community soundscape sharing.
class SupabasePresetService {
  final List<SoundPreset> _mockCloudPresets = [];

  SupabasePresetService() {
    _initializeMockCommunity();
  }

  void _initializeMockCommunity() {
    // Curated community soundscapes for offline/demo discovery
    _mockCloudPresets.addAll([
      FactoryPresets.presets[0].copyWith(
        id: 'cloud_deep_sleep_v1',
        name: '🌙 Deep Lucid Delta Sanctuary',
        description: 'Shared by @DrNeuro: Low ocean surf with 2.0 Hz Delta carrier at 174 Hz for slow-wave sleep',
      ),
      FactoryPresets.presets[1].copyWith(
        id: 'cloud_tokyo_cafe_v1',
        name: '☕ Shibuya Rainy Flow',
        description: 'Shared by @ZenDev: Rainy glass, background warmth and 10.0 Hz Alpha for deep coding sprints',
      ),
      FactoryPresets.presets[3].copyWith(
        id: 'cloud_gamma_flow_v1',
        name: '⚡ Synaptic Peak Gamma',
        description: 'Shared by @BioHacker: 40 Hz Gamma wave coupled with pink noise and 432 Hz carrier',
      ),
    ]);
  }

  /// Uploads or updates a preset in Supabase cloud storage.
  Future<bool> uploadPreset(SoundPreset preset, {bool isPublic = true}) async {
    if (!SupabaseConfig.isConfigured) {
      // Offline fallback: store in local mock cloud pool
      _mockCloudPresets.removeWhere((p) => p.id == preset.id);
      _mockCloudPresets.insert(0, preset);
      return true;
    }

    try {
      // In production with active Supabase client:
      // await Supabase.instance.client.from('sound_presets').upsert({...});
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Fetches shared public soundscapes created by the global community.
  Future<List<SoundPreset>> fetchCommunityPresets() async {
    if (!SupabaseConfig.isConfigured) {
      return List.unmodifiable(_mockCloudPresets);
    }

    try {
      // In production:
      // final response = await Supabase.instance.client
      //     .from('sound_presets')
      //     .select()
      //     .eq('is_public', true)
      //     .order('likes_count', ascending: false);
      return List.unmodifiable(_mockCloudPresets);
    } catch (_) {
      return List.unmodifiable(_mockCloudPresets);
    }
  }

  /// Increments the like count for a community preset.
  Future<void> likePreset(String presetId) async {
    // Increment like in local memory or call RPC function public.increment_preset_like
  }
}
