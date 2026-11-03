import 'package:flutter/material.dart';
import 'core/theme/soundscape_theme.dart';
import 'views/home_screen.dart';

/// Root application widget configuring dark theme and home routes.
class SoundScapeApp extends StatelessWidget {
  const SoundScapeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoundScape Layerer',
      debugShowCheckedModeBanner: false,
      theme: SoundScapeTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
