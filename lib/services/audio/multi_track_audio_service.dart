import 'dart:async';
import 'dart:typed_data';
import '../../core/utils/audio_math.dart';
import '../../models/sound_track.dart';
import 'audio_engine_interface.dart';

/// Software audio channel implementation that simulates real-time DSP channel strip.
class SoftwareAudioChannel implements IAudioChannel {
  @override
  final String channelId;

  bool _isPlaying = false;
  double _volume = 0.5;
  double _pan = 0.0;
  Uint8List? _buffer;

  SoftwareAudioChannel(this.channelId);

  @override
  bool get isPlaying => _isPlaying;

  @override
  double get volume => _volume;

  @override
  double get pan => _pan;

  Uint8List? get buffer => _buffer;

  @override
  Future<void> play() async {
    _isPlaying = true;
  }

  @override
  Future<void> pause() async {
    _isPlaying = false;
  }

  @override
  Future<void> stop() async {
    _isPlaying = false;
  }

  @override
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
  }

  @override
  Future<void> setPan(double pan) async {
    _pan = pan.clamp(-1.0, 1.0);
  }

  @override
  Future<void> loadBytes(Uint8List bytes) async {
    _buffer = bytes;
  }

  @override
  Future<void> dispose() async {
    _isPlaying = false;
    _buffer = null;
  }
}

/// Multi-track audio mixer service coordinating individual channels, master gain,
/// solo/mute routing matrix, and spatial coordinate attenuation.
class MultiTrackAudioService implements IAudioEngine {
  final Map<String, SoftwareAudioChannel> _channels = {};
  double _masterVolume = 0.85;
  bool _isMasterPlaying = true;

  double get masterVolume => _masterVolume;
  bool get isMasterPlaying => _isMasterPlaying;

  @override
  Future<void> initialize() async {
    // Initialized engine
  }

  @override
  Future<SoftwareAudioChannel> createChannel(String channelId) async {
    if (_channels.containsKey(channelId)) {
      return _channels[channelId]!;
    }
    final channel = SoftwareAudioChannel(channelId);
    _channels[channelId] = channel;
    return channel;
  }

  SoftwareAudioChannel? getChannel(String channelId) => _channels[channelId];

  @override
  Future<void> setMasterVolume(double volume) async {
    _masterVolume = volume.clamp(0.0, 1.0);
  }

  /// Syncs an updated list of tracks with active audio channels.
  Future<void> syncTracks(List<SoundTrack> tracks) async {
    final anySolo = tracks.any((t) => t.isSolo);

    for (final track in tracks) {
      final channel = await createChannel(track.id);

      final effectiveVolume = track.computeEffectiveVolume(anyTrackSoloed: anySolo) * _masterVolume;
      final effectivePan = track.effectivePan;

      await channel.setVolume(effectiveVolume);
      await channel.setPan(effectivePan);

      if (track.isPlaying && _isMasterPlaying && effectiveVolume > 0.0) {
        if (!channel.isPlaying) {
          await channel.play();
        }
      } else {
        if (channel.isPlaying) {
          await channel.pause();
        }
      }
    }
  }

  /// Master pause toggle.
  Future<void> setMasterPlayback(bool play) async {
    _isMasterPlaying = play;
    if (!play) {
      for (final ch in _channels.values) {
        await ch.pause();
      }
    }
  }

  /// Calculates the current stereo power output level in dB for master VU meters.
  ({double leftDb, double rightDb}) calculateMasterOutput(List<SoundTrack> tracks) {
    if (!_isMasterPlaying || _masterVolume <= 0.001) {
      return (leftDb: -60.0, rightDb: -60.0);
    }

    double totalLeft = 0.0;
    double totalRight = 0.0;
    final anySolo = tracks.any((t) => t.isSolo);

    for (final t in tracks) {
      final vol = t.computeEffectiveVolume(anyTrackSoloed: anySolo) * _masterVolume;
      if (vol > 0.0) {
        final pan = AudioMath.constantPowerPan(t.effectivePan);
        totalLeft += vol * pan.leftGain;
        totalRight += vol * pan.rightGain;
      }
    }

    // Normalized RMS sum approximation
    final leftNorm = (totalLeft / (tracks.isNotEmpty ? tracks.length : 1)).clamp(0.0, 1.0);
    final rightNorm = (totalRight / (tracks.isNotEmpty ? tracks.length : 1)).clamp(0.0, 1.0);

    return (
      leftDb: AudioMath.linearToDb(leftNorm),
      rightDb: AudioMath.linearToDb(rightNorm),
    );
  }

  @override
  Future<void> stopAll() async {
    _isMasterPlaying = false;
    for (final ch in _channels.values) {
      await ch.stop();
    }
  }

  @override
  Future<void> resumeAll() async {
    _isMasterPlaying = true;
  }

  @override
  Future<void> dispose() async {
    for (final ch in _channels.values) {
      await ch.dispose();
    }
    _channels.clear();
  }
}
