import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'controllers/binaural_controller.dart';
import 'controllers/preset_controller.dart';
import 'controllers/soundscape_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SoundscapeController(),
        ),
        ChangeNotifierProvider(
          create: (_) => BinauralController(),
        ),
        ChangeNotifierProvider(
          create: (_) => PresetController(),
        ),
      ],
      child: const SoundScapeApp(),
    ),
  );
}
