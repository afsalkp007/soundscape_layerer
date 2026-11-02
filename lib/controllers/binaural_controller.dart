import 'package:flutter/foundation.dart';
import '../models/binaural_wave.dart';
import '../services/audio/binaural_synthesizer.dart';

/// Controller for tuning brainwave entrainment frequencies and carrier tones.
class BinauralController extends ChangeNotifier {
  final BinauralSynthesizer _synthesizer;
  BinauralWave _wave;

  BinauralController({
    BinauralSynthesizer? synthesizer,
    BinauralWave initialWave = const BinauralWave(),
  })  : _synthesizer = synthesizer ?? BinauralSynthesizer(initialWave: initialWave),
        _wave = initialWave;

  BinauralWave get wave => _wave;
  BinauralSynthesizer get synthesizer => _synthesizer;

  bool get isEnabled => _wave.isEnabled;
  BrainwaveBand get currentBand => _wave.band;
  double get beatFrequency => _wave.beatFrequency;
  double get carrierFrequency => _wave.carrierFrequency;
  double get volume => _wave.volume;
  bool get isIsochronic => _wave.isIsochronic;

  double get leftEarHz => _wave.leftEarFrequency;
  double get rightEarHz => _wave.rightEarFrequency;

  void toggleEnabled(bool enabled) {
    _wave = _wave.copyWith(isEnabled: enabled);
    _synthesizer.updateWave(_wave);
    notifyListeners();
  }

  void selectBand(BrainwaveBand band) {
    _wave = _wave.copyWith(
      band: band,
      beatFrequency: band.defaultHz,
    );
    _synthesizer.updateWave(_wave);
    notifyListeners();
  }

  void setBeatFrequency(double hz) {
    _wave = _wave.copyWith(beatFrequency: hz);
    _synthesizer.updateWave(_wave);
    notifyListeners();
  }

  void setCarrierFrequency(double hz) {
    _wave = _wave.copyWith(carrierFrequency: hz);
    _synthesizer.updateWave(_wave);
    notifyListeners();
  }

  void setVolume(double vol) {
    _wave = _wave.copyWith(volume: vol);
    _synthesizer.updateWave(_wave);
    notifyListeners();
  }

  void toggleIsochronic(bool isochronic) {
    _wave = _wave.copyWith(isIsochronic: isochronic);
    _synthesizer.updateWave(_wave);
    notifyListeners();
  }

  void loadFromWave(BinauralWave wave) {
    _wave = wave;
    _synthesizer.updateWave(_wave);
    notifyListeners();
  }
}
