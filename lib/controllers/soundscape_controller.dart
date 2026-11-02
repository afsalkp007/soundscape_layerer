import 'package:flutter/foundation.dart';
import '../core/constants/default_tracks.dart';
import '../models/sound_category.dart';
import '../models/sound_track.dart';
import '../models/spatial_position.dart';
import '../services/audio/multi_track_audio_service.dart';
import '../services/timer/sleep_timer_service.dart';

/// Central controller orchestrating all sound layers, spatial canvas positions,
/// mixer strips, and master output routing.
class SoundscapeController extends ChangeNotifier {
  final MultiTrackAudioService _audioService;
  final SleepTimerService _sleepTimerService;

  List<SoundTrack> _tracks = [];
  double _masterVolume = 0.85;
  double _timerFadeMultiplier = 1.0;
  bool _isPlaying = true;
  SoundCategory? _selectedCategoryFilter;

  SoundscapeController({
    MultiTrackAudioService? audioService,
    SleepTimerService? sleepTimerService,
    List<SoundTrack>? initialTracks,
  })  : _audioService = audioService ?? MultiTrackAudioService(),
        _sleepTimerService = sleepTimerService ?? SleepTimerService() {
    _tracks = initialTracks ?? DefaultTracks.catalog;
    _initAudio();
  }

  List<SoundTrack> get tracks => List.unmodifiable(_tracks);
  double get masterVolume => _masterVolume;
  double get effectiveMasterVolume => (_masterVolume * _timerFadeMultiplier).clamp(0.0, 1.0);
  bool get isPlaying => _isPlaying;
  SoundCategory? get selectedCategoryFilter => _selectedCategoryFilter;
  MultiTrackAudioService get audioService => _audioService;
  SleepTimerService get sleepTimerService => _sleepTimerService;

  List<SoundTrack> get activeTracks => _tracks.where((t) => t.isPlaying).toList();

  List<SoundTrack> get filteredTracks {
    if (_selectedCategoryFilter == null) return _tracks;
    return _tracks.where((t) => t.category == _selectedCategoryFilter).toList();
  }

  void _initAudio() {
    _audioService.initialize().then((_) {
      _syncAudio();
    });

    _sleepTimerService.onFadeMultiplierChanged = (multiplier) {
      _timerFadeMultiplier = multiplier;
      _syncAudio();
      notifyListeners();
    };

    _sleepTimerService.onTimerCompleted = () {
      setMasterPlayback(false);
    };
  }

  void setCategoryFilter(SoundCategory? category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void toggleTrackPlay(String trackId) {
    _tracks = _tracks.map((t) {
      if (t.id == trackId) {
        return t.copyWith(isPlaying: !t.isPlaying);
      }
      return t;
    }).toList();
    _syncAudio();
    notifyListeners();
  }

  void setTrackVolume(String trackId, double volume) {
    _tracks = _tracks.map((t) {
      if (t.id == trackId) {
        return t.copyWith(volume: volume);
      }
      return t;
    }).toList();
    _syncAudio();
    notifyListeners();
  }

  void setTrackPan(String trackId, double pan) {
    _tracks = _tracks.map((t) {
      if (t.id == trackId) {
        return t.copyWith(pan: pan);
      }
      return t;
    }).toList();
    _syncAudio();
    notifyListeners();
  }

  void toggleTrackMute(String trackId) {
    _tracks = _tracks.map((t) {
      if (t.id == trackId) {
        return t.copyWith(isMuted: !t.isMuted);
      }
      return t;
    }).toList();
    _syncAudio();
    notifyListeners();
  }

  void toggleTrackSolo(String trackId) {
    _tracks = _tracks.map((t) {
      if (t.id == trackId) {
        return t.copyWith(isSolo: !t.isSolo);
      }
      return t;
    }).toList();
    _syncAudio();
    notifyListeners();
  }

  void updateTrackSpatialPosition(String trackId, SpatialPosition position) {
    _tracks = _tracks.map((t) {
      if (t.id == trackId) {
        return t.copyWith(spatialPosition: position);
      }
      return t;
    }).toList();
    _syncAudio();
    notifyListeners();
  }

  void setMasterVolume(double volume) {
    _masterVolume = volume.clamp(0.0, 1.0);
    _syncAudio();
    notifyListeners();
  }

  void setMasterPlayback(bool play) {
    _isPlaying = play;
    _audioService.setMasterPlayback(play);
    notifyListeners();
  }

  void toggleMasterPlayback() {
    setMasterPlayback(!_isPlaying);
  }

  void applyTrackConfigurations({
    required Map<String, double> volumes,
    required Map<String, double> pans,
    required Map<String, bool> enabled,
    required Map<String, SpatialPosition> positions,
    double? masterVol,
  }) {
    if (masterVol != null) {
      _masterVolume = masterVol;
    }

    _tracks = _tracks.map((t) {
      return t.copyWith(
        volume: volumes[t.id] ?? t.volume,
        pan: pans[t.id] ?? t.pan,
        isPlaying: enabled[t.id] ?? false,
        spatialPosition: positions[t.id] ?? t.spatialPosition,
      );
    }).toList();

    _syncAudio();
    notifyListeners();
  }

  void muteAllTracks() {
    _tracks = _tracks.map((t) => t.copyWith(isPlaying: false)).toList();
    _syncAudio();
    notifyListeners();
  }

  void _syncAudio() {
    _audioService.setMasterVolume(effectiveMasterVolume);
    _audioService.syncTracks(_tracks);
  }
}
