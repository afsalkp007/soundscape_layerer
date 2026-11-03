import 'package:flutter_test/flutter_test.dart';
import 'package:soundscape_layerer/controllers/soundscape_controller.dart';
import 'package:soundscape_layerer/models/sound_category.dart';
import 'package:soundscape_layerer/models/spatial_position.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SoundscapeController Tests', () {
    late SoundscapeController controller;

    setUp(() {
      controller = SoundscapeController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('initializes with default catalog tracks', () {
      expect(controller.tracks.isNotEmpty, true);
      expect(controller.isPlaying, true);
      expect(controller.masterVolume, closeTo(0.85, 0.01));
    });

    test('toggleTrackPlay flips track playing state', () {
      final firstTrack = controller.tracks.first;
      final initialPlay = firstTrack.isPlaying;

      controller.toggleTrackPlay(firstTrack.id);

      final updatedTrack = controller.tracks.firstWhere((t) => t.id == firstTrack.id);
      expect(updatedTrack.isPlaying, !initialPlay);
    });

    test('setTrackVolume updates volume accurately', () {
      final trackId = controller.tracks.first.id;
      controller.setTrackVolume(trackId, 0.72);

      final updated = controller.tracks.firstWhere((t) => t.id == trackId);
      expect(updated.volume, closeTo(0.72, 0.001));
    });

    test('updateTrackSpatialPosition modifies 2D position', () {
      final trackId = controller.tracks.first.id;
      const newPos = SpatialPosition(x: -0.8, y: 0.5);

      controller.updateTrackSpatialPosition(trackId, newPos);

      final updated = controller.tracks.firstWhere((t) => t.id == trackId);
      expect(updated.spatialPosition, newPos);
    });

    test('category filter isolates tracks by category', () {
      controller.setCategoryFilter(SoundCategory.water);

      expect(
        controller.filteredTracks.every((t) => t.category == SoundCategory.water),
        true,
      );

      // Reset filter
      controller.setCategoryFilter(null);
      expect(controller.filteredTracks.length, controller.tracks.length);
    });

    test('muteAllTracks stops all playing tracks', () {
      controller.muteAllTracks();
      expect(controller.tracks.every((t) => !t.isPlaying), true);
    });
  });
}
