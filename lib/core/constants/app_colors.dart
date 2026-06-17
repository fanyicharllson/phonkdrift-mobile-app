import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === BRAND CORE ===
  static const Color phonkRed = Color(0xFFFF0055);
  static const Color phonkRedDark = Color(0xFFCC0044);
  static const Color phonkRedGlow = Color(0x55FF0055);

  // === BACKGROUNDS ===
  static const Color bgDeep = Color(0xFF0A0A0C);
  static const Color bgCard = Color(0xFF111116);
  static const Color bgSurface = Color(0xFF18181F);
  static const Color bgElevated = Color(0xFF1F1F28);

  // === TEXT ===
  static const Color textPrimary = Color(0xFFF0F0F5);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color textMuted = Color(0xFF44445A);
  static const Color textRed = Color(0xFFFF0055);

  // === BORDERS ===
  static const Color borderSubtle = Color(0xFF222230);
  static const Color borderRed = Color(0xFFFF0055);
  static const Color borderGlow = Color(0x33FF0055);

  // === UTILITY ===
  static const Color success = Color(0xFF1DB954);
  static const Color warning = Color(0xFFFFA500);
  static const Color error = Color(0xFFFF0055);
  static const Color transparent = Colors.transparent;

  // === GRADIENTS ===
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0A0C), Color(0xFF14040A), Color(0xFF0A0A0C)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFFF0055), Color(0xFF8B0012)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A24), Color(0xFF111116)],
  );
}
