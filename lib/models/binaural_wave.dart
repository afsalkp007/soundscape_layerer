import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Standard human EEG brainwave bands.
enum BrainwaveBand {
  delta,
  theta,
  alpha,
  beta,
  gamma,
}

extension BrainwaveBandExtension on BrainwaveBand {
  String get nameDisplay {
    switch (this) {
      case BrainwaveBand.delta:
        return 'Delta (δ)';
      case BrainwaveBand.theta:
        return 'Theta (θ)';
      case BrainwaveBand.alpha:
        return 'Alpha (α)';
      case BrainwaveBand.beta:
        return 'Beta (β)';
      case BrainwaveBand.gamma:
        return 'Gamma (γ)';
    }
  }

  String get targetBenefit {
    switch (this) {
      case BrainwaveBand.delta:
        return 'Deep Dreamless Sleep & Cellular Recovery';
      case BrainwaveBand.theta:
        return 'Deep Meditation, Intuition & Memory Access';
      case BrainwaveBand.alpha:
        return 'Calm Focus, Flow State & Anxiety Reduction';
      case BrainwaveBand.beta:
        return 'Active Problem Solving & Alertness';
      case BrainwaveBand.gamma:
        return 'Peak Cognitive Processing & Synaptic Insight';
    }
  }

  double get minHz {
    switch (this) {
      case BrainwaveBand.delta:
        return 0.5;
      case BrainwaveBand.theta:
        return 4.0;
      case BrainwaveBand.alpha:
        return 8.0;
      case BrainwaveBand.beta:
        return 14.0;
      case BrainwaveBand.gamma:
        return 30.0;
    }
  }

  double get maxHz {
    switch (this) {
      case BrainwaveBand.delta:
        return 4.0;
      case BrainwaveBand.theta:
        return 8.0;
      case BrainwaveBand.alpha:
        return 14.0;
      case BrainwaveBand.beta:
        return 30.0;
      case BrainwaveBand.gamma:
        return 50.0;
    }
  }

  double get defaultHz {
    switch (this) {
      case BrainwaveBand.delta:
        return 2.5;
      case BrainwaveBand.theta:
        return 6.0;
      case BrainwaveBand.alpha:
        return 10.0;
      case BrainwaveBand.beta:
        return 18.0;
      case BrainwaveBand.gamma:
        return 40.0;
    }
  }

  Color get color {
    switch (this) {
      case BrainwaveBand.delta:
        return AppColors.waveDelta;
      case BrainwaveBand.theta:
        return AppColors.waveTheta;
      case BrainwaveBand.alpha:
        return AppColors.waveAlpha;
      case BrainwaveBand.beta:
        return AppColors.waveBeta;
      case BrainwaveBand.gamma:
        return AppColors.waveGamma;
    }
  }
}

/// Popular carrier pitch presets (including Solfeggio frequencies).
class CarrierPreset {
  final String name;
  final double frequency;
  final String description;

  const CarrierPreset({
    required this.name,
    required this.frequency,
    required this.description,
  });

  static const List<CarrierPreset> presets = [
    CarrierPreset(name: '174 Hz', frequency: 174.0, description: 'Natural Anesthetic & Foundation'),
    CarrierPreset(name: '285 Hz', frequency: 285.0, description: 'Cellular Restoration'),
    CarrierPreset(name: '396 Hz', frequency: 396.0, description: 'Liberation from Fear & Guilt'),
    CarrierPreset(name: '417 Hz', frequency: 417.0, description: 'Clearing Negative Energy & Change'),
    CarrierPreset(name: '432 Hz', frequency: 432.0, description: 'Natural Cosmic Tuning (Verdi A)'),
    CarrierPreset(name: '528 Hz', frequency: 528.0, description: 'Miracle Frequency & Transformation'),
    CarrierPreset(name: '639 Hz', frequency: 639.0, description: 'Interconnected Relationships & Harmony'),
    CarrierPreset(name: '741 Hz', frequency: 741.0, description: 'Awakening Intuition & Expression'),
    CarrierPreset(name: '852 Hz', frequency: 852.0, description: 'Spiritual Order & Clairvoyance'),
    CarrierPreset(name: '963 Hz', frequency: 963.0, description: 'Higher Pineal Crown Awakening'),
  ];
}

/// Model encapsulating state and frequency calculations for binaural beat synthesis.
class BinauralWave {
  final bool isEnabled;
  final BrainwaveBand band;
  final double beatFrequency; // e.g. 10.0 Hz
  final double carrierFrequency; // e.g. 432.0 Hz
  final double volume; // 0.0 to 1.0
  final bool isIsochronic; // Whether pulsed isochronic tones are layered

  const BinauralWave({
    this.isEnabled = true,
    this.band = BrainwaveBand.alpha,
    this.beatFrequency = 10.0,
    this.carrierFrequency = 432.0,
    this.volume = 0.6,
    this.isIsochronic = false,
  });

  /// The frequency generated for the left ear channel.
  double get leftEarFrequency => carrierFrequency - (beatFrequency / 2.0);

  /// The frequency generated for the right ear channel.
  double get rightEarFrequency => carrierFrequency + (beatFrequency / 2.0);

  BinauralWave copyWith({
    bool? isEnabled,
    BrainwaveBand? band,
    double? beatFrequency,
    double? carrierFrequency,
    double? volume,
    bool? isIsochronic,
  }) {
    final nextBand = band ?? this.band;
    final nextBeat = (beatFrequency ?? this.beatFrequency).clamp(
      nextBand.minHz,
      nextBand.maxHz,
    );

    return BinauralWave(
      isEnabled: isEnabled ?? this.isEnabled,
      band: nextBand,
      beatFrequency: nextBeat,
      carrierFrequency: (carrierFrequency ?? this.carrierFrequency).clamp(50.0, 1000.0),
      volume: (volume ?? this.volume).clamp(0.0, 1.0),
      isIsochronic: isIsochronic ?? this.isIsochronic,
    );
  }

  Map<String, dynamic> toJson() => {
        'isEnabled': isEnabled,
        'band': band.name,
        'beatFrequency': beatFrequency,
        'carrierFrequency': carrierFrequency,
        'volume': volume,
        'isIsochronic': isIsochronic,
      };

  factory BinauralWave.fromJson(Map<String, dynamic> json) {
    return BinauralWave(
      isEnabled: json['isEnabled'] as bool? ?? true,
      band: BrainwaveBand.values.firstWhere(
        (b) => b.name == json['band'],
        orElse: () => BrainwaveBand.alpha,
      ),
      beatFrequency: (json['beatFrequency'] as num?)?.toDouble() ?? 10.0,
      carrierFrequency: (json['carrierFrequency'] as num?)?.toDouble() ?? 432.0,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.6,
      isIsochronic: json['isIsochronic'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BinauralWave &&
          runtimeType == other.runtimeType &&
          isEnabled == other.isEnabled &&
          band == other.band &&
          (beatFrequency - other.beatFrequency).abs() < 0.001 &&
          (carrierFrequency - other.carrierFrequency).abs() < 0.001 &&
          (volume - other.volume).abs() < 0.001 &&
          isIsochronic == other.isIsochronic;

  @override
  int get hashCode => Object.hash(
        isEnabled,
        band,
        beatFrequency.toStringAsFixed(2),
        carrierFrequency.toStringAsFixed(1),
        volume.toStringAsFixed(2),
        isIsochronic,
      );
}
