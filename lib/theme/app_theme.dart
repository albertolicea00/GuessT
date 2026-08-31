import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pastel, kid-friendly "arcade" look: soft mint background, candy-colored
/// cards, dark plum text (never white-on-light — everything here assumes
/// a light background, unlike the old dark theme it replaced). Baloo 2 is
/// the chunky rounded display font that sells the "kids' video game" feel;
/// every plain TextStyle in the app inherits it from the theme below,
/// since none of them set their own fontFamily.
class AppTheme {
  static const Color background = Color(0xFFD3F6DE);
  static const Color surface = Colors.white;
  static const Color accent = Color(0xFFB39DFF);
  static const Color textDark = Color(0xFF352F4F);
  static const Color textMuted = Color(0xFF6F6885);

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    final rounded = GoogleFonts.baloo2TextTheme(base.textTheme);
    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.light,
        primary: accent,
        secondary: accent,
        surface: surface,
        onSurface: textDark,
      ),
      textTheme: rounded.apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      iconTheme: const IconThemeData(color: textDark),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          textStyle: GoogleFonts.baloo2(fontSize: 18, fontWeight: FontWeight.w800),
          shape: const StadiumBorder(),
          elevation: 4,
          shadowColor: accent.withValues(alpha: 0.5),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.baloo2(
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
