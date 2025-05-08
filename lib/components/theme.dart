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
  static const darkgrey = Color(0xFF2E2E2E);
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
  static TextStyle heading(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: height * 0.035, // ~27px on 800px height
      color: AppColors.primary,
    );
  }

  static TextStyle subheading(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: height * 0.028, // ~22px
      color: AppColors.white,
    );
  }

  static TextStyle body(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: height * 0.020, // ~16px
      color: AppColors.white,
    );
  }

  static TextStyle caption(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: height * 0.016, // ~12px
      color: AppColors.white70,
    );
  }

  static TextStyle input(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: height * 0.018, // ~14px
      color: AppColors.white,
    );
  }

  static TextStyle label(BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  return TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: height * 0.018, // ~14–15px
    color: AppColors.white,
  );
}

  static TextStyle button(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: height * 0.02,
      color: AppColors.background,
    );
  }

  static TextStyle link(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: height * 0.018,
      color: AppColors.primary,
      decoration: TextDecoration.underline,
    );
  }
}