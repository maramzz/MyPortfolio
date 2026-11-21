import 'package:flutter/material.dart';

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
  static final ThemeData light = _buildTheme(brightness: Brightness.light);
  static final ThemeData dark = _buildTheme(brightness: Brightness.dark);

  static ThemeData _buildTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final colors =
        ColorScheme.fromSeed(
          seedColor: AppColors.pink,
          brightness: brightness,
        ).copyWith(
          primary: isDark ? const Color(0xFFFF9AB5) : AppColors.pinkDark,
          onPrimary: isDark ? const Color(0xFF35111E) : Colors.white,
          secondary: isDark ? const Color(0xFFF5B6C8) : AppColors.pink,
          onSecondary: isDark ? const Color(0xFF35111E) : Colors.white,
          surface: isDark ? const Color(0xFF241D23) : Colors.white,
          onSurface: isDark ? const Color(0xFFFFF4F7) : AppColors.text,
          onSurfaceVariant: isDark ? const Color(0xFFD8C5CD) : AppColors.muted,
          outline: isDark ? const Color(0xFF806A74) : const Color(0xFFE7CAD4),
          outlineVariant: isDark ? const Color(0xFF57434B) : AppColors.border,
          secondaryContainer: isDark
              ? const Color(0xFF512B3A)
              : const Color(0xFFFDE8EF),
          onSecondaryContainer: isDark
              ? const Color(0xFFFFDCE6)
              : const Color(0xFF8A2949),
          surfaceContainerLow: isDark
              ? const Color(0xFF2E242C)
              : AppColors.pinkBg,
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      brightness: brightness,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF191519)
          : AppColors.pinkBg,
      dividerColor: colors.outlineVariant,
    );
    final textTheme = base.textTheme
        .copyWith(
          headlineLarge: base.textTheme.headlineLarge?.copyWith(
            fontFamily: 'Georgia',
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
            fontFamily: 'Georgia',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: base.textTheme.headlineSmall?.copyWith(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w700,
          ),
          titleLarge: base.textTheme.titleLarge?.copyWith(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w700,
          ),
        )
        .apply(bodyColor: colors.onSurface, displayColor: colors.onSurface);

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: base.scaffoldBackgroundColor,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF392C35)
            : const Color(0xFF29242A),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
