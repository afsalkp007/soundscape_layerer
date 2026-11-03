# 🎧 SoundScape Layerer (Custom Binaural & Ambient Mixer)

**SoundScape Layerer** is an ambient sound workstation and procedural binaural beat synthesizer built with Flutter, targeting **iOS** (with background audio capability) and connected to **Supabase** for cloud preset synchronization and community preset discovery.

---

## 🌟 Key Features

- **🌐 2D Interactive Spatial Soundstage**: Drag ambient sound orbs around a central listener avatar. Distance determines volume attenuation, while horizontal placement calculates stereo panning in real-time.
- **🎛️ Multi-Track Ambient Mixer Console**: Independent volume faders, dB meters, rotary pan dials, mute, and solo matrix for organic audio channels (Rain, Thunder, Ocean Surf, Night Forest, Campfire, Wind Chimes, Café, White/Pink/Brown noise).
- **🧠 Procedural Binaural Beat Synthesizer**:
  - Full brainwave spectrum: **Delta** (0.5–4 Hz), **Theta** (4–8 Hz), **Alpha** (8–14 Hz), **Beta** (14–30 Hz), and **Gamma** (30–50 Hz).
  - Carrier tone adjustment (100 Hz – 963 Hz Solfeggio sacred frequencies).
  - Real-time animated phase visualizer rendering dual-ear waveforms and interference envelopes.
  - Isochronic pulse modulation toggle.
- **📱 iOS First-Class Architecture**:
  - `AVAudioSessionCategoryPlayback` configured in `AppDelegate.swift`.
  - `UIBackgroundModes` `audio` enabled in `Info.plist` for continuous playback when the iPhone screen is locked.
- **⚡ Supabase Backend**:
  - PostgreSQL table with Row-Level Security (RLS) for user presets.
  - Public community soundscape sharing & like counter.
  - Offline-first fallback cache: works seamlessly without active network.
- **⏱️ Smart Sleep Timer**: Smooth logarithmic fade-out automation over the final 60 seconds before playback stops to avoid abrupt waking.
- **💾 Presets & Memory Bank**: Save tailored soundscapes with persistence. Ships with factory presets: *Deep Sleep & Ocean Theta*, *Rainy Café Flow Alpha*, *Campfire Stargaze Delta*, *Gamma Superlearning Lab*.

---

## 🏛️ Architecture Overview

The app follows a clean, reactive architecture powered by `ChangeNotifier` and `Provider`:

```
lib/
├── core/
│   ├── config/          # SupabaseConfig (URL, Anon Key, connection status)
│   ├── constants/       # AppColors, AppTypography, DefaultTracks, FactoryPresets
│   ├── theme/           # Dark futuristic Glassmorphic ThemeData
│   └── utils/           # AudioMath (panning law, dB) & pure Dart WavGenerator
├── models/              # Immutable domain entities (Tracks, Waves, Presets, Spatial)
├── services/
│   ├── audio/           # Multi-track engine, procedural noise & binaural synth
│   ├── storage/         # Preset serialization & persistent storage
│   ├── supabase/        # SupabasePresetService (cloud sync & community presets)
│   └── timer/           # Sleep timer countdown & fade-out automation
├── controllers/         # SoundscapeController, BinauralController, PresetController
├── widgets/
│   ├── common/          # GlassCard, NeonSlider, VolumeKnob, PulsingGlow
│   ├── spatial/         # 2D Soundstage CustomPainter & draggable SoundOrbs
│   ├── mixer/           # Vertical mixer fader strips and category filters
│   ├── binaural/        # Brainwave band rack & phase visualizer
│   ├── presets/         # PresetSelectorSheet (Local + Supabase tabs)
│   └── master/          # Bottom floating playback dock & sleep timer modal
└── views/               # Spatial Stage, Mixer Studio, Binaural Rack, HomeScreen
```

---

## 📱 iOS Setup & Background Playback

The iOS project has already been configured with background audio permissions:

1. **Info.plist**:
   ```xml
   <key>UIBackgroundModes</key>
   <array>
       <string>audio</string>
   </array>
   ```
2. **AppDelegate.swift**:
   Configured with `AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])`.

### Run on iOS Simulator or Device:
```bash
cd /Users/home/Developer/soundscape_layerer
flutter pub get
cd ios && pod install && cd ..
flutter run -d ios
```

---

## ⚡ Supabase Setup (Optional Cloud Sync)

1. Open your [Supabase Dashboard](https://supabase.com).
2. Go to the **SQL Editor** and run `supabase/schema.sql`.
3. Provide your Supabase credentials when running the app:
   ```bash
   flutter run -d ios \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key
   ```
*Note: If no Supabase credentials are provided, the app automatically runs in offline-first mode with full local storage persistence and mock community discovery.*

---

## 🧪 Testing

Run the comprehensive unit test suite covering domain models, audio math, wave generators, and controllers:
```bash
flutter test
```

---

## 📜 Commit History (Oct 30, 2026 onwards)

This repository was constructed with granular, chronological commits:
- `chore: initial repository setup and README` (Oct 30)
- `feat(scaffold): setup project structure, pubspec.yaml, and analysis options` (Oct 30)
- `feat(theme): add soundscape design system, dark palette, and typography` (Oct 30)
- `feat(models): implement spatial position and sound track domain models` (Oct 30)
- `feat(models): add binaural wave and sound preset entities` (Oct 31)
- `feat(audio): implement audio math utilities and procedural wav audio generator` (Oct 31)
- `feat(audio): build procedural noise synthesis and binaural beat engine` (Oct 31)
- `feat(service): create multi-track audio engine service and mock sound registry` (Nov 01)
- `feat(service): implement sleep timer with linear and logarithmic fade-out` (Nov 01)
- `feat(storage): build preset persistence and factory preset catalog` (Nov 01)
- `feat(state): develop reactive soundscape and mixer state controller` (Nov 02)
- `feat(ui): create reusable glassmorphism cards, glowing dials, and sliders` (Nov 02)
- `feat(spatial): build 2D interactive spatial soundstage canvas` (Nov 02)
- `feat(binaural): build binaural rack UI with brainwave band selector and frequency visualizer` (Nov 03)
- `feat(ui): implement multi-track mixer panel, master playback bar, and sleep timer modal` (Nov 03)
- `feat(views): assemble main app views, responsive navigation tabs, and entry point` (Nov 03)
- `test: add comprehensive test suite for models, audio math, wav generator, and controllers` (Nov 03)
- `feat(ios): configure iOS runner, audio background modes, and info.plist` (Nov 03)
- `feat(supabase): create supabase schema, client config, and cloud preset service` (Nov 03)
- `feat(ui): integrate supabase cloud sync and community presets into preset drawer` (Nov 03)
- `docs: update README with iOS setup and Supabase configuration guide` (Nov 03)
