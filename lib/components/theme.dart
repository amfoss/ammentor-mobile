// theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFF6C32E); // Yellow
  static const background = Color(0xFF121212);
  static const surface = Color(0xFF2E2E2E);
  static const white = Colors.white;
  static const white70 = Colors.white70;
  static const red = Colors.redAccent;
  static const grey = Colors.grey;
  static const errorDark = Color(0xFFB00020);
  static const Color cardBackground = Color.fromARGB(102, 102, 102, 102);
  static const border = Color(0xFF837E93);
  static const textDark = Color(0xFF393939);
  static const accent = Color(0xFF9F7BFF);
}

final inputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: Colors.grey.shade800,
  floatingLabelStyle: const TextStyle(color: AppColors.white),
  labelStyle: const TextStyle(color: AppColors.white),
  hintStyle: const TextStyle(color: AppColors.white70),
  prefixIconColor: AppColors.primary,
  suffixIconColor: AppColors.primary,
  iconColor: AppColors.primary,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.white70),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.primary, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
  ),
);

final ThemeData appTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.primary,
    surface: AppColors.background,
    error: AppColors.red,
  ),
  inputDecorationTheme: inputDecorationTheme,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.white),
    bodyLarge: TextStyle(color: AppColors.white),
    titleMedium: TextStyle(color: AppColors.white),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.primary,
    elevation: 0,
  ),
);

class AppTextStyles {
  static const heading = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 27,
    color: AppColors.primary,
  );

  static const label = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: AppColors.primary,
  );

  static const input = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 13,
    color: AppColors.white,
  );

  static const button = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 15,
    color: AppColors.white,
  );

  static const link = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: AppColors.primary,
  );
}