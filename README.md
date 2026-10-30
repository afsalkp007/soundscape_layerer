# 🎧 SoundScape Layerer (Custom Binaural & Ambient Mixer)

**SoundScape Layerer** is a cross-platform Flutter application engineered for deep focus, meditation, relaxation, and lucid dreaming. It blends a **2D interactive spatial soundstage**, a **multi-track ambient sound console**, and a **procedural binaural beat synthesizer** with continuous phase-differential tone generation.

---

## ✨ Features

- **🌐 2D Interactive Spatial Soundstage**: Drag ambient sound orbs around a central listener avatar. The engine dynamically computes distance attenuation (volume decay) and angular stereo panning (-1.0 Left to +1.0 Right) in real-time.
- **🎛️ Multi-Track Ambient Mixer**: Independent volume sliders, stereo pan controls, mute, and solo matrix for an extensive catalog of organic ambient sounds (Rain, Campfire, Waves, Forest Night, Wind Chimes, Café, White/Pink/Brown noise).
- **🧠 Custom Binaural Beat Synthesizer**:
  - Full brainwave spectrum: **Delta** (0.5–4 Hz), **Theta** (4–8 Hz), **Alpha** (8–14 Hz), **Beta** (14–30 Hz), and **Gamma** (30–50 Hz).
  - Carrier frequency fine-tuning (100 Hz – 963 Hz Solfeggio sacred frequencies).
  - Isochronic pulse modulation toggle.
  - Real-time animated phase visualizer.
- **⏱️ Smart Sleep Timer**: Smooth linear and logarithmic fade-out automation over the final 60 seconds before playback stops to prevent abrupt waking.
- **💾 Presets & Memory Bank**: Save, rename, and load tailored soundscapes with persistence. Ships with curated factory presets.
- **💎 Dark Cyber-Ambient Design**: Glassmorphic translucent surfaces, glowing neon dials, responsive tablet & mobile layout.

---

## 🏛️ Architecture Overview

The app follows a clean, reactive architecture powered by `ChangeNotifier` and `Provider`:

```
lib/
├── core/
│   ├── constants/       # Color palette, typography, audio frequencies
│   ├── theme/           # Dark futuristic Glassmorphic ThemeData
│   └── utils/           # Audio math (panning law, dB) & WAV byte builder
├── models/              # Immutable domain entities (Tracks, Waves, Presets, Spatial)
├── services/
│   ├── audio/           # Multi-track engine, procedural noise & binaural synth
│   ├── storage/         # Preset serialization & persistent storage
│   └── timer/           # Sleep timer countdown & fade-out automation
├── controllers/         # State controllers orchestrating playback & UI
├── widgets/
│   ├── common/          # GlassCard, NeonSlider, VolumeKnob, PulsingGlow
│   ├── spatial/         # 2D Soundstage CustomPainter & draggable SoundOrbs
│   ├── mixer/           # Vertical/Horizontal mixer fader strips
│   ├── binaural/        # Brainwave band rack & phase visualizer
│   └── master/          # Bottom floating playback bar & timer modal
└── views/               # Spatial Stage, Mixer Studio, Binaural Rack, Presets
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev) (v3.10.0 or later)
- Dart SDK (v3.0.0 or later)

### Run the App
```bash
flutter pub get
flutter run
```

### Run Test Suite
```bash
flutter test
```
