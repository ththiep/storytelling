import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Kid-facing typography aligned with companion_platform.
/// Body: Mitr · Display / story titles: Nunito.
abstract final class AppTypography {
  static TextStyle _mitr({
    required double size,
    required FontWeight weight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.mitr(
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: color ?? AppColors.textPrimary,
    );
  }

  static TextStyle _nunito({
    required double size,
    required FontWeight weight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.nunito(
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: color ?? AppColors.textPrimary,
    );
  }

  static TextStyle appTitle({Color? color}) => _nunito(
    size: 34,
    weight: FontWeight.w900,
    color: color,
  );

  static TextStyle screenTitle({Color? color}) => _nunito(
    size: 24,
    weight: FontWeight.w900,
    color: color,
  );

  static TextStyle sectionTitle({Color? color}) => _nunito(
    size: 20,
    weight: FontWeight.w800,
    color: color,
  );

  static TextStyle cardTitle({Color? color}) => _nunito(
    size: 21,
    weight: FontWeight.w800,
    height: 1.15,
    color: color,
  );

  static TextStyle modeTitle({Color? color}) => _nunito(
    size: 19,
    weight: FontWeight.w800,
    color: color,
  );

  static TextStyle storyCardTitle({Color? color}) => _nunito(
    size: 16,
    weight: FontWeight.w800,
    color: color ?? AppColors.slate900,
  );

  static TextStyle celebrationTitle({Color? color}) => _nunito(
    size: 32,
    weight: FontWeight.w900,
    color: color,
  );

  static TextStyle bodyLarge({Color? color}) => _mitr(
    size: 17,
    weight: FontWeight.w600,
    height: 1.45,
    color: color ?? AppColors.textSecondary,
  );

  static TextStyle bodyMedium({Color? color}) => _mitr(
    size: 15,
    weight: FontWeight.w600,
    height: 1.35,
    color: color ?? AppColors.textOrange,
  );

  static TextStyle bodySmall({Color? color}) => _mitr(
    size: 13,
    weight: FontWeight.w500,
    height: 1.35,
    color: color ?? AppColors.textSecondary,
  );

  static TextStyle caption({Color? color}) => _mitr(
    size: 12,
    weight: FontWeight.w700,
    color: color ?? AppColors.textOrange,
  );

  static TextStyle actionLabel({Color? color}) => _mitr(
    size: 12,
    weight: FontWeight.w800,
    color: color ?? AppColors.iconOrange,
  );

  static TextStyle badge({required Color color}) => _mitr(
    size: 12,
    weight: FontWeight.w700,
    color: color,
  );

  static TextStyle karaoke({Color? color}) => _mitr(
    size: 30,
    weight: FontWeight.w700,
    height: 1.42,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle karaokeActive({Color? color}) => _mitr(
    size: 30,
    weight: FontWeight.w700,
    height: 1.42,
    color: color ?? AppColors.karaokeActive,
  ).copyWith(backgroundColor: AppColors.yellow300);

  static TextStyle karaokeDim({Color? color}) => _mitr(
    size: 30,
    weight: FontWeight.w700,
    height: 1.42,
    color: color ?? AppColors.karaokeDim,
  );

  static TextTheme textTheme() {
    return TextTheme(
      displayLarge: appTitle(),
      headlineLarge: screenTitle(),
      headlineMedium: sectionTitle(),
      titleLarge: cardTitle(),
      titleMedium: modeTitle(),
      bodyLarge: bodyLarge(),
      bodyMedium: bodyMedium(),
      bodySmall: bodySmall(),
      labelLarge: actionLabel(),
      labelMedium: caption(),
    );
  }
}
