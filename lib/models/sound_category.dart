import 'package:flutter/material.dart';

/// Categories for organizing soundscape tracks.
enum SoundCategory {
  nature,
  water,
  urban,
  noise,
  melodic,
  binaural,
}

extension SoundCategoryExtension on SoundCategory {
  String get displayName {
    switch (this) {
      case SoundCategory.nature:
        return 'Nature';
      case SoundCategory.water:
        return 'Water';
      case SoundCategory.urban:
        return 'Urban & Life';
      case SoundCategory.noise:
        return 'Static & Color';
      case SoundCategory.melodic:
        return 'Melodic Tones';
      case SoundCategory.binaural:
        return 'Binaural';
    }
  }

  IconData get iconData {
    switch (this) {
      case SoundCategory.nature:
        return Icons.forest_outlined;
      case SoundCategory.water:
        return Icons.water_drop_outlined;
      case SoundCategory.urban:
        return Icons.coffee_outlined;
      case SoundCategory.noise:
        return Icons.graphic_eq_outlined;
      case SoundCategory.melodic:
        return Icons.music_note_outlined;
      case SoundCategory.binaural:
        return Icons.psychology_outlined;
    }
  }
}
