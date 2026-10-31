import 'dart:typed_data';

/// Interface representing a single controllable sound playback channel.
abstract class IAudioChannel {
  String get channelId;
  bool get isPlaying;
  double get volume;
  double get pan;

  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> setVolume(double volume);
  Future<void> setPan(double pan);
  Future<void> loadBytes(Uint8List bytes);
  Future<void> dispose();
}

/// Abstract audio engine managing multi-track channel allocation and hardware output.
abstract class IAudioEngine {
  Future<void> initialize();
  Future<IAudioChannel> createChannel(String channelId);
  Future<void> setMasterVolume(double volume);
  Future<void> stopAll();
  Future<void> resumeAll();
  Future<void> dispose();
}
