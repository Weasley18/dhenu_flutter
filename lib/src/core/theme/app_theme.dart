import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Theme provider that provides the appropriate theme based on the device's brightness
final themeProvider = Provider<ThemeData>((ref) {
  // For now, we'll just return the light theme, but this could be expanded to
  // use the device's brightness or a user-selected theme
  return _lightTheme;
});

/// Light theme for the Dhenu app
final _lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: Colors.white,
    secondary: AppColors.accent,
    onSecondary: Colors.black,
    secondaryContainer: AppColors.accent.withOpacity(0.2),
    onSecondaryContainer: AppColors.accent,
    error: AppColors.error,
    onError: Colors.white,
    background: AppColors.backgroundLight,
    onBackground: AppColors.textLight,
    surface: Colors.white,
    onSurface: AppColors.textLight,
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  textTheme: GoogleFonts.robotoTextTheme().copyWith(
    displayLarge: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.roboto(
      color: AppColors.textLight,
    ),
    bodyMedium: GoogleFonts.roboto(
      color: AppColors.textLight,
    ),
    bodySmall: GoogleFonts.roboto(
      color: AppColors.textLight,
    ),
    labelLarge: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.roboto(
      color: AppColors.textLight,
    ),
    labelSmall: GoogleFonts.roboto(
      color: AppColors.textLight,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.backgroundLight,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.iconLight),
    titleTextStyle: GoogleFonts.roboto(
      color: AppColors.textLight,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.textLight.withOpacity(0.2)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.textLight.withOpacity(0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.error, width: 2),
    ),
    labelStyle: TextStyle(color: AppColors.textLight.withOpacity(0.8)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.tabIconSelectedLight,
    unselectedItemColor: AppColors.tabIconDefaultLight,
  ),
);

/// Dark theme for the Dhenu app - largely the same as light theme based on the original app
final _darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: Colors.white,
    secondary: AppColors.accent,
    onSecondary: Colors.black,
    secondaryContainer: AppColors.accent.withOpacity(0.2),
    onSecondaryContainer: AppColors.accent,
    error: AppColors.error,
    onError: Colors.white,
    background: AppColors.backgroundDark,
    onBackground: AppColors.textDark,
    surface: Colors.white,
    onSurface: AppColors.textDark,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  // The rest of the theme would be similar to the light theme but with dark mode colors
);
