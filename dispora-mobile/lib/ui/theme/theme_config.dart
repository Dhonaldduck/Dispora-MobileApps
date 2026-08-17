import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.putihHangat,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.merahBata,
        primary: AppColors.merahBata,
        secondary: AppColors.terracotta,
        surface: AppColors.putihBersih,
        error: AppColors.destructiveRed,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: AppColors.cokelatTua,
        displayColor: AppColors.cokelatPekat,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.putihHangat,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.cokelatTua),
      ),
      cardTheme: CardThemeData(
        color: AppColors.putihBersih,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderCream, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.merahBata,
          foregroundColor: AppColors.pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99), // Pill-shape
          ),
          elevation: 0,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderCream,
        thickness: 1,
      ),
    );
  }
}
