import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RerezTheme {
  RerezTheme._();

  static const Color oledBlack = Color(0xFF000000);
  static const Color panelBlack = Color(0xFF070707);
  static const Color glassWhite = Color(0x1FFFFFFF);
  static const Color glassBorder = Color(0x26FFFFFF);
  static const Color neonWhite = Color(0xFFF7FBFF);
  static const Color mutedWhite = Color(0xB8F7FBFF);
  static const Color softWhite = Color(0x8CF7FBFF);
  static const Color orange = Color(0xFFFF7A1A);
  static const Color deepOrange = Color(0xFFFF4F0A);
  static const Color warning = Color(0xFFFFB84D);
  static const Color error = Color(0xFFFF5A5F);
  static const Color success = Color(0xFF48D597);

  static ThemeData get dark {
    final baseTextTheme = GoogleFonts.interTextTheme();
    final displayTextTheme = GoogleFonts.outfitTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: oledBlack,
      colorScheme: const ColorScheme.dark(
        surface: oledBlack,
        primary: orange,
        secondary: deepOrange,
        error: error,
        onPrimary: neonWhite,
        onSecondary: neonWhite,
        onSurface: neonWhite,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: displayTextTheme.displayLarge?.copyWith(
          color: neonWhite,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.2,
        ),
        displayMedium: displayTextTheme.displayMedium?.copyWith(
          color: neonWhite,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),
        headlineLarge: displayTextTheme.headlineLarge?.copyWith(
          color: neonWhite,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: displayTextTheme.headlineMedium?.copyWith(
          color: neonWhite,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        headlineSmall: displayTextTheme.headlineSmall?.copyWith(
          color: neonWhite,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: displayTextTheme.titleLarge?.copyWith(
          color: neonWhite,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: neonWhite,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: baseTextTheme.titleSmall?.copyWith(
          color: mutedWhite,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: neonWhite,
          height: 1.45,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: mutedWhite,
          height: 1.45,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: softWhite,
          height: 1.35,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          color: neonWhite,
          fontWeight: FontWeight.w700,
        ),
        labelMedium: baseTextTheme.labelMedium?.copyWith(
          color: mutedWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: oledBlack,
        foregroundColor: neonWhite,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: oledBlack,
        selectedItemColor: orange,
        unselectedItemColor: softWhite,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        hintStyle: const TextStyle(color: softWhite),
        labelStyle: const TextStyle(color: mutedWhite),
        errorStyle: const TextStyle(
          color: error,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: orange, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: error, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: panelBlack,
        contentTextStyle: baseTextTheme.bodyMedium?.copyWith(
          color: neonWhite,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: glassBorder),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: glassBorder,
        thickness: 1,
        space: 32,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
