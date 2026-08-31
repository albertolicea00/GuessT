import 'package:flutter/material.dart';

/// Pastel, kid-friendly "arcade" look: soft mint background, candy-colored
/// cards, dark plum text (never white-on-light — everything here assumes
/// a light background, unlike the old dark theme it replaced).
class AppTheme {
  static const Color background = Color(0xFFD3F6DE);
  static const Color surface = Colors.white;
  static const Color accent = Color(0xFFB39DFF);
  static const Color textDark = Color(0xFF352F4F);
  static const Color textMuted = Color(0xFF6F6885);

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.light,
        primary: accent,
        secondary: accent,
        surface: surface,
        onSurface: textDark,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      iconTheme: const IconThemeData(color: textDark),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          shape: const StadiumBorder(),
          elevation: 4,
          shadowColor: accent.withValues(alpha: 0.5),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? accent : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? accent.withValues(alpha: 0.5)
              : const Color(0xFFE0DCEF),
        ),
      ),
    );
  }
}
