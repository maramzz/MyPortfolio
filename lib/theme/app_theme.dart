import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Same palette as the web portfolio
class AppColors {
  static const pink = Color(0xFFE85D85);
  static const pinkDark = Color(0xFFC83F6B);
  static const pinkLight = Color(0xFFF8C8D8);
  static const pinkBg = Color(0xFFFFF7F9);
  static const text = Color(0xFF29242A);
  static const muted = Color(0xFF6B636C);
  static const border = Color(0xFFF1DCE4);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.pink,
        primary: AppColors.pink,
        onSurface: AppColors.text,
      ),
      scaffoldBackgroundColor: AppColors.pinkBg,
    );

    final googleTextTheme = GoogleFonts.dmSansTextTheme();
    final textTheme = base.textTheme
        .copyWith(
          displayLarge: googleTextTheme.displayLarge,
          displayMedium: googleTextTheme.displayMedium,
          displaySmall: googleTextTheme.displaySmall,
          headlineLarge: googleTextTheme.headlineLarge,
          headlineMedium: googleTextTheme.headlineMedium,
          headlineSmall: googleTextTheme.headlineSmall,
          titleLarge: googleTextTheme.titleLarge,
          titleMedium: googleTextTheme.titleMedium,
          titleSmall: googleTextTheme.titleSmall,
          bodyLarge: googleTextTheme.bodyLarge,
          bodyMedium: googleTextTheme.bodyMedium,
          bodySmall: googleTextTheme.bodySmall,
          labelLarge: googleTextTheme.labelLarge,
          labelMedium: googleTextTheme.labelMedium,
          labelSmall: googleTextTheme.labelSmall,
        )
        .copyWith(
          headlineLarge: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        )
        .apply(bodyColor: AppColors.text, displayColor: AppColors.text);
    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.pinkBg,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
