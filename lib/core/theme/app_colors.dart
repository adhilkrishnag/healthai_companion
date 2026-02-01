import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors
  static const Color secondary = Color(0xFF14B8A6); // Teal
  static const Color secondaryLight = Color(0xFF2DD4BF);
  static const Color secondaryDark = Color(0xFF0D9488);

  // Accent Colors
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  // Semantic Colors
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);

  // Light Theme Colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color inputFillLight = Color(0xFFF1F5F9);
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color chipBackgroundLight = Color(0xFFE0E7FF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color inputFillDark = Color(0xFF334155);
  static const Color dividerDark = Color(0xFF334155);
  static const Color chipBackgroundDark = Color(0xFF312E81);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // Health Metric Colors
  static const Color stepsColor = Color(0xFF22C55E);
  static const Color sleepColor = Color(0xFF8B5CF6);
  static const Color weightColor = Color(0xFFF59E0B);
  static const Color waterColor = Color(0xFF06B6D4);
  static const Color heartColor = Color(0xFFEF4444);
  static const Color moodHappyColor = Color(0xFF22C55E);
  static const Color moodNeutralColor = Color(0xFFF59E0B);
  static const Color moodSadColor = Color(0xFF3B82F6);

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradientLight = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradientDark = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Glassmorphism Colors
  static Color glassLight = Colors.white.withValues(alpha: 0.2);
  static Color glassDark = Colors.black.withValues(alpha: 0.2);
  static Color glassBorderLight = Colors.white.withValues(alpha: 0.3);
  static Color glassBorderDark = Colors.white.withValues(alpha: 0.1);
}
