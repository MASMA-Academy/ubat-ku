import 'package:flutter/material.dart';

class UbatKuTheme {
  // Primary Colors
  static const Color primary = Color(0xFF006b5f); // Teal
  static const Color primaryContainer = Color(0xFF00a896); // Bright Teal
  static const Color primaryFixed = Color(0xFF79f7e3); // Light Cyan
  static const Color primaryFixedDim = Color(0xFF59dbc7); // Dim Cyan

  // Secondary Colors
  static const Color secondary = Color(0xFF006d36); // Green
  static const Color secondaryContainer = Color(0xFF6dfe9c); // Bright Green
  static const Color secondaryFixed = Color(0xFF6dfe9c);
  static const Color secondaryFixedDim = Color(0xFF4de082);

  // Tertiary Colors
  static const Color tertiary = Color(0xFF005bc0); // Blue
  static const Color tertiaryContainer = Color(0xFF5694ff); // Light Blue
  static const Color tertiaryFixed = Color(0xFF8ADFF6);
  static const Color tertiaryFixedDim = Color(0xFFadc7ff);

  // Error Colors
  static const Color error = Color(0xFFba1a1a);
  static const Color errorContainer = Color(0xFFffdad6);

  // Surface Colors
  static const Color surface = Color(0xFFf8f9ff); // Very Light Blue-White
  static const Color surfaceContainer = Color(0xFFe6eeff);
  static const Color surfaceContainerLow = Color(0xFFeff4ff);
  static const Color surfaceContainerHigh = Color(0xFFdee9fc);
  static const Color surfaceContainerHighest = Color(0xFFd9e3f6);
  static const Color surfaceLowest = Color(0xFFffffff);
  static const Color surfaceDim = Color(0xFFd0dbed);
  static const Color surfaceBright = Color(0xFFf8f9ff);

  // Text & Content Colors
  static const Color onSurface = Color(0xFF121c2a); // Dark Navy
  static const Color onSurfaceVariant = Color(0xFF3c4946);
  static const Color onPrimary = Color(0xFFffffff);
  static const Color onPrimaryContainer = Color(0xFF00352e);
  static const Color onSecondary = Color(0xFFffffff);
  static const Color onSecondaryContainer = Color(0xFF007439);
  static const Color onTertiary = Color(0xFFffffff);
  static const Color onTertiaryContainer = Color(0xFF002c64);
  static const Color onBackground = Color(0xFF121c2a);
  static const Color onError = Color(0xFFffffff);

  // Other Colors
  static const Color outline = Color(0xFF6c7a76);
  static const Color outlineVariant = Color(0xFFbbcac5);
  static const Color inverseSurface = Color(0xFF27313f);
  static const Color inverseOnSurface = Color(0xFFeaf1ff);
  static const Color inversePrimary = Color(0xFF59dbc7);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: Color(0xFF93000a),
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: inverseSurface,
        onInverseSurface: inverseOnSurface,
        inversePrimary: inversePrimary,
      ),
      fontFamily: 'Inter',
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          color: onSurface,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainer,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: error, width: 2),
        ),
        labelStyle: TextStyle(color: onSurfaceVariant, fontSize: 16),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceVariant,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
