import 'package:flutter/material.dart';

/// Cyber-Ambient color palette designed for high contrast, low eye-strain,
/// and neon-accented glassmorphism in dark environments.
class AppColors {
  AppColors._();

  // Backgrounds & Surface
  static const Color background = Color(0xFF0A0D14);
  static const Color surface = Color(0xFF121722);
  static const Color surfaceElevated = Color(0xFF1A2130);
  static const Color surfaceHighlight = Color(0xFF242E42);

  // Glass & Overlay
  static const Color glassBackground = Color(0x331E2638);
  static const Color glassBorder = Color(0x3364748B);
  static const Color glassBorderGlow = Color(0x5538BDF8);

  // Brand / Primary Accents (Cyan / Electric Sky)
  static const Color primary = Color(0xFF00E5FF);
  static const Color primaryDark = Color(0xFF0091EA);
  static const Color primaryGlow = Color(0x4000E5FF);

  // Secondary Accents (Violet / Purple Nebula)
  static const Color secondary = Color(0xFFB388FF);
  static const Color secondaryGlow = Color(0x40B388FF);

  // Tertiary Accents (Amber / Campfire)
  static const Color accentAmber = Color(0xFFFFB300);
  static const Color accentCoral = Color(0xFFFF5252);
  static const Color accentEmerald = Color(0xFF00E676);

  // Brainwave Band Indicator Colors
  static const Color waveDelta = Color(0xFF7C4DFF); // Deep Purple
  static const Color waveTheta = Color(0xFF00B0FF); // Deep Sky Blue
  static const Color waveAlpha = Color(0xFF00E676); // Mint Green
  static const Color waveBeta = Color(0xFFFFAB00);  // Vivid Amber
  static const Color waveGamma = Color(0xFFFF4081); // Bright Magenta

  // Text & Content
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);

  // Spatial Soundstage Elements
  static const Color radarGrid = Color(0x1F94A3B8);
  static const Color radarCrosshair = Color(0x3394A3B8);
  static const Color listenerNode = Color(0xFF00E5FF);
  static const Color listenerRings = Color(0x3300E5FF);
}
