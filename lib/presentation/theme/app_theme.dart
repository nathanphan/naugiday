import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Color(0xFFF08A4B);
  static const _secondaryColor = Color(0xFF78C257);
  static const _tertiaryColor = Color(0xFF76C5DD);
  static const _surfaceTint = Color(0xFFF7F4EE);
  static const _surfaceTintDark = Color(0xFF161616);
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXL = 28;
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double shadowBlur = 12;
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animMedium = Duration(milliseconds: 220);
  static const Curve animCurve = Curves.easeOutCubic;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _tertiaryColor,
        brightness: Brightness.light,
        surface: _surfaceTint,
      ),
      scaffoldBackgroundColor: _surfaceTint,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.2),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        margin: const EdgeInsets.all(spacingS),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLarge)),
        shadowColor: Colors.black.withOpacity(0.06),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXL)),
        ),
        backgroundColor: _surfaceTint,
        surfaceTintColor: _surfaceTint,
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.1),
        padding: const EdgeInsets.symmetric(horizontal: spacingS, vertical: spacingXS),
        selectedColor: _primaryColor.withOpacity(0.12),
        backgroundColor: Colors.white,
        disabledColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusXL)),
        side: BorderSide(color: Colors.black.withOpacity(0.05)),
        shadowColor: Colors.black.withOpacity(0.04),
        elevation: 0,
        pressElevation: 0,
        secondarySelectedColor: _secondaryColor.withOpacity(0.12),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _tertiaryColor,
        brightness: Brightness.dark,
        surface: _surfaceTintDark,
      ),
      scaffoldBackgroundColor: _surfaceTintDark,
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.all(spacingS),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLarge)),
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXL)),
        ),
        backgroundColor: _surfaceTintDark,
        surfaceTintColor: _surfaceTintDark,
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.1),
        padding: const EdgeInsets.symmetric(horizontal: spacingS, vertical: spacingXS),
        selectedColor: _primaryColor.withOpacity(0.18),
        backgroundColor: const Color(0xFF1E1E1E),
        disabledColor: Colors.grey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusXL)),
        side: BorderSide(color: Colors.white.withOpacity(0.06)),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 0,
        pressElevation: 0,
      ),
    );
  }
}
